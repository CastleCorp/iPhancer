import os
from flask import Flask, request, redirect, url_for, render_template, send_file
from werkzeug import secure_filename
import datetime
import requests
import run_model_custom
import multiprocessing
import time

UPLOAD_FOLDER = os.path.basename('unprocessed')
process_status = "none"
#ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def set_process_status(status):
	global process_status
	process_status = status

@app.route('/')
def index():
	return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['image']
    f = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
    
    file.save(f)

    return 'Upload finished: ' + file.filename

@app.route('/process', methods=['GET'])
def process_image():
	resolution = request.args['resolution']
	use_gpu = request.args['use_gpu']
	photo = request.args['filename']

	p = multiprocessing.Process(target=run_model_custom.process_photo, args=("iphone", resolution, use_gpu, photo))
	p.start()

	#run_model_custom.process_photo("iphone", resolution, use_gpu, photo)

	return 'Started new process for: ' + photo

@app.route('/getProcessStatus', methods=['GET'])
def check_status():
	file = request.args['filename']
	if os.path.isfile(os.path.join('enhanced', file)):
		return "done"
	else:
		return "file does not exist"

@app.route('/getProcessedPhoto', methods=['GET'])
def get_photo():
	filename = request.args['filename']

	return send_file('enhanced/' + filename)

@app.route('/delete')
def delete_photo():
	base_filename = request.args['filename']
	filenames = ['_original.png', '_processed.png', '_before_after.png']


@app.route('/setProcessStatus')
def set_status():
	set_process_status(request.args['status'])
	return process_status
	
if __name__ == '__main__':
	app.run(debug=True)
	