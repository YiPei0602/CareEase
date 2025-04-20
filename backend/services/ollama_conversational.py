# services/ollama_conversational.py
import requests
from services.response_parser import process_ollama_response

OLLAMA_HOST = "http://localhost:11434"
MODEL_NAME = "doctor-phi3"

def build_followup_prompt(user_message, history):
    structured_history = "\n".join([f"User: {h['user']}\nAI: {h['ai']}" for h in history])
    prompt = f"""
You are a helpful medical assistant. For each user message, extract structured info or ask follow-up questions if needed.

Instructions:
- Extract: symptoms, duration, triggers, urgency
- If anything is missing or unclear, ask a follow-up.
- Respond in natural language + JSON block.

Example:

User: I have chest pain.
AI: Could you describe the pain (sharp, dull, burning)? How long has it lasted?
{{
  "symptoms": ["chest pain"],
  "duration": null,
  "triggers": [],
  "urgency": "medium"
}}

Now continue the conversation.

{structured_history}
User: {user_message}
AI:"""
    return prompt.strip()

def ask_ollama_conversational(user_message, history=[]):
    prompt = build_followup_prompt(user_message, history)
    res = requests.post(
        f"{OLLAMA_HOST}/api/generate",
        json={"model": MODEL_NAME, "prompt": prompt, "stream": False}
    )
    raw_response = res.json()["response"]
    structured_data = process_ollama_response(raw_response)
    return {
        "ai_message": raw_response.strip(),
        "data": structured_data
    }
