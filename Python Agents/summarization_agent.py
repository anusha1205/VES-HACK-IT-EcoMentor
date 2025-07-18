import json
import requests
import time
from firebase_service import get_unsummarized_news, update_news_summary

def get_summary(text, max_length=150, max_retries=3):
    """
    Get a summary of the text using the Ollama API with Mistral model.
    :param text: Text to summarize
    :param max_length: Maximum length of the summary
    :param max_retries: Maximum number of retry attempts
    :return: Summarized text
    """
    url = "http://localhost:11434/api/generate"
    
    # Limit input text length to manage memory
    max_input_length = 1000  # Reduced input length to prevent memory issues
    text = text[:max_input_length] if len(text) > max_input_length else text
    
    prompt = f"""Summarize this news article in {max_length} characters or less:

    {text}

    Keep only the most important points and maintain a neutral tone.
    """
    
    data = {
        "model": "mistral",
        "prompt": prompt,
        "stream": False,
        "options": {
            "num_ctx": 1024,  # Reduced context size
            "temperature": 0.3,
            "top_p": 0.9,
            "repeat_penalty": 1.1
        }
    }
    
    for attempt in range(max_retries):
        try:
            print(f"Attempt {attempt + 1}/{max_retries} to generate summary...")
            response = requests.post(url, json=data, timeout=30)
            
            if response.status_code == 500:
                print("Ollama server error. Waiting 5 seconds before retry...")
                time.sleep(5)
                continue
                
            response.raise_for_status()
            result = response.json()
            summary = result.get('response', '').strip()
            
            if summary:
                return summary[:max_length]  # Ensure we don't exceed max length
            else:
                print("Empty response from Ollama")
                
        except requests.exceptions.RequestException as e:
            print(f"Error getting summary (attempt {attempt + 1}/{max_retries}): {e}")
            if attempt < max_retries - 1:
                wait_time = (attempt + 1) * 5  # Increasing wait time between retries
                print(f"Waiting {wait_time} seconds before retrying...")
                time.sleep(wait_time)
            else:
                return None
    
    return None

def clean_text(text):
    """
    Clean the text by removing unnecessary whitespace and special characters.
    :param text: Text to clean
    :return: Cleaned text
    """
    if not text:
        return ""
        
    # Remove multiple newlines and spaces
    text = ' '.join(text.split())
    # Remove any non-ASCII characters
    text = text.encode('ascii', 'ignore').decode()
    return text

def main():
    """
    Main function to process and summarize news articles.
    """
    print("Starting summarization process...")
    print("Checking Ollama connection...")
    
    # Test Ollama connection first
    test_summary = get_summary("Test connection to Ollama.", max_length=50, max_retries=1)
    if test_summary is None:
        print("Error: Cannot connect to Ollama. Please make sure Ollama is running.")
        print("You can start it by running 'ollama serve' in a new terminal.")
        return
    
    print("Ollama connection successful!")
    
    while True:
        try:
            # Get unsummarized news from Firebase
            articles = get_unsummarized_news()
            
            if not articles:
                print("No articles to summarize. Checking again in 30 seconds...")
                time.sleep(30)
                continue
                
            print(f"Found {len(articles)} articles to summarize")
            
            for article in articles:
                try:
                    print(f"\nSummarizing article: {article['headline'][:50]}...")
                    
                    # Get the text to summarize (prefer content over description)
                    text_to_summarize = clean_text(article.get('content', ''))
                    
                    if not text_to_summarize:
                        print("No content to summarize, skipping...")
                        continue
                    
                    print(f"Content length: {len(text_to_summarize)} characters")
                    
                    # Get summary
                    summary = get_summary(text_to_summarize)
                    
                    if summary:
                        # Update the article with the summary in Firebase
                        update_news_summary(article['id'], summary)
                        print(f"Summary updated in Firebase ({len(summary)} chars): {summary[:100]}...")
                    else:
                        print("Failed to generate summary")
                    
                    # Wait between articles
                    time.sleep(5)
                    
                except Exception as e:
                    print(f"Error processing article {article.get('headline', 'Unknown')}: {e}")
                    time.sleep(5)
                    continue
            
            print("\nFinished current batch. Checking for more articles...")
            time.sleep(10)
            
        except Exception as e:
            print(f"Error in main loop: {e}")
            print("Retrying in 30 seconds...")
            time.sleep(30)

if __name__ == "__main__":
    main()