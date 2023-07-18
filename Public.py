import requests

PRIVATE_SERVICE_URL = "http://private-service-url.com/process_request"

def send_request_to_private_service(request):
    try:
        response = requests.post(PRIVATE_SERVICE_URL, json=request)
        if response.status_code == 200:
            confirmation = response.json()
            return confirmation
        else:
            return "Error: Failed to receive confirmation from the private service"
    except requests.exceptions.RequestException as e:
        return "Error: Failed to connect to the private service"

# Example usage
request_data = {"data": "Some data"}
confirmation_response = send_request_to_private_service(request_data)
print(confirmation_response)
