FROM python:3.11-slim

# Install system dependencies specifically requested by OpenCV and MediaPipe
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgl1 \
    libxcb1 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency file
COPY requirements.txt .

# Install pip requirements. Since we removed the failing C-extension plugins before, this will pass completely.
RUN pip install --no-cache-dir -r requirements.txt

# Remove the bloatware GUI dependencies pushed by mediapipe
RUN pip uninstall -y opencv-python opencv-contrib-python || true

# Copy the rest of the application
COPY . .

# Start the rigorous gunicorn deployment server securely mapped to the cloud's dynamic port system
CMD gunicorn run:app --bind 0.0.0.0:$PORT --timeout 120 --workers 2
