from fastapi import APIRouter, Request
from services.ollama_client import ask_ollama
from services.extract_from_llm_response import extract_info_from_llm_response
from services.prompt_builder import build_prompt
from sessions.session_manager import SessionManager
from services.ai_engine import get_ai_response
from services.user_profile import fetch_user_profile

router = APIRouter()
sessions = {}

@router.post("/start_session")
async def start_session(request: Request):
    body = await request.json()
    user_id = body["user_id"]

    profile = fetch_user_profile(user_id)
    session = SessionManager(user_id)
    session.update(profile)

    sessions[user_id] = session
    return {"message": "Session started."}

@router.post("/chat")
async def chat(request: Request):
    body = await request.json()
    user_id = body["user_id"]
    message = body["message"]

    # Retrieve or create session
    session = sessions.get(user_id)
    if not session:
        session = SessionManager(user_id)
        sessions[user_id] = session

    # Build prompt using user message, history, and current data
    prompt = build_prompt(message, session.get_chat_history(), session.get_data())
    
    # Call Ollama API to get the AI's response and follow-up question
    follow_up = ask_ollama(prompt)
    
    # Append history with the latest exchange (user message and AI response)
    session.append_history(user_message=message, ai_response=follow_up)

    # Process the LLM's response and extract the relevant information
    extracted_data = extract_info_from_llm_response(follow_up)
    
    # Update the session with the extracted data
    session.update(extracted_data)

    # Check if the session is complete (i.e., all required data is gathered)
    if session.is_complete():
        # If complete, get a final AI response
        result = get_ai_response(session.get_data())  # Generate the final AI response based on the full data
        return {"response": f"{follow_up}\n\n{result}"}

    return {"response": follow_up}  # If not complete, return the follow-up from LLM


@router.post("/end_session")
async def end_session(request: Request):
    body = await request.json()
    user_id = body["user_id"]

    if user_id in sessions:
        sessions.pop(user_id)

    return {"message": "Session ended."}