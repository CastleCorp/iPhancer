# To test the model use the following code:
# python run_model.py model=<model> resolution=<resolution> use_gpu=<use_gpu>
# <model> = {iphone, blackberry, sony}
# <resolution> = {orig, high, medium, small, tiny}
# <use_gpu> = {true, false}
# example:  python run_model.py model=iphone resolution=orig use_gpu=true

from scipy import misc
import numpy as np
import tensorflow as tf
from model import resnet
import utils_custom
import os
import sys
import server
import multiprocessing

def process_photo(model, res, gpu, fname):
	running = multiprocessing.Process(target=server.set_process_status, args=("running"))
	running.start()
	running.join()


	phone = model
	resolution = res
	use_gpu = gpu
	photo = fname

	print("Model: " + model + " Resolution: " + res + " GPU: " + gpu + " Photo: " + fname)

	res_sizes = utils_custom.get_resolutions()

	IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_SIZE = utils_custom.get_specified_res(res_sizes, phone, resolution)

	config = tf.ConfigProto(device_count={'GPU': 0} if use_gpu == "false" else None)

	x_ = tf.placeholder(tf.float32, [None, IMAGE_SIZE])
	x_image = tf.reshape(x_, [-1, IMAGE_HEIGHT, IMAGE_WIDTH, 3])

	enhanced = resnet(x_image)

	with tf.Session(config=config) as sess:

		saver = tf.train.Saver()
		saver.restore(sess, "models/" + phone)

		image_dir = "unprocessed/"

		print("Processing image " + photo)
		image = np.float16(misc.imresize(misc.imread(image_dir + photo), res_sizes[phone])) / 255

		image_crop = utils_custom.extract_crop(image, resolution, phone, res_sizes)
		image_crop_2d = np.reshape(image_crop, [1, IMAGE_SIZE])

		#get enhanced image
		enhanced_2d = sess.run(enhanced, feed_dict={x_: image_crop_2d})
		enhanced_image = np.reshape(enhanced_2d, [IMAGE_HEIGHT, IMAGE_WIDTH, 3])

		before_after = np.hstack((image_crop, enhanced_image))
		photo_name = photo.rsplit(".", 1)[0]

		#save the results as .png images
		# base_path = "enhanced/" + photo_name
		# paths = [base_path + "_original.png", base_path + "_processed.png", base_path + "_before_after.png"]

		misc.imsave("enhanced/" + photo_name + "_original.png", image_crop)
		misc.imsave("enhanced/" + photo_name + "_processed.png", enhanced_image)
		misc.imsave("enhanced/" + photo_name + "_before_after.png", before_after)

		finished = multiprocessing.Process(target=server.set_process_status, args=("finished"))
		finished.start()
		finished.join()

		