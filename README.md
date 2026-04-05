# 🧠 AI-Based Real-Time Cognitive Load & Fatigue Detection System

A web application that detects mental fatigue in real-time using **facial analysis**, **machine learning**, and **deep learning** — no wearables required, only a webcam.

![Python](https://img.shields.io/badge/Python-3.10+-blue)
![Flask](https://img.shields.io/badge/Flask-3.0+-green)
![MediaPipe](https://img.shields.io/badge/MediaPipe-0.10+-orange)
![TensorFlow](https://img.shields.io/badge/TensorFlow-2.15+-red)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue)

---

## 📌 Overview

This system monitors cognitive load by analyzing eye behavior (Eye Aspect Ratio, blink rate) through facial landmarks. It combines three prediction approaches for maximum reliability:

- **Rule-Based Logic** — Baseline comparison for instant, explainable results
- **Random Forest (ML)** — Learned patterns from training data
- **LSTM (Deep Learning)** — Time-series analysis for gradual fatigue detection

### Key Features

- 🔐 **User Authentication** — Register, login, role-based access (User/Admin)
- 📷 **Live Monitoring** — Real-time webcam analysis with 8-cycle shift monitoring
- 📊 **Dashboard** — Live metrics, fatigue charts, wellness scores
- 👨‍💼 **Admin Panel** — Monitor all employees, trigger remote monitoring
- 🚨 **Smart Alerts** — Escalating alerts (Low → Medium → High → Critical)
- 📄 **PDF Reports** — Auto-generated shift reports
- 📈 **Shift History** — Track fatigue trends over time
- 🧘 **Stress Relief** — Built-in wellness page for users

---

## 🏗️ Project Architecture

```
cognitive-load-detection/
├── app/                          # Flask application
│   ├── routes/                   # API & page routes
│   │   ├── auth_routes.py        # Login, register, logout
│   │   ├── user_routes.py        # User dashboard, profile
│   │   ├── admin_routes.py       # Admin dashboard, user management
│   │   ├── live_routes.py        # Live monitoring & video streaming
│   │   ├── shift_report.py       # PDF report generation
│   │   └── shift_history.py      # Shift history page
│   ├── scheduler/                # Background processing
│   │   ├── capture_controller.py # 8-cycle capture controller (thread-safe)
│   │   └── shift_summary.py      # Shift summary computation & DB storage
│   ├── templates/                # HTML templates (Jinja2)
│   │   ├── auth/                 # Login & register pages
│   │   ├── user/                 # User dashboard, profile, history
│   │   ├── admin/                # Admin dashboard, user monitoring
│   │   └── live/                 # Live monitoring page
│   ├── utils/                    # Utility modules
│   │   ├── presence.py           # Online presence tracker
│   │   ├── eye_logger.py         # Eye reading database logger
│   │   └── alert_logger.py       # Fatigue alert logger
│   ├── app.py                    # Flask app factory
│   └── extensions.py             # Flask extensions (MySQL)
├── src/                          # Core ML/CV pipeline
│   ├── face_detection/           # Face & eye detection
│   │   ├── face_mesh.py          # Main analyzer (MediaPipe + ML inference)
│   │   └── eye_landmarks.py      # Eye contour drawing
│   ├── feature_extraction/       # Feature computation
│   │   ├── ear_calculation.py    # Eye Aspect Ratio (EAR)
│   │   ├── blink_detection.py    # Blink detector (state machine)
│   │   └── blink_rate.py         # Windowed blink rate tracker
│   ├── models/                   # ML training & inference
│   │   ├── train_random_forest.py
│   │   ├── train_lstm.py
│   │   ├── realtime_rf_inference.py
│   │   └── realtime_lstm_inference.py
│   ├── preprocessing/            # Data preprocessing
│   │   └── baseline_calibration.py
│   └── utils/                    # Data utilities
│       ├── data_logger.py        # CSV data logger
│       └── shift_analyzer.py     # Shift analysis
├── models/                       # Trained models & weights
│   ├── face_landmarker.task      # MediaPipe face model
│   ├── random_forest_cognitive_load.pkl
│   ├── lstm_cognitive_load.h5
│   ├── lstm_scaler.pkl
│   ├── lstm_label_encoder.pkl
│   ├── cognitive_load_score.py   # Rule-based scoring
│   └── fatigue_trend.py          # Fatigue trend tracker
├── data/                         # Data files
│   ├── baseline/                 # User baseline calibration
│   └── processed/                # Training dataset (features.csv)
├── experiments/                  # Experiment scripts
│   └── notebooks/                # Analysis & visualization
├── static/                       # Static assets (CSS, JS, sounds)
├── database/                     # Database schema
│   └── schema.sql                # MySQL table creation script
├── run.py                        # Application entry point
├── requirements.txt              # Python dependencies
└── .gitignore                    # Git ignore rules
```

---

## 🚀 Getting Started

### Prerequisites

- **Python 3.10+**
- **MySQL 8.0+**
- **Webcam** (for live monitoring)

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/cognitive-load-detection.git
cd cognitive-load-detection
```

### 2. Create Virtual Environment

```bash
python -m venv venv
source venv/bin/activate        # Linux/Mac
venv\Scripts\activate           # Windows
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Setup MySQL Database

```bash
mysql -u root -p < database/schema.sql
```

Or run the SQL manually in MySQL Workbench.

### 5. Configure Environment

Create a `.env` file in the project root:

```env
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=your_password
MYSQL_DB=cognitive_load_db
SECRET_KEY=your_secret_key_here
```

### 6. Create Admin User

```bash
python check_admin.py
```

### 7. Run the Application

```bash
python run.py
```

Visit **http://127.0.0.1:5000** in your browser.

---

## 🔬 How It Works

### Detection Pipeline

```
Webcam → Face Detection (MediaPipe 468 landmarks)
       → Eye Region Extraction
       → EAR Calculation + Blink Detection
       → Baseline Calibration (5 seconds)
       → Cognitive Load Prediction:
           ├── Rule-Based (instant)
           ├── Random Forest (ML)
           └── LSTM (time-series DL)
       → Alert Level (Low/Medium/High/Critical)
       → Dashboard + Database Storage
```

### Shift Monitoring (8-Cycle System)

Each monitoring session consists of:
- **8 capture windows** (30 seconds each)
- **Pause periods** between captures (30 seconds)
- Metrics collected during captures are aggregated into a shift summary
- Final state determined: Fresh / Normal / Fatigued / Exhausted

---

## 🛠️ Technologies

| Category | Technology |
|----------|------------|
| Backend | Flask, Python |
| Database | MySQL |
| Computer Vision | MediaPipe, OpenCV |
| Machine Learning | scikit-learn (Random Forest) |
| Deep Learning | TensorFlow/Keras (LSTM) |
| Frontend | HTML, CSS, Bootstrap 5, JavaScript |
| PDF Generation | ReportLab |
| Charts | Chart.js |

---

## 📊 Alert Levels

| Level | Condition | Action |
|-------|-----------|--------|
| 🟢 Low | Normal eye behavior | No action |
| 🟡 Medium | Fatigue signs for 2+ seconds | UI warning |
| 🔴 High | Sustained fatigue for 5+ seconds | Sound alert + logging |
| ⚫ Critical | Prolonged fatigue for 10+ seconds | Urgent notification |

---

## 📝 License

This project is for educational purposes.

---

## 👤 Author

Built with ❤️ as a college project for AI-based employee wellness monitoring.
