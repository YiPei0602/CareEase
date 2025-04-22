import pickle

def load_model():
    with open('diagnosis_model.pkl', 'rb') as f:
        return pickle.load(f)

def match_disease(session_data):
    model = load_model()
    features = " ".join(
        str(session_data.get(k, "")) for k in [
            'symptoms','duration','severity','body_part','context'
        ]
    )
    pred = model.predict([features])[0]
    mapping = {
        'angina': {
            'explanation': 'Angina is chest pain due to reduced blood flow.',
            'specialist': 'Cardiologist',
            'care_tips': ['Rest', 'Avoid stress']
        },
        'asthma': {
            'explanation': 'Asthma causes airway inflammation.',
            'specialist': 'Pulmonologist',
            'care_tips': ['Use inhaler', 'Avoid triggers']
        }
    }
    info = mapping.get(pred, {'explanation':'','specialist':'General Practitioner','care_tips':['Consult doctor']})
    return {'condition': pred, **info}


# services/user_profile.py

def get_user_profile(user_id):
    return {
        'name': 'Jane Doe',
        'age': 28,
        'gender': 'female',
        'weight': 55,
        'height': 165,
        'medical_conditions': ['asthma'],
        'medications': ['Ventolin'],
        'hospitalizations': ['pneumonia - 2019'],
        'family_history': ['heart disease'],
        'lifestyle': ['non-smoker']
    }