import json
import os
import uuid

SESSION_PATH = os.path.join("sessions", "session_data.json")

def load_sessions():
    if not os.path.exists(SESSION_PATH):
        return {}
    with open(SESSION_PATH, "r") as file:
        return json.load(file)

def save_sessions(data):
    with open(SESSION_PATH, "w") as file:
        json.dump(data, file, indent=2)
    pass

def update_session(session_id, user_input, symptoms, diseases):
    sessions = load_sessions()
    if session_id not in sessions:
        sessions[session_id] = {"history": []}
    sessions[session_id]["history"].append({
        "input": user_input,
        "symptoms": symptoms,
        "diseases": diseases
    })
    save_sessions(sessions)

def create_session(title):
    session_id = str(uuid.uuid4())
    sessions = load_sessions()
    sessions[session_id] = {"title": title, "history": []}
    save_sessions(sessions)
    return {"session_id": session_id, "title": title}