import threading
import requests
import time

# API endpoint
API_URL = "<api url>"

# Access token
ID_TOKEN = "<your access token after login>"

# Headers
HEADERS = {
    "Authorization": f"Bearer {ID_TOKEN}"
}

# Function to fetch and print API response
def fetch_user_info(client_id):
    try:
        response = requests.get(API_URL, headers=HEADERS)
        if response.status_code == 200:
            print(f"[Client {client_id}] Response JSON: {response.json()}")
        else:
            print(f"[Client {client_id}] Status: {response.status_code}, Error: {response.text}")
    except Exception as e:
        print(f"[Client {client_id}] Exception: {e}")

# Start multiple threads to make API calls
threads = []
for i in range(5):
    t = threading.Thread(target=fetch_user_info, args=(i,))
    t.start()
    threads.append(t)
    time.sleep(0.5)  # Slight delay

# Wait for all threads to complete
for t in threads:
    t.join()
