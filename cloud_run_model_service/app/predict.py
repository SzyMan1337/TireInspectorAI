from google.cloud import storage
from flask import Blueprint, request, jsonify
from tensorflow import keras
import numpy as np
import os

model_bp = Blueprint("model_bp", __name__)

# Global variable to hold the loaded model
model = None


# Function to download the model from Firebase Storage (GCS)
def download_model_from_firebase(bucket_name, source_blob_name, destination_file_name):
    """Download the model from Firebase Storage (Google Cloud Storage)."""
    try:
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(source_blob_name)

        # Attempt to download the model file
        blob.download_to_filename(destination_file_name)
        print(f"Model downloaded to {destination_file_name}.")

        # Check if the file exists after downloading
        if os.path.exists(destination_file_name):
            print(f"File {destination_file_name} exists.")
        else:
            print(f"File {destination_file_name} does NOT exist.")
    except Exception as e:
        print(f"Error downloading model: {e}")
        raise


# Function to load the model if it's not already loaded
def load_model():
    global model
    if model is None:
        # Define the Firebase Storage bucket and model path
        bucket_name = "tireinspectorai.appspot.com"
        source_blob_name = "models/cloud_model/model.keras"
        destination_file_name = "model.keras"

        # Download the model if it doesn't exist locally
        if not os.path.exists(destination_file_name):
            download_model_from_firebase(
                bucket_name, source_blob_name, destination_file_name
            )

        # Load the model from the downloaded file
        print(f"Loading Keras model from {destination_file_name}")
        model = keras.models.load_model(destination_file_name)
        print("Model loaded successfully.")


# Prediction route
@model_bp.route("/predict", methods=["POST"])
def predict():
    try:
        # Load the model if it's not already loaded
        load_model()

        # Get the input data from the request (expects a JSON object with 'inputData')
        input_data = request.json.get("inputData")
        if not input_data:
            return jsonify({"error": "No input data provided"}), 400

        # Convert the input data to a numpy array and reshape it to (1, 224, 224, 3)
        input_tensor = np.array(input_data).reshape(1, 224, 224, 3)

        # Optionally normalize the image if your model expects input data in the [0, 1] range
        input_tensor = input_tensor / 255.0

        # Run the model prediction
        output = model.predict(input_tensor)

        # Return the prediction result as JSON
        return jsonify({"result": output.tolist()})

    except Exception as e:
        print(f"Error during prediction: {e}")
        return jsonify({"error": "Prediction failed", "message": str(e)}), 500
