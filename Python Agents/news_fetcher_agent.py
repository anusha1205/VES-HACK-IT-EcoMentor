import requests
import json
import time
from datetime import datetime, timedelta
from config import NYT_API_KEY
from firebase_service import upload_news_to_firebase, delete_old_news

# New York Times API Endpoint
NYT_API_URL = "https://api.nytimes.com/svc/search/v2/articlesearch.json"

# Reduced set of keywords focused on most important climate topics
CLIMATE_KEYWORDS = [
    "climate change",
    "global warming",
    "renewable energy",
    "extreme weather",
    "climate crisis",
    "carbon emissions",
    "climate policy",
    "environmental conservation"
]

# Constants for article limits
MAX_TOTAL_ARTICLES = 20  # Maximum total articles to fetch
MAX_ARTICLES_TO_SUMMARIZE = 15  # Maximum articles to summarize

def fetch_news(keyword, page=0, retries=3):
    """
    Fetch news articles from NYT API for a single keyword.
    :param keyword: Keyword for searching articles
    :param page: Page number for pagination
    :param retries: Number of retry attempts in case of rate limit errors
    :return: List of news articles or an empty list
    """
    params = {
        "q": keyword,
        "fq": "news_desk:(\"Science\" \"Environment\") AND subject:(\"Global Warming\" \"Climate Change\" \"Greenhouse Gas Emissions\")",
        "sort": "newest",
        "page": page,
        "api-key": NYT_API_KEY
    }

    headers = {
        "Accept": "application/json",
        "User-Agent": "EcoMentor Climate News App"
    }

    wait_time = 2  # Initial wait time for retrying
    for attempt in range(retries):
        try:
            print(f"Making request to NYT API for keyword: {keyword}, page: {page}")
            print(f"Request URL: {NYT_API_URL}?{'&'.join(f'{k}={v}' for k, v in params.items())}")
            
            response = requests.get(NYT_API_URL, params=params, headers=headers)
            
            # Print response status for debugging
            print(f"Response status: {response.status_code}")
            if response.status_code != 200:
                print(f"Error response: {response.text}")
                if response.status_code == 401:
                    print("Authentication error. Please check your API key.")
                    break
            
            # Handle rate limit (429 error)
            if response.status_code == 429:
                print(f"Rate limit hit for '{keyword}'. Retrying in {wait_time} seconds...")
                time.sleep(wait_time)
                wait_time *= 2  # Exponential backoff
                continue

            response.raise_for_status()
            data = response.json()
            
            # Check if we got a valid response
            if "response" not in data:
                print(f"Unexpected API response: {data}")
                return []
            
            # Transform NYT response to our format
            articles = []
            for doc in data.get("response", {}).get("docs", []):
                # Print each article's basic info for debugging
                print(f"Processing article: {doc.get('headline', {}).get('main', '')}")
                
                article = {
                    "title": doc.get("headline", {}).get("main", ""),
                    "description": doc.get("abstract", ""),
                    "content": doc.get("lead_paragraph", ""),
                    "url": doc.get("web_url", ""),
                    "image_url": get_image_url(doc),
                    "source": "The New York Times",
                    "publishedAt": doc.get("pub_date", ""),
                    "tags": extract_tags(doc),
                    "needs_summary": False  # Flag to track which articles need summarization
                }
                articles.append(article)
            
            return articles

        except requests.exceptions.RequestException as e:
            print(f"Error fetching news for '{keyword}': {e}")
            if attempt < retries - 1:
                time.sleep(wait_time)
                wait_time *= 2
            else:
                return []

def get_image_url(doc):
    """
    Extract image URL from NYT article document.
    """
    multimedia = doc.get("multimedia", [])
    for media in multimedia:
        if media.get("type") == "image":
            return f"https://static01.nyt.com/{media.get('url', '')}"
    return ""  # Return empty string if no image found

def extract_tags(doc):
    """
    Extract relevant tags from NYT article document.
    """
    tags = []
    keywords = doc.get("keywords", [])
    for keyword in keywords:
        if keyword.get("name") in ["subject", "organizations", "glocations"]:
            tags.append(keyword.get("value", "").lower())
    return list(set(tags))  # Remove duplicates

def remove_duplicates_by_title(articles):
    """
    Remove duplicate articles based on their titles.
    :param articles: List of articles
    :return: List of unique articles
    """
    seen_titles = set()
    unique_articles = []

    for article in articles:
        title = article.get("title", "").lower()
        if title and title not in seen_titles and len(unique_articles) < MAX_TOTAL_ARTICLES:
            seen_titles.add(title)
            # Mark the first MAX_ARTICLES_TO_SUMMARIZE articles for summarization
            article["needs_summary"] = len(unique_articles) < MAX_ARTICLES_TO_SUMMARIZE
            unique_articles.append(article)

    return unique_articles

def main():
    """
    Main function to fetch and process news articles.
    """
    print("Starting news fetch process...")
    
    # First, clean up old news
    delete_old_news(days=7)
    print("Cleaned up old news articles")

    all_articles = []
    
    # Fetch news for each keyword until we reach the desired number of articles
    for keyword in CLIMATE_KEYWORDS:
        if len(all_articles) >= MAX_TOTAL_ARTICLES:
            break
            
        print(f"Fetching news for keyword: {keyword}")
        articles = fetch_news(keyword, page=0)  # Only fetch first page
        if articles:
            all_articles.extend(articles)
            print(f"Found {len(articles)} articles for '{keyword}'")
        time.sleep(6)  # NYT API has a rate limit of 10 requests per minute

    # Remove duplicates and limit to MAX_TOTAL_ARTICLES
    unique_articles = remove_duplicates_by_title(all_articles)
    print(f"Total unique articles found: {len(unique_articles)}")
    print(f"Articles to be summarized: {sum(1 for a in unique_articles if a['needs_summary'])}")

    # Upload to Firebase
    if unique_articles:
        upload_news_to_firebase(unique_articles)
        print("Successfully uploaded articles to Firebase")
    else:
        print("No articles to upload")

if __name__ == "__main__":
    main()