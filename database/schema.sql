-- ============================================
-- Cognitive Load Detection System
-- Database Schema
-- ============================================

CREATE DATABASE IF NOT EXISTS cognitive_load_db;
USE cognitive_load_db;

-- ============================================
-- Users Table
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Shift Summary Table
-- ============================================
CREATE TABLE IF NOT EXISTS shift_summary (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    shift_date DATE NOT NULL,
    avg_ear DECIMAL(6,4),
    avg_blink_rate DECIMAL(6,2),
    total_records INT DEFAULT 0,
    high_fatigue_hours INT DEFAULT 0,
    critical_fatigue_hours INT DEFAULT 0,
    peak_fatigue_hour INT,
    final_state VARCHAR(50),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_shift (user_id, shift_date),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- Eye Readings Table (Per-Session Data)
-- ============================================
CREATE TABLE IF NOT EXISTS eye_readings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    shift_date DATE NOT NULL,
    shift_hour INT NOT NULL,
    avg_ear DECIMAL(6,4),
    blink_rate DECIMAL(6,2),
    blink_10s INT DEFAULT 0,
    rule_load VARCHAR(20),
    rf_load VARCHAR(20),
    lstm_load VARCHAR(20),
    alert_level VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- Fatigue Alerts Table
-- ============================================
CREATE TABLE IF NOT EXISTS fatigue_alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    model VARCHAR(20),
    load_label VARCHAR(20),
    ear DECIMAL(6,4),
    blink_rate DECIMAL(6,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
