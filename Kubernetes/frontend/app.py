from flask import Flask, render_template, request, jsonify
import requests
import os

app = Flask(__name__)

# Backend URL - will be set via environment variable or use service name in k8s
BACKEND_URL = os.getenv('BACKEND_URL', 'http://backend-service:3000')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/data', methods=['GET'])
def get_data():
    """Proxy request to backend"""
    try:
        response = requests.get(f'{BACKEND_URL}/api/data', timeout=5)
        response.raise_for_status()
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({'error': f'Backend connection failed: {str(e)}'}), 500

@app.route('/api/message', methods=['POST'])
def send_message():
    """Proxy POST request to backend"""
    try:
        data = request.get_json()
        response = requests.post(f'{BACKEND_URL}/api/message', json=data, timeout=5)
        response.raise_for_status()
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({'error': f'Backend connection failed: {str(e)}'}), 500

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'frontend'}), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
