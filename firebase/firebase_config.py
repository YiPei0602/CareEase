import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase with the service account credentials
cred = credentials.Certificate("C:\\Users\\User\\Documents\\CareEase\\firebase\\caseease-6397e-firebase-adminsdk-fbsvc-cc704ea4f5.json")
firebase_admin.initialize_app(cred)

# Access Firestore
db = firestore.client()
