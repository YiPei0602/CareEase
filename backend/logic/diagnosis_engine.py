import pickle

def load_model():
    with open('diagnosis_model.pkl', 'rb') as f:
        return pickle.load(f)

def match_disease(session_data):
    model = load_model()

    symptoms_text = " ".join(session_data.get("symptoms", [])) + " " + session_data.get("duration", "")

    # Predict condition
    prediction = model.predict([symptoms_text])[0]  # e.g., "angina"

    # Example hardcoded explanation
    disease_data = {
        "angina": {
            "explanation": "Angina is chest pain caused by reduced blood flow to the heart muscles.",
            "specialist": "Cardiologist",
            "care_tips": ["Avoid exertion", "Eat a heart-healthy diet", "Follow medication schedule"]
        },
        "asthma": {
            "explanation": "Asthma is a condition in which your airways narrow and swell and may produce extra mucus.",
            "specialist": "Pulmonologist",
            "care_tips": ["Use inhaler", "Avoid triggers", "Monitor breathing"]
        }
    }

    condition_info = disease_data.get(prediction, {
        "explanation": "No detailed info available.",
        "specialist": "General Practitioner",
        "care_tips": ["Consult a doctor"]
    })

    return {
        "condition": prediction,
        **condition_info
    }
