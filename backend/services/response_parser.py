import re, json

def process_ollama_response(text):
    # strip code fences
    text = re.sub(r"```json|```", "", text)
    # extract JSON
    match = re.search(r"(\{[\s\S]*\})", text)
    if not match:
        return {"doctor_reply": text.strip(), "extracted_data": {}}
    obj = json.loads(match.group(1))
    return {
        "doctor_reply": obj.get("doctor_reply", ""),
        "extracted_data": obj.get("extracted_data", {})
    }