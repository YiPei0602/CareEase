# import firebase_admin
# from firebase_admin import credentials, firestore

# # Initialize Firebase
# cred = credentials.Certificate("C:/Users/User/Documents/CareEase/firebase/caseease-6397e-firebase-adminsdk-fbsvc-cc704ea4f5.json")
# firebase_admin.initialize_app(cred)

# db = firestore.client()

# def save_to_firebase(data, session_id):
#     """Save session data to Firebase."""
#     db.collection("sessions").document(session_id).set(data)

# def load_from_firebase(session_id):
#     """Load session data from Firebase."""
#     doc = db.collection("sessions").document(session_id).get()
#     if doc.exists:
#         return doc.to_dict()
#     else:
#         return None

# def delete_from_firebase(session_id):
#     """Delete session data from Firebase."""
#     db.collection("sessions").document(session_id).delete()
