import pandas as pd

# Load your dataset
df = pd.read_csv("C:\\Users\\xiang\\Desktop\\Vhack25\\CareEase\\backend\\data\\healthcare_chatbot_dataset.csv")

def match_with_dataset(extracted_info, df):
    # Normalize extracted info (convert to lowercase for consistent matching)
    normalized_extracted_info = {key: value.lower() if isinstance(value, str) else value
                                 for key, value in extracted_info.items()}

    # Function to match a row with the extracted information
    def attribute_match(row):
        # Compare each attribute in extracted_info with the corresponding row in the dataset
        for column in extracted_info:
            if isinstance(extracted_info[column], str):  # If the attribute is a string
                if not any(val in row[column].lower() for val in normalized_extracted_info[column].split(",") if val.strip()):
                    return False
            else:  # For non-string attributes (like lists)
                if extracted_info[column] != row[column]:
                    return False
        return True

    # Apply the matching function and return rows where there's a match
    matches = df[df.apply(attribute_match, axis=1)]
    return matches

# Example usage
extracted_info = {
    "symptoms": ["fever", "loss_of_taste"],
    "disease": "COVID-19",
    "duration": "52 days",
    "age group": "40-49",
    "gender": "Male",
    "medical history": "asthma",
    "medications": "none",
    "allergies": "latex, penicillin, seafood",
    "biological traits": "immunocompromised",
    "lifestyle & history": "physically_active, vaccinated",
}

matched_data = match_with_dataset(extracted_info, df)
print(matched_data)
