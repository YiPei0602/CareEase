def build_prompt(message: str, history: list = [], current_data: dict = {}) -> str:
    history_text = "\n".join([f"User: {h['user']}\nAI: {h['ai']}" for h in history])
    symptom_info = ", ".join(f"{k}: {v}" for k, v in current_data.items() if v)

    return f"""
You are a helpful AI medical assistant. You're gathering details for a health consultation. 

Return ONLY a JSON block with the following keys:
- symptoms (list of symptom keywords)
- duration (string or null)
- triggers (list of triggers if mentioned)
- urgency (string: "high" for severe cases like chest pain or bleeding, "medium" for persistent discomfort, "low" for minor issues)

If you don't have enough information to fill in a field, return null or an empty list — and ask the user a clarifying question.

Here are examples:

User: "I have had a sharp pain in my lower back for two days. It gets worse when I sit."
AI: {{
  "symptoms": ["sharp pain", "lower back pain"],
  "duration": "2 days",
  "triggers": ["sitting"],
  "urgency": "medium"
}}

User: "I’ve had a dull ache in my chest and arm for about a week. It gets worse when I walk uphill."
AI: {{
  "symptoms": ["dull ache", "chest pain", "arm pain"],
  "duration": "about a week",
  "triggers": ["walking uphill"],
  "urgency": "medium"
}}

Current known info: {symptom_info or 'None'}

Chat history so far:
{history_text}

Now the user says: "{message}"
AI:
"""
