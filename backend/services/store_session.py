import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase
cred = credentials.Certificate("C:\\Users\\User\\Documents\\CareEase\\firebase\\caseease-6397e-firebase-adminsdk-fbsvc-cc704ea4f5.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Save session to Firebase
def save_to_firebase(user_id, data):
    doc_ref = db.collection("sessions").document(user_id)
    doc_ref.set(data)

# Load session from Firebase
def load_session(user_id):
    doc_ref = db.collection("sessions").document(user_id)
    doc = doc_ref.get()
    if doc.exists:
        return doc.to_dict()
    return None

# Delete session from Firebase
def delete_session(user_id):
    doc_ref = db.collection("sessions").document(user_id)
    doc_ref.delete()
