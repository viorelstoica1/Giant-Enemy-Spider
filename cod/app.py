from flask import Flask, Response, render_template, request, jsonify
import cv2
import threading
import RPi.GPIO as GPIO


app = Flask(__name__)

# Inițializează camera
camera = cv2.VideoCapture(0)  # 0 este pentru camera default (USB)

# Setează rezoluția și FPS-ul
width = camera.get(cv2.CAP_PROP_FRAME_WIDTH)
height = camera.get(cv2.CAP_PROP_FRAME_HEIGHT)
print(f"Rezoluția curentă este: {width}x{height}")
camera.set(cv2.CAP_PROP_FPS, 30)  # FPS-ul dorit (ex: 30 cadrelor pe secundă)

#variabile hbridge
GPIO.setmode(GPIO.BOARD)	#set pin numbering format
GPIO.setup(16, GPIO.OUT)	#set GPIO as output
GPIO.setup(18, GPIO.OUT)	#set GPIO as output
GPIO.setup(22, GPIO.OUT)	#set GPIO as output
GPIO.setup(24, GPIO.OUT)	#set GPIO as output

#variabile hbridge
GPIO.setup(33, GPIO.OUT)	#set GPIO as output
GPIO.setup(35, GPIO.OUT)	#set GPIO as output

LeftS = GPIO.PWM (33, 500)
RightS = GPIO.PWM (35, 500)
LeftS.start(0)
RightS.start(0)


# Functia care generează fluxul video
def generate_frames():
    while True:
        success, frame = camera.read()
        if not success:
            break
        else:
            # Encodează cadrul ca JPEG
            _, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()
            # Returnează cadrul în formatul corect pentru MJPEG
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video_feed')
def video_feed():
    # Ruta pentru transmiterea feed-ului video
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/command', methods=['POST'])
def command():
    global save_image_flag
    data = request.json
    if 'action' in data:
        action = data['action']
        print(f"Received action: {action}")
        
  

        
        if action == "next":
            #aplicare duty si directie
            GPIO.output(16,GPIO.HIGH)
            GPIO.output(18,GPIO.LOW)

            GPIO.output(22,GPIO.HIGH)
            GPIO.output(24,GPIO.LOW)

            LeftS.ChangeDutyCycle(50) 
            RightS.ChangeDutyCycle(50) 
            
        if action == "prev":
            #aplicare duty si directie
            GPIO.output(16,GPIO.LOW)
            GPIO.output(18,GPIO.HIGH)

            GPIO.output(22,GPIO.LOW)
            GPIO.output(24,GPIO.HIGH)

            LeftS.ChangeDutyCycle(75) 
            RightS.ChangeDutyCycle(75) 
            
        
        # Adaugă logica pentru alte comenzi dacă este necesar

    return jsonify({"status": "error", "message": "Invalid data"}), 400

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
