import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from services.response_parser import process_ollama_response

def extract_info_from_llm_response(llm_response: str):
    return process_ollama_response(llm_response)
