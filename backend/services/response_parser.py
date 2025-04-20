import re
import json

def process_ollama_response(response: str):
    try:
        # Remove the comment part (anything after "//") from the response
        response = re.sub(r"//.*", "", response)

        # Try to find the JSON block in the response string
        match = re.search(r'\{[\s\S]*?\}', response)
        if not match:
            raise ValueError("No JSON block found in response")

        json_data = match.group(0)
        json_data = json_data.replace("'", '"')  # Fix single quotes to double quotes (JSON standard)
        json_data = re.sub(r",\s*}", "}", json_data)  # Remove trailing commas before closing curly brace
        json_data = re.sub(r",\s*\]", "]", json_data)  # Remove trailing commas before closing square bracket

        # Load JSON data from the cleaned string
        data = json.loads(json_data)

        # Return the extracted information
        return {
            "symptoms": data.get("symptoms", []),
            "duration": data.get("duration"),
            "triggers": data.get("triggers", []),
            "urgency": data.get("urgency", "low")
        }

    except Exception as e:
        print("❌ Failed to parse LLM output:", e)
        print("🧾 Raw response was:", response)
        return {
            "symptoms": [],
            "duration": None,
            "triggers": [],
            "urgency": "low"
        }
