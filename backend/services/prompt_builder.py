def build_prompt(message: str, history: list = [], current_data: dict = {}, user_profile: dict = {}) -> str:
    history_text = "\n".join([f"User: {h['user']}\nAI: {h['ai']}" for h in history])
    profile_info = ", ".join(f"{k}: {v}" for k, v in user_profile.items())
    symptom_info = ", ".join(f"{k}: {v}" for k, v in current_data.items() if v)

    return f"""
You are a helpful AI doctor assistant collecting medical intake info for diagnosis.

First, confirm these profile details:
{profile_info}

Then, ask follow-up questions to collect the following:
- symptoms (list)
- duration (string)
- signs (list)
- triggers (list)

Use this format ONLY as your response (valid JSON block):
{{
  "symptoms": [...],
  "duration": "...",
  "triggers": [...],
  "urgency": "low/medium/high"
}}

If not enough data is provided, leave unknowns as null or empty lists and ask for clarification.
⚠️ Do not include explanations, extra text, markdown (like ```json), or comments (// ...). Only return raw JSON.

Known so far:
{symptom_info or 'None'}

Conversation history:
{history_text}

User says: "{message}"
AI:
"""
