from services.response_parser import process_ollama_response

def extract_info_from_llm_response(llm_response):
    return process_ollama_response(llm_response)