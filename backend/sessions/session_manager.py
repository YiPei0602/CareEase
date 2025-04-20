import json
import os

SESSIONS_DIR = "data/sessions"
os.makedirs(SESSIONS_DIR, exist_ok=True)

class SessionManager:
    def __init__(self, user_id):
        self.user_id = user_id
        self.data = {
            "symptoms": [],
            "duration": None,
            "severity": None,
            "age": None,
            "gender": None,
            "history": []  # Stores conversation history
        }

    def update(self, updates: dict):
        for key, value in updates.items():
            if key in self.data:
                if isinstance(self.data[key], list):
                    self.data[key].append(value)
                else:
                    self.data[key] = value
            else:
                self.data[key] = value

    def get_data(self):
        return self.data

    def append_history(self, user_message: str, ai_response: str):
        """ Append the user's message and AI's response to the history """
        self.data["history"].append({"user": user_message, "ai": ai_response})

    def get_chat_history(self):
        """ Return the conversation history """
        return self.data["history"]

    def is_complete(self):
        """ Check if the session is complete (i.e., all required info is gathered) """
        required_fields = ["symptoms", "duration", "severity", "age", "gender"]
        for field in required_fields:
            if not self.data.get(field):
                return False
        return True

def save_session(user_id, data):
    with open(os.path.join(SESSIONS_DIR, f"{user_id}.json"), "w") as f:
        json.dump(data, f)

def load_session(user_id):
    path = os.path.join(SESSIONS_DIR, f"{user_id}.json")
    if os.path.exists(path):
        with open(path, "r") as f:
            return json.load(f)
    return None

def delete_session(user_id):
    path = os.path.join(SESSIONS_DIR, f"{user_id}.json")
    if os.path.exists(path):
        os.remove(path)
