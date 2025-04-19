import spacy
try:
    nlp = spacy.load("en_core_web_sm")
except OSError:
    from spacy.cli import download
    download("en_core_web_sm")
    nlp = spacy.load("en_core_web_sm")
    
# Mock symptom list
SYMPTOM_LIST = ["fever", "headache", "stomach pain", "fatigue", "nausea"]

def extract_symptoms(text):
    doc = nlp(text.lower())
    return [symptom for symptom in SYMPTOM_LIST if symptom in doc.text]