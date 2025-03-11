from flask import render_template, request, redirect, url_for, flash
from app import app
import subprocess

# Daftar sesi yang sedang berjalan (simulasi)
active_sessions = []

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/start_stream', methods=['POST'])
def start_stream():
    session_number = request.form['session_number']
    url = request.form['url']
    key = request.form['key']
    duration = request.form['duration']

    # Jalankan script Bash dengan session number
    subprocess.Popen(['/bin/bash', '/root/live-yt/live-ffmpeg.sh', session_number, url, key, duration])
    
    # Tambahkan sesi ke daftar aktif
    sesi_name = f"stream{session_number}"
    active_sessions.append(sesi_name)
    
    flash(f"Streaming session {sesi_name} started!", "success")
    return redirect(url_for('monitor'))

@app.route('/monitor')
def monitor():
    return render_template('monitor.html', active_sessions=active_sessions)

@app.route('/stop_stream/<session_name>')
def stop_stream(session_name):
    # Hentikan sesi tmux
    subprocess.run(['tmux', 'kill-session', '-t', session_name])
    
    # Hapus sesi dari daftar aktif
    if session_name in active_sessions:
        active_sessions.remove(session_name)
    
    flash(f"Streaming session {session_name} stopped!", "success")
    return redirect(url_for('monitor'))