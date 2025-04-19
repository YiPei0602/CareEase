from pydantic import BaseModel
from typing import List, Optional

class ChatRequest(BaseModel):
    session_id: str
    message: str

class ChatResponse(BaseModel):
    response: str
    session_id: str
    symptoms_detected: List[str] = []
    possible_diseases: List[str] = []

class SessionCreateRequest(BaseModel):
    title: str

class SessionInput(BaseModel):
    session_id: str
    message: str

class BotResponse(BaseModel):
    session_id: str
    reply: str
    questions: Optional[List[str]] = []
    diagnosis: Optional[str] = None
    suggestions: Optional[List[str]] = []