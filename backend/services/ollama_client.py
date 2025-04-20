import requests
from services.prompt_builder import build_prompt
from services.response_parser import process_ollama_response

OLLAMA_HOST = "http://localhost:11434"
MODEL_NAME = "doctor-phi3"

def ask_ollama(prompt: str):
    try:
        res = requests.post(
            f"{OLLAMA_HOST}/api/generate",
            json={"model": MODEL_NAME, "prompt": prompt, "stream": False}
        )
        if res.status_code != 200:
            print(f"❌ Extraction failed: Error code: {res.status_code} - {res.text}")
            return None

        response_text = res.json()["response"]
        return process_ollama_response(response_text)

    except Exception as e:
        print(f"❌ Error extracting from LLM: {e}")
        return None
