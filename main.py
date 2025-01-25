import os
from flask import Flask, render_template, request, redirect, url_for, flash
import bcrypt
#from flask import Limiter
#from flask.util import get_remote_address

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'default_secret_key')

# Rate limiter
#limiter = Limiter(get_remote_address, app=app)

# Environment-based credentials (in a real app, these would come from a database)
USERNAME = os.getenv('LOGIN_USERNAME', 'admin')
HASHED_PASSWORD = bcrypt.hashpw(os.getenv('LOGIN_PASSWORD', 'password123').encode('utf-8'), bcrypt.gensalt())

@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
#@limiter.limit("5 per minute")  # Limit login attempts
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Check credentials
        if username == USERNAME and bcrypt.checkpw(password.encode('utf-8'), HASHED_PASSWORD):
            flash('Login successful!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid username or password', 'danger')

    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    return "Welcome to the Dashboard!"

if __name__ == '__main__':
    app.run(debug=True)