import httpx

BASE_URL = "http://localhost:8000"  # Adjust if hosted elsewhere
USER_ID = "user123"  # Simulate a unique user

# Start a new session
def test_start_session():
    response = httpx.post(f"{BASE_URL}/start_session", json={"user_id": USER_ID})
    print("STATUS CODE:", response.status_code)
    print("RESPONSE TEXT:", response.text)  # ← See what's actually returned
    try:
        print("JSON RESPONSE:", response.json())
    except Exception as e:
        print("JSON DECODE ERROR:", e)
        
# Chat and add symptom
def test_chat_symptom(message):
    response = httpx.post(f"{BASE_URL}/chat", json={"user_id": USER_ID, "message": message})
    print("CHAT:", response.json())

# Close the session manually
def test_close_session():
    response = httpx.post(f"{BASE_URL}/end_session", json={"user_id": USER_ID})
    print("CLOSE SESSION:", response.json())

# Simulate giving feedback (add a new endpoint in your backend for this!)
def test_give_feedback(session_id, feedback):
    response = httpx.post(f"{BASE_URL}/feedback", json={"session_id": session_id, "feedback": feedback})
    print("GIVE FEEDBACK:", response.json())

# Run everything
if __name__ == "__main__":
    test_start_session()

    # Simulate a conversation
    test_chat_symptom("I feel sharp pain in my stomach")
    test_chat_symptom("It’s been 3 days")
    test_chat_symptom("The pain is severe")
    test_chat_symptom("I am a 26-year-old female")

    # Optional: Close early or complete
    test_close_session()
