import re
import json

def process_ollama_response(response_text):
    try:
        if isinstance(response_text, dict):
            # It's already a dict (maybe from a pre-parsed JSON response)
            print("🧾 LLM Response (dict):", response_text)
            return {
                "symptoms": response_text.get("symptoms", []),
                "duration": response_text.get("duration"),
                "triggers": response_text.get("triggers", []),
                "urgency": response_text.get("urgency"),
            }

        print("🧾 LLM RAW TEXT:\n", response_text)

        # Otherwise, assume it's a raw text block and extract JSON
        match = re.search(r"```json\s*(\{.*?\})\s*```", response_text, re.DOTALL)
        if not match:
            print("❌ No complete JSON block found.")
            return {}

        json_str = match.group(1)
        json_str = re.sub(r"//.*", "", json_str)  # remove inline comments

        parsed = json.loads(json_str)

        print("✅ Parsed JSON:\n", parsed)

        return {
            "symptoms": parsed.get("symptoms", []),
            "duration": parsed.get("duration"),
            "triggers": parsed.get("triggers", []),
            "urgency": parsed.get("urgency"),
        }

    except Exception as e:
        print(f"❌ Error processing LLM response: {e}")
        return {}
