import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta
import hashlib
import os

# Initialize Firebase Admin
cred = credentials.Certificate('serviceAccountKey.json')  # You'll need to add this file
firebase_admin.initialize_app(cred)

db = firestore.client()

def upload_news_to_firebase(news_items):
    """
    Upload news items to Firebase Firestore.
    :param news_items: List of news items to upload
    """
    batch = db.batch()
    news_ref = db.collection('news')
    
    for item in news_items:
        # Create a unique ID based on the title to avoid duplicates
        news_id = hashlib.md5(item['title'].encode()).hexdigest()
        
        # Convert the news item to our app's format
        news_data = {
            'headline': item['title'],
            'summary': '',  # Empty summary to indicate it needs summarization
            'source': item.get('source', 'The New York Times'),
            'imageUrl': item.get('image_url', ''),
            'publishedDate': firestore.SERVER_TIMESTAMP,
            'url': item.get('url', ''),
            'readTime': 2,  # Default read time, will be updated based on content length
            'tags': item.get('tags', ['climate']),
            'isBookmarked': False,
            'content': item.get('content', ''),  # Original content for summarization
            'needs_summary': item.get('needs_summary', True),
            'lastUpdated': firestore.SERVER_TIMESTAMP
        }
        
        # Add to batch
        doc_ref = news_ref.document(news_id)
        batch.set(doc_ref, news_data, merge=True)
    
    # Commit the batch
    batch.commit()

def update_news_summary(news_id, summary):
    """
    Update the summary of a news item.
    :param news_id: The ID of the news item
    :param summary: The generated summary
    """
    news_ref = db.collection('news').document(news_id)
    news_ref.update({
        'summary': summary,
        'needs_summary': False,
        'lastUpdated': firestore.SERVER_TIMESTAMP
    })

def get_unsummarized_news():
    """
    Get news items that haven't been summarized yet.
    :return: List of news items needing summarization
    """
    news_ref = db.collection('news')
    items = []
    
    # Simple query that doesn't require complex index
    query = news_ref.where('needs_summary', '==', True).limit(10)
    
    try:
        for doc in query.stream():
            data = doc.to_dict()
            data['id'] = doc.id
            items.append(data)
            
        print(f"Successfully fetched {len(items)} articles that need summarization")
        return items
    except Exception as e:
        print(f"Error fetching articles: {e}")
        return []

def delete_old_news(days=7):
    """
    Delete news items older than specified days.
    :param days: Number of days to keep news
    """
    news_ref = db.collection('news')
    old_date = datetime.now() - timedelta(days=days)
    
    # Get old news
    old_news = news_ref.where('publishedDate', '<', old_date).stream()
    
    # Delete in batches
    batch = db.batch()
    for doc in old_news:
        batch.delete(doc.reference)
    batch.commit() 