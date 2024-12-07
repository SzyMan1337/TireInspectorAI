from flask import Blueprint, request, jsonify
import torch
import numpy as np
from PIL import Image
from timm.data import resolve_data_config
from timm.data.transforms_factory import create_transform
from google.cloud import storage
import os

model_bp = Blueprint("model_bp", __name__)

# Global variables
model = None
transform = None


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


# Function to load the PyTorch model and prepare the transform
def load_model():
    global model, transform
    if model is None:
        # Define the Firebase Storage bucket and model path
        bucket_name = "tireinspectorai.appspot.com"
        source_blob_name = "models/cloud_model/vit_model.pth"
        destination_file_name = "vit_model.pth"

        # Download the model if it doesn't exist locally
        if not os.path.exists(destination_file_name):
            download_model_from_firebase(
                bucket_name, source_blob_name, destination_file_name
            )

        # Load the PyTorch model
        print(f"Loading PyTorch model from {destination_file_name}")
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        model = torch.load(destination_file_name, map_location=device)
        model.eval()

        # Resolve the data configuration and create the transform
        print("Resolving data configuration for the model.")
        config = resolve_data_config({}, model=model)
        transform = create_transform(**config)

        print("Model and transform loaded successfully.")


@model_bp.route("/predict", methods=["POST"])
def predict():
    try:
        # Load the model if it's not already loaded
        load_model()

        # Get the input data from the request (expects a JSON object with 'inputData' as a list)
        image_data = request.json.get("inputData")
        if not image_data:
            return jsonify({"error": "No input data provided"}), 400

        try:
            # Convert input data to a NumPy array
            input_array = np.array(image_data, dtype=np.float32)

            # Reshape if necessary (e.g., if data is flattened)
            if input_array.ndim == 1:
                # Assuming the image is flattened, reshape to (H, W, C)
                input_array = input_array.reshape((224, 224, 3))

            # Convert NumPy array to a PIL Image
            image = Image.fromarray(input_array.astype('uint8'), 'RGB')

            # Apply the transform to prepare the input for the model
            input_tensor = transform(image).unsqueeze(0)  # Add batch dimension

        except Exception as error:
            return jsonify({"error": "Invalid input data format", "message": str(error)}), 400

        # Move the tensor to the same device as the model
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        input_tensor = input_tensor.to(device)

        # Run the model prediction
        with torch.no_grad():
            raw_output = model(input_tensor)

            # Apply Sigmoid to the raw output
            output = torch.sigmoid(raw_output)

        # Return the prediction result as JSON
        return jsonify({"result": output.cpu().numpy().tolist()})

    except Exception as e:
        print(f"Error during prediction: {e}")
        return jsonify({"error": "Prediction failed", "message": str(e)}), 500
