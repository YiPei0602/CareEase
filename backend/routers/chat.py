from fastapi import APIRouter, Request, HTTPException
from services.ollama_conversational import ask_ollama_conversational
from logic.diagnosis_engine import match_disease
from sessions.session_manager import SessionManager
from services.user_profile import get_user_profile
from datetime import datetime, timedelta
from firebase_admin import firestore

router = APIRouter()
db = firestore.client()

@router.post("/chat")
async def chat(request: Request):
    body = await request.json()
    user_id = body.get("user_id")
    message = body.get("message")
    session_id = body.get("session_id")

    if not user_id or not message:
        raise HTTPException(status_code=400, detail="Missing 'user_id' or 'message'")

    # Load existing or create new session
    session = SessionManager(user_id, session_id)
    session.load()

    # Profile confirmation step
    if session.get_data().get("name") is None:
        profile = get_user_profile(user_id)
        session.update(profile)
        confirm_q = (
            f"Just to confirm, you are {profile['name']}, "
            f"{profile['age']} years old, {profile['gender']}. Is that correct?"
        )
        session.append_history(user_message="(system)", ai_response=confirm_q)
        session.save()
        return {"session_id": session.session_id, "doctor_reply": confirm_q}

    # Call LLM for follow-up or extraction
    history = session.get_chat_history()
    result = ask_ollama_conversational(message, history, session.get_data())
    doctor_reply = result.get("doctor_reply", "")
    extracted = result.get("extracted_data", {})

    # Update session
    session.append_history(user_message=message, ai_response=doctor_reply)
    session.update(extracted)

    # Check if we have all required info
    if session.is_complete():
        session.mark_complete()
        # Trigger diagnosis engine
        diag = match_disease(session.get_data())
        session.update({
            "diagnosis": diag["condition"],
            "explanation": diag["explanation"],
            "specialist": diag["specialist"],
            "care_tips": diag["care_tips"],
            "feedback_due": (datetime.utcnow() + timedelta(days=3)).isoformat()
        })
        session.save()
        final_reply = (
            f"Based on your input, the most likely condition is {diag['condition']}. "
            f"Explanation: {diag['explanation']}. "
            f"You should see a {diag['specialist']}. "
            f"Care tips: {', '.join(diag['care_tips'])}."
        )
        return {"session_id": session.session_id, "doctor_reply": final_reply}

    # Not complete yet: ask next question
    session.save()
    return {"session_id": session.session_id, "doctor_reply": doctor_reply}