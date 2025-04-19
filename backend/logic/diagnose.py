import yaml
import joblib
import os
from nlp.extractor import extract_symptoms
from sessions.session_manager import update_session

RULE_PATH = os.path.join("rules", "disease_rules.yaml")
MODEL_PATH = os.path.join("models", "disease_predictor.pkl")

def diagnose_user_input(user_input: str, session_id: str):
    symptoms = extract_symptoms(user_input)

    # Rule-based inference
    with open(RULE_PATH, "r") as file:
        rules = yaml.safe_load(file)

    matched_diseases = []
    for disease, rule_symptoms in rules.items():
        if all(symptom in symptoms for symptom in rule_symptoms):
            matched_diseases.append(disease)

    # ML Prediction (optional if model exists)
    if os.path.exists(MODEL_PATH) and os.path.getsize(MODEL_PATH) > 0:
        try:
            model = joblib.load(MODEL_PATH)
            ml_prediction = model.predict([symptoms])
            matched_diseases.append(ml_prediction[0])
        except Exception as e:
            print(f"Model load failed: {e}")

    update_session(session_id, user_input, symptoms, matched_diseases)

    return {
        "response": f"Detected: {', '.join(symptoms)}. Possible conditions: {', '.join(matched_diseases)}",
        "session_id": session_id,
        "symptoms_detected": symptoms,
        "possible_diseases": matched_diseases
    }