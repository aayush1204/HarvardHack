import requests
import os

api_url = 'http://localhost:5000'  # Replace with the appropriate API URL

# Endpoint for image registration
register_endpoint = api_url + '/register'

# Endpoint for getting the filename of a matched image
get_vector_code_endpoint = api_url + '/getVectorCode'

template_folder = 'templates'  # Directory containing template images

# Load template images from the folder
template_files = os.listdir(template_folder)

# Test image registration
for template_file in template_files:
    template_path = os.path.join(template_folder, template_file)
    with open(template_path, 'rb') as f:
        image_data = f.read()

    files = {'image': image_data}
    response = requests.post(register_endpoint, files=files)
    result = response.json()

    if result['status'] == 'success':
        print(f"Image registered: {template_file}")
    else:
        print(f"Image registration failed: {template_file}")

# Test image matching
for template_file in template_files:
    template_path = os.path.join(template_folder, template_file)
    with open(template_path, 'rb') as f:
        image_data = f.read()

    files = {'image': image_data}
    response = requests.post(get_vector_code_endpoint, files=files)
    result = response.json()

    if result['status'] == 'success':
        print(f"Matched image: {template_file}")
        print(f"hash: {result['hash']}")
    else:
        print(f"No match found for image: {template_file}")

