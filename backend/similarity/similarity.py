import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import os

# Get the directory of the current script
base_dir = os.path.dirname(os.path.abspath(__file__))

# Construct the relative path
data_path = os.path.join(base_dir, '..', 'data', 'healthcare_chatbot_dataset.csv')

# Normalize and load
df = pd.read_csv(os.path.normpath(data_path))

# Convert session data to flat string
def flatten_session_data(session_data):
    return " ".join(
        str(session_data.get(key, "")).lower()
        for key in ['symptoms', 'duration', 'severity', 'body_part', 'context']
    )

# Convert row data into a flat string for matching
def flatten_row(row):
    fields = ['Symptoms', 'Duration', 'Medical History', 'Medications', 'Allergies', 'Biological Traits', 'Lifestyle & History']
    combined = []
    for field in fields:
        value = row.get(field, '')
        if isinstance(value, str):
            combined.append(value)
        elif isinstance(value, list):
            combined.extend(value)
    return " ".join(combined).lower()

# Match using TF-IDF + Cosine Similarity
def match_disease_from_session(session_data):
    user_text = flatten_session_data(session_data)

    # Prepare dataset corpus
    corpus = df.apply(flatten_row, axis=1).tolist()
    corpus.insert(0, user_text)  # First is user input

    # Vectorize
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(corpus)

    # Calculate cosine similarity
    cosine_similarities = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:]).flatten()
    df['similarity_score'] = cosine_similarities

    # Get top 3 matches
    top_matches = df.sort_values(by='similarity_score', ascending=False).drop_duplicates(subset='Disease').head(3)

    # Combine recommendations
    # recommendations = top_matches['Recommendations'].tolist()
    # unique_sentences = list(dict.fromkeys(" ".join(recommendations).split('. ')))  # Remove duplicates
    # combined_recommendation = '. '.join(unique_sentences).strip('. ') + '.'

    return {
        'top_diseases': top_matches[['Disease', 'similarity_score']].to_dict(orient='records'),
        # 'recommendation': combined_recommendation
    }

# Example session data
session_data = {
    'symptoms': 'fever loss of taste',
    'duration': '52 days',
    'severity': 'moderate',
    'body_part': 'throat',
    'context': 'history of asthma and immunocompromised'
}

result = match_disease_from_session(session_data)

print("🩺 Top 3 Predicted Diseases:")
for disease in result['top_diseases']:
    print(f" - {disease['Disease']} (Score: {disease['similarity_score']:.4f})")

print("\n✅ Suggested Care Recommendation:")
print(result['recommendation'])
