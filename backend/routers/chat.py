from fastapi import APIRouter, Request, HTTPException
from services.ollama_client import ask_ollama
from services.extract_from_llm_response import extract_info_from_llm_response
from services.prompt_builder import build_prompt
from sessions.session_manager import SessionManager
from services.ai_engine import get_ai_response
from services.user_profile import get_user_profile
from firebase_admin import firestore

router = APIRouter()
db = firestore.client()

@router.post("/start_session")
async def start_session(request: Request):
    body = await request.json()
    user_id = body["user_id"]

    # Try to find existing in-progress session
    docs = db.collection("sessions") \
        .where("user_id", "==", user_id) \
        .where("status", "==", "in_progress") \
        .order_by("created_at", direction=firestore.Query.DESCENDING) \
        .limit(1) \
        .stream()

    session_doc = next(docs, None)
    if session_doc:
        session_id = session_doc.id
        session = SessionManager(user_id, session_id)
        session.load()
        return {"message": "Resumed previous session", "session_id": session_id}

    # Else start a new one
    session = SessionManager(user_id)
    session.save()
    return {"message": "New session started", "session_id": session.session_id}

@router.post("/chat")
async def chat(request: Request):
    body = await request.json()
    user_id = body["user_id"]
    message = body.get("message")
    session_id = body.get("session_id")

    if message is None or session_id is None:
        raise HTTPException(status_code=400, detail="Missing 'message' or 'session_id'")

    session = SessionManager(user_id, session_id)
    session.load()

    # Check if session is already completed or closed
    if session.get_data().get("status") in ["completed", "closed"]:
        return {"error": "This session is already completed or closed. Please start a new session."}

    # Build prompt
    prompt = build_prompt(message, session.get_chat_history(), session.get_data())

    # AI response
    follow_up = ask_ollama(prompt)
    session.append_history(user_message=message, ai_response=follow_up)

    # Extract and update
    extracted_data = extract_info_from_llm_response(follow_up)
    session.update(extracted_data)

    # Save
    if session.is_complete():
        session.mark_complete()
    session.save()

    # Final response
    if session.is_complete():
        result = get_ai_response(session.get_data())
        return {"response": f"{follow_up}\n\n{result}"}

    return {"response": follow_up}

@router.post("/end_session")
async def end_session(request: Request):
    body = await request.json()
    user_id = body.get("user_id")
    session_id = body.get("session_id")

    if not user_id or not session_id:
        raise HTTPException(status_code=400, detail="Missing 'user_id' or 'session_id'")

    session = SessionManager(user_id, session_id)
    session.load()

    # Mark session as closed
    session.close()
    session.save()

    return {"message": "Session closed."}

@router.post("/feedback")
async def submit_feedback(request: Request):
    body = await request.json()
    session_id = body.get("session_id")
    feedback = body.get("feedback")

    if not session_id or not feedback:
        raise HTTPException(status_code=400, detail="Missing session_id or feedback")

    doc_ref = db.collection("sessions").document(session_id)
    doc = doc_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Session not found")

    doc_ref.update({"feedback": feedback})
    return {"message": "Feedback submitted"}
