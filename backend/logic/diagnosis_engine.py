import pickle

# Load the trained model (hardcoded for now)
def load_model():
    with open('diagnosis_model.pkl', 'rb') as f:
        model = pickle.load(f)
    return model

def match_disease(session_data):
    model = load_model()

    # You can process session_data here as needed
    symptoms_text = " ".join(session_data.get("symptoms", [])) + " " + session_data.get("duration", "") + " " + session_data.get("severity", "")
    
    # Assuming the model accepts a string for matching or further processing
    diagnosis = model.predict([symptoms_text])  # You should modify this based on your model's input format
    
    return {
        "condition": diagnosis[0],  # Replace with your model's output
        "urgency": "medium",         # Set based on your model's logic
        "care_tips": ["Visit a doctor", "Take rest"]  # Adjust accordingly
    }
