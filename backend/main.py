from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from did_streamer import router as did_router

app = FastAPI()

# Add CORSMiddleware to allow cross-origin requests (important for frontend communication)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins or specify a list of allowed origins
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

# Register the D-ID router for avatar-related requests
app.include_router(did_router)

# Define the chat request schema (ensures that the incoming data is structured correctly)
class ChatRequest(BaseModel):
    message: str  # The field name should match the name in your frontend request

# Sample conversation flow based on user inputs
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
    "stiff neck": {
        "response": "Diagnose: You might have a migraine or meningitis. I recommend seeing a doctor if symptoms persist.\n\nBased on your symptoms, I suggest consulting a Neurologist in your area. Would you like to make an appointment?",
        "options": ["Yes", "No"],
        "diagnosis": "Migraine/Meningitis",
        "symptoms": ["Severe Headache (7-10)", "Stiff Neck"]
    },
    "nausea": {
        "response": "Diagnose: This could be a sign of a migraine or another neurological issue.\n\nBased on your symptoms, I suggest consulting a Neurologist in your area. Would you like to make an appointment?",
        "options": ["Yes", "No"],
        "diagnosis": "Migraine/Neurological Issue",
        "symptoms": ["Severe Headache (7-10)", "Nausea"]
    },
    "sensitive to light": {
        "response": "Diagnose: Light sensitivity often accompanies migraines or eye strain.\n\nBased on your symptoms, I suggest consulting an Ophthalmologist in your area. Would you like to make an appointment?",
        "options": ["Yes", "No"],
        "diagnosis": "Migraine/Eye Strain",
        "symptoms": ["Severe Headache (7-10)", "Light Sensitivity"]
    },
    "none of these": {
        "response": "Diagnose: It might just be a regular headache. Stay hydrated and rest.\n\nBased on your symptoms, I suggest consulting a General Practitioner in your area. Would you like to make an appointment?",
        "options": ["Yes", "No"],
        "diagnosis": "Regular Headache",
        "symptoms": ["Severe Headache (7-10)"]
    },
    "no": {
        "response": "Would you like personalized recommendations based on your symptoms and health profile?",
        "options": ["Yes", "No"]
    },
    "yes": {
        "response": "Based on your symptoms, here are some personalized recommendations:\n\n1. Maintain a regular sleep schedule and ensure 7-8 hours of sleep\n2. Stay hydrated by drinking at least 2 liters of water daily\n3. Practice stress management techniques like meditation\n4. Keep a headache diary to track triggers\n5. Consider dietary changes to avoid potential triggers\n\nWould you like to add these recommendations to your Daily Reminder for tracking?",
        "options": ["Add to Reminder", "No Thanks"],
        "recommendations": [
            "Maintain 7-8 hours of sleep",
            "Drink 2 liters of water",
            "Practice meditation",
        ]
    },
    "add to reminder": {
        "response": "I've added these recommendations to your Daily Reminder. You can track your progress in the Daily Tracker section.",
        "redirect": "gamification"
    },
    "no thanks": {
        "response": "Would you like a summary report of our conversation?",
        "options": ["Yes", "No"]
    }
}

# Define the POST /chat endpoint to handle the chat messages
@app.post("/chat")
async def chat_endpoint(request: ChatRequest):
    user_input = request.message.lower()  # Convert user input to lowercase for matching

    if user_input in conversation_flow:
        response = conversation_flow[user_input]
        if isinstance(response, dict):  # If there are options, return them too
            return {
                "response": response["response"],
                "options": response.get("options", []),
                "redirect": response.get("redirect", None),
                "diagnosis": response.get("diagnosis", None),
                "symptoms": response.get("symptoms", []),
                "recommendations": response.get("recommendations", [])
            }
        return {"response": response}  # Return just the response if no options

    # Default response if the input is not recognized
    return {"response": "I'm here to help! Please describe your symptoms."}
