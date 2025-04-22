import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import requests
from services.prompt_builder import build_prompt
from services.response_parser import process_ollama_response

OLLAMA_HOST = "http://localhost:11434"
MODEL_NAME = "doctor-phi3"
# MODEL_NAME = "llama3.2:1b "

def ask_ollama(prompt: str):
    try:
        res = requests.post(
            f"{OLLAMA_HOST}/api/generate",
            json={"model": MODEL_NAME, "prompt": prompt, "stream": False}
        )
        if res.status_code != 200:
            print(f"❌ Extraction failed: Error code: {res.status_code} - {res.text}")
            return None

        response_json = res.json()["response"]

        # If already a dict, return directly (Ollama streaming returns may do this)
        if isinstance(response_json, dict):
            return response_json

        # If it's a string, try to parse it
        return process_ollama_response(response_json)

    except Exception as e:
        print(f"❌ Error extracting from LLM: {e}")
        return None
