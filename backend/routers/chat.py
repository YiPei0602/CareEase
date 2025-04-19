from fastapi import APIRouter
from schemas import ChatRequest, ChatResponse, SessionCreateRequest
from logic.diagnose import diagnose_user_input
from sessions.session_manager import load_sessions, save_sessions, create_session

router = APIRouter()

@router.post("/message", response_model=ChatResponse)
def handle_message(request: ChatRequest):
    result = diagnose_user_input(request.message, request.session_id)
    return result

@router.get("/sessions")
def list_sessions():
    return load_sessions()

@router.post("/sessions")
def create_new_session(req: SessionCreateRequest):
    return create_session(req.title)