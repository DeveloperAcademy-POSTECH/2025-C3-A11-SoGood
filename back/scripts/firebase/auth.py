from firebase_admin import credentials, firestore
import firebase_admin
from pathlib import Path

def firebase_auth():
    try:
        current_dir = Path(__file__).parent

        firebase_key_path = current_dir / "../../data/firebase-key.json"

        if not firebase_admin._apps:
            cred = credentials.Certificate(firebase_key_path)
            firebase_admin.initialize_app(cred)
        return firestore.client()
    
    except Exception as e:
        print(f"Firebase 인증 오류: {e}")
        return None
