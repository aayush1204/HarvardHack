from flask import Flask, request, jsonify
import cv2
import os
import numpy as np
import uuid
import hashlib
from flask_cors import CORS
app = Flask(__name__)
CORS(app)

# Parameters
template_folder = "templates"
threshold = 0.8  # Confidence threshold for matching

# Helper function for template matching
def perform_template_matching(input_image, template_image):
    input_gray = cv2.cvtColor(input_image, cv2.COLOR_BGR2GRAY)
    template_gray = cv2.cvtColor(template_image, cv2.COLOR_BGR2GRAY)
    result = cv2.matchTemplate(input_gray, template_gray, cv2.TM_CCOEFF_NORMED)
    _, max_val, _, _ = cv2.minMaxLoc(result)
    return max_val

def create_vector(image):
    # Convert the image to grayscale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Apply thresholding to convert the grayscale image into binary format
    _, binary_image = cv2.threshold(gray_image, 128, 255, cv2.THRESH_BINARY)
    
    # Flatten the binary image into a 1D vector
    vector = binary_image.flatten()
    
    # Normalize the vector to contain only 0s and 1s
    vector = np.where(vector > 0, 1, 0)
    
    return vector.tolist()

# Route for image registration
@app.route('/register', methods=['POST'])
def register():
    if 'image' not in request.files:
        return jsonify({'status': 'failure', 'message': 'No image found in the request.'})

    input_image = request.files['image']
    input_image_data = input_image.read()

    # Generate a unique filename
    filename = str(uuid.uuid4()) + '.jpg'
    image_path = os.path.join(template_folder, filename)

    if not os.path.exists(template_folder):
        os.makedirs(template_folder)

    # Save the image to the template folder
    with open(image_path, 'wb') as f:
        f.write(input_image_data)

    # Check if the image matches any existing templates
    for template_file in os.listdir(template_folder):
        template_path = os.path.join(template_folder, template_file)

        template_image = cv2.imread(template_path)
        input_image = cv2.imdecode(np.fromstring(input_image_data, np.uint8), cv2.IMREAD_COLOR)

        confidence_score = perform_template_matching(input_image, template_image)

        if confidence_score >= threshold:
            os.remove(image_path)  # Remove the newly added image
            filename_hash = hashlib.sha256(template_file.encode()).hexdigest()
            return jsonify({'status': 'success', 'hash': filename_hash, 'confidence': confidence_score})

    return jsonify({'status': 'failure', 'message': 'Image registered.'})

# Route for getting the hash and confidence of a matched image with the highest score
@app.route('/getVectorCode', methods=['POST'])
def get_vector_code():
    if 'image' not in request.files:
        return jsonify({'status': 'failure', 'message': 'No image found in the request.'})

    input_image = request.files['image']
    input_image_data = input_image.read()

    best_score = 0.0
    best_filename = None

    for template_file in os.listdir(template_folder):
        template_path = os.path.join(template_folder, template_file)

        template_image = cv2.imread(template_path)
        input_image = cv2.imdecode(np.fromstring(input_image_data, np.uint8), cv2.IMREAD_COLOR)

        confidence_score = perform_template_matching(input_image, template_image)

        if confidence_score >= threshold and confidence_score > best_score:
            best_score = confidence_score
            best_filename = template_file

    if best_filename:
        # Instead of returning the hash, return the vector of the input image
        input_vector = create_vector(input_image)  # Replace `create_vector` with your vector creation function
        return jsonify({'status': 'success', 'vector': input_vector, 'confidence': best_score})

    return jsonify({'status': 'failure', 'message': 'No matching template found.'})


if __name__ == '__main__':
    app.run(debug=True)

