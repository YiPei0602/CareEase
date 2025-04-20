import json

# This is an example of AI response generation logic, customize as needed
def get_ai_response(session_data: dict):
    """
    Generate the AI response based on session data.
    This could involve integrating the LLM response or using rules.
    """
    # You can customize this logic to generate responses based on the data.
    if session_data.get("symptoms") and session_data.get("urgency"):
        symptoms = ", ".join(session_data["symptoms"])
        urgency = session_data["urgency"]
        return f"The reported symptoms are {symptoms}. The urgency level is {urgency}."
    
    return "Can you provide more details about your symptoms?"

