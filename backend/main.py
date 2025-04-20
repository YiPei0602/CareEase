from fastapi import FastAPI
from pydantic import BaseModel
from did_streamer import router as did_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# ← insert this block here, immediately after `app = FastAPI()`
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register the D-ID router
app.include_router(did_router)

# Fix: Ensure the field name matches Flutter's request
class ChatRequest(BaseModel):
    message: str  # Changed from "text" to "message"

conversation_flow = {
    "hello": "Hi there! How can I assist you today?",
    "i have a headache": {
        "response": "How severe is your headache on a scale of 1-10?",
        "options": ["1-3", "4-6", "7-10"]
    },
    "7-10": {
        "response": "Got it. Do you have any of the following additional symptoms?",
        "options": ["Stiff Neck", "Nausea", "Sensitive to Light", "None of These"]
    },
    "stiff neck": "Diagnose: You might have a migraine or meningitis. I recommend seeing a doctor if symptoms persist.",
    "nausea": "Diagnose: This could be a sign of a migraine or another neurological issue.",
    "sensitive to light": "Diagnose: Light sensitivity often accompanies migraines or eye strain.",
    "none of these": "Diagnose: It might just be a regular headache. Stay hydrated and rest."
}

@app.post("/chat")
async def chat_endpoint(request: ChatRequest):
    user_input = request.message.lower()  # Make sure this matches

    if user_input in conversation_flow:
        response = conversation_flow[user_input]
        if isinstance(response, dict):
            return {"response": response["response"], "options": response.get("options", [])}
        return {"response": response}

    return {"response": "I'm here to help! Please describe your symptoms."}

