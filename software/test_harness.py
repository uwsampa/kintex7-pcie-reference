import numpy as np
import matplotlib.pyplot as plt
import sys, os, time, urllib,pdb
from multiprocessing import Process, Queue

c2h_str = "/dev/xdma/card0/c2h0"
h2c_str = "/dev/xdma/card0/h2c0"

def read_from_fpga(fpga_read_channel, num_bytes, result):
	print "\treaders"
	data_readback = os.read(fpga_read_channel, num_bytes)
	print "\tdone reading"
	result.put(data_readback)
	return

def invert(im):

	try:
		# open up read and write channels
		h2c_fd = os.open(h2c_str, os.O_RDWR)
		c2h_fd = os.open(c2h_str, os.O_RDWR)

		bytes_left = im.size
		result_queue = Queue()

		# processes to handle r/w channels
		read_process = Process(target=read_from_fpga, args=(c2h_fd,im.size, result_queue))
		# write_process = Process(target=write_to_fpga, args=(h2c_fd,buffer(im, im.size - bytes_left)))

		# open up rx 
		read_process.start()
		time.sleep(.5) # wait for the read to start TODO do this in the correct way

		# open up tx, tx should trigger rx
		os.write(h2c_fd, buffer(im, im.size - bytes_left))

		# wait for done
		queue_result = result_queue.get()
		read_process.join()

	finally:
		os.close(c2h_fd)
		os.close(h2c_fd)
		

	return np.frombuffer(queue_result, dtype=np.uint8).reshape(im.shape)


xdim = 600
ydim = 400
print('x: '+str(xdim)+', y: '+str(ydim))
print("getting image")
fn,_ = urllib.urlretrieve('http://lorempixel.com/g/'+str(xdim)+'/'+str(ydim)+'/animals/')

im = plt.imread(fn, format='jpg')
print("received image")

start = time.time()
fpga_inverted = invert(im)
fpga_elapsed = time.time() - start

start = time.time()
cpu_inverted = 255 - im
cpu_elapsed = time.time() - start

plt.subplot(3,1,1)
plt.imshow(im)
plt.title('original')

plt.subplot(3,1,2)
plt.imshow(fpga_inverted)
plt.title('fpga: %f secs' % fpga_elapsed)

plt.subplot(3,1,3)
plt.imshow(cpu_inverted)
plt.title('cpu: %f secs' % cpu_elapsed)

plt.show()

