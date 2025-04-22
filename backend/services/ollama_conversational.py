# services/ollama_conversational.py
import requests
from services.response_parser import process_ollama_response

OLLAMA_HOST = "http://localhost:11434"
MODEL_NAME = "doctor-phi3"
# MODEL_NAME = "llama3.2:1b "

def build_followup_prompt(user_message, history, current_data):
    hist = "\n".join([f"User: {h['user']}\nAI: {h['ai']}" for h in history])
    # Only list missing fields
    missing = [
        k for k in [
            'symptoms','duration','severity','body_part',
            'triggers','context'
        ] if not current_data.get(k)
    ]
    missing_fields = ", ".join(missing)
    return f"""
You are an AI medical assistant.
Missing information: {missing_fields}.
Ask the user for the next missing detail.
Respond in JSON only, with two keys:
  "doctor_reply": a natural language question or confirmation,
  "extracted_data": an object with any fields you just extracted.
{hist}
User: {user_message}
AI:"""

def ask_ollama_conversational(user_message, history=[]):
    prompt = build_followup_prompt(user_message, history)
    res = requests.post(
        f"{OLLAMA_HOST}/api/generate",
        json={"model": MODEL_NAME.strip(), "prompt": prompt, "stream": False}
    )
    raw_response = res.json()["response"]
    structured_data = process_ollama_response(raw_response)
    return {
        "ai_message": raw_response.strip(),
        "data": structured_data
    }
