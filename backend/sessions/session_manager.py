

import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import uuid

# Initialize Firebase
if not firebase_admin._apps:
    cred = credentials.Certificate(
        r"C:\Users\xiang\Desktop\Vhack25\CareEase\firebase\caseease-6397e-firebase-adminsdk-fbsvc-cc704ea4f5.json"
    )
    firebase_admin.initialize_app(cred)

db = firestore.client()

class SessionManager:
    def __init__(self, user_id, session_id=None):
        self.user_id = user_id
        self.session_id = session_id or str(uuid.uuid4())
        self.data = {
            # identifiers
            "user_id": user_id,
            "session_id": self.session_id,
            "status": "in_progress",
            # required symptom info
            "symptoms": [],
            "duration": None,
            "severity": None,
            "body_part": None,
            "triggers": [],
            "context": None,
            # basic profile (to confirm once)
            "name": None,
            "age": None,
            "gender": None,
            # medical history fields
            "weight": None,
            "height": None,
            "medical_conditions": [],
            "medications": [],
            "hospitalizations": [],
            "family_history": [],
            "lifestyle": [],
            # chat history and feedback
            "history": [],
            "diagnosis": None,
            "explanation": None,
            "specialist": None,
            "care_tips": [],
            "feedback_due": None,
            "feedback": None,
            "created_at": datetime.utcnow().isoformat()
        }

    def update(self, updates: dict):
        for key, value in updates.items():
            if key in self.data and isinstance(self.data[key], list):
                if isinstance(value, list):
                    self.data[key].extend(value)
                else:
                    self.data[key].append(value)
            else:
                self.data[key] = value

    def append_history(self, user_message, ai_response):
        self.data["history"].append({
            "user": user_message,
            "ai": ai_response,
            "timestamp": datetime.utcnow().isoformat()
        })

    def mark_complete(self):
        self.data["status"] = "completed"

    def close(self):
        self.data["status"] = "closed"

    def save(self):
        db.collection("sessions").document(self.session_id).set(self.data)

    def load(self):
        doc_ref = db.collection("sessions").document(self.session_id)
        doc = doc_ref.get()
        if doc.exists:
            self.data = doc.to_dict()
        else:
            print(f"[WARN] Session not found: {self.session_id}, starting fresh.")

    def is_complete(self):
        required = [
            "symptoms", "duration", "severity",
            "body_part", "triggers", "context"
        ]
        # check that each required field is non-null or non-empty
        for field in required:
            val = self.data.get(field)
            if val is None or (isinstance(val, (list, str)) and not val):
                return False
        return True

    def get_data(self):
        return self.data

    def get_chat_history(self):
        return self.data.get("history", [])

    def delete(self):
        db.collection("sessions").document(self.session_id).delete()