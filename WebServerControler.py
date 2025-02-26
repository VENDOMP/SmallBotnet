from flask import Flask, request
import threading
import time
import logging

log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

command = "Hello"

def input_thread():
    global command
    time.sleep(2)
    while True:
        user_input = input("ALL_SERVERS_OVER_HTTP~#")
        command = user_input
        for i in range(8):
            print(f"{i}0% " + i * "##", end="\r")
            time.sleep(1)
        print(f"\nChanged command to: {command}")
        command = "Hello"

t3 = threading.Thread(target=input_thread)
t3.daemon = True
t3.start()

app = Flask(__name__)

@app.route("/", methods=['POST'])
def receive_data():
    data = request.data.decode("utf-8")
    if not data:
        return "No data received", 400

    log_file = "data_log.txt"
    with open(log_file, "a") as file:
        file.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - {data}\n")

    return f"Data received: {data}"

@app.route("/", methods=["GET"])
def hello():
    return command

if __name__ == "__main__":
    app.run(debug=True, port=44000, use_reloader=False)
