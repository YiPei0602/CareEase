from services.ollama_client import ask_ollama

if __name__ == "__main__":
    user_message = "I feel fast unwell."
    extracted_data = ask_ollama(user_message)
    print("🔍 Extracted Data:", extracted_data)