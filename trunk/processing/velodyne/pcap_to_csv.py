# binarymillenium
# August 2008
# licensed under the GNU GPL latest version

import math
import array
import csv
import sys
import operator

# might need python2.4 rather than 2.5 for this to work
import pcapy


def processBin1206(bin,outfile, rot,vert,dist,z_off,x_off,vertKeys,image):

	sphereical = True

	#output = array.array('f')
	
	for i in range(12):
		new_rot = (bin[i*100+3]*255 + bin[i*100+2])/100.0
	
		lower_not_upper = -1
		if bin[i*100+1] == 238: lower_not_upper = 0   # EE upper
		if bin[i*100+1] == 221: lower_not_upper = 1   # DD lower

		#if (i == 11):
			#print(str(bin[1201]*256 + bin[1200]) + '\n')	
			#print(str(bin[1205]) + ' ' + str(bin[1203]) + '\n')	

		if lower_not_upper >= 0:
			for j in range(32):
				index = i*100+4+j*3
				new_dist = (bin[index+1]*255 + bin[index])
				new_i = (bin[index+2])

				sensor_index = lower_not_upper*32 + j

				theta = new_rot - rot[sensor_index]

				phi = vert[sensor_index]

				r = new_dist + dist[sensor_index]
				
				if (not sphereical):
					x = r*math.cos(theta/180.0*math.pi)*math.cos(phi/180.0*math.pi) + x_off[sensor_index]*math.cos(theta/180.0*math.pi)
					y = r*math.sin(theta/180.0*math.pi)*math.cos(phi/180.0*math.pi) + x_off[sensor_index]*math.sin(theta/180.0*math.pi)
					z = r*math.sin(phi/180.0*math.pi) + z_off[sensor_index]


					#print(str(sensor_index) + ', ' + str(theta) + ', ' + str(phi) + ', ' + str(r) + ', '\
					#	+ str(new_i) + ', ' + str(x) + ', ' + str(y) + ', '+ str(z))
					outfile.write(str(new_i) + ', ' + str(x) + ', ' + str(y) + ', '+ str(z) + '\n')
					
				#output.append(float(new_i))
				#output.append(x)
				#output.append(y)
				#output.append(z)
				
				else:
					phi_ind = 0

					if (r > 100):
						for sinds in map(operator.itemgetter(1),vertKeys):
							if (sinds == sensor_index): break 
							phi_ind = phi_ind + 1
					
						theta_ind = int(theta/360.0*1280.0)
						if (theta_ind >= 1280): theta_ind = theta_ind-1280
				
        	            # recenter the forward direction with 180 phase shift
						#theta_ind = theta_ind - 1280/2
						if (theta_ind < 0): 
							theta_ind = theta_ind + 1280

						#print(str(phi_ind) +  ', ' + str(theta_ind) + ', ' + str(r) + '\n')
						image[phi_ind][theta_ind] = r
						#outfile.write(str(theta) + ', ' + str(phi) + ', ' + str(r) + '\n');
					
		# TBD something strange is happening here, the binary file ends
		# up about 6.5 times bigger than it ought to be (16 bytes per position)
		# and the text ends up being smaller
		#output.tofile(outfile)

	return new_rot

#if the source file is 98e6 bytes, then there will be 98e6/1206*12*32 = 30.5e6 lines of positions, which will be
# a huge text file
# maybe I should print floats to a binary file instead?

print(len(sys.argv))

pcapfile = sys.argv[1]
#pcapfile = 'unit 46 sample capture velodyne area.pcap'

vel = pcapy.open_offline(pcapfile)

startind = int(sys.argv[2]) # 0

outname = (sys.argv[3])


#fout = open('output0.bin','wb')
filecounter = 0
fout = open(outname + str(filecounter) + '.csv','wb')

dbfile = open('db.csv','rb')

# calibration data
rotCor = array.array('f')
vertCor = array.array('f')
distCor = array.array('f')
vertOffCor = array.array('f')
horizOffCor = array.array('f')

db = csv.reader(dbfile)

vertKeys = []

ind = 0
for row in db:
	rotCor.append( float(eval(row[1])) )
	newVert = float(eval(row[2]))
	#print(str(newVert) + '\n')
	vertCor.append( newVert )
	distCor.append( float(eval(row[3])) )
	vertOffCor.append( float(eval(row[4])) )
	horizOffCor.append( float(eval(row[5])) )
	#print(rotCor[len(rotCor)-1])
	
	vertKeys = vertKeys + [(newVert, ind)]
	ind = ind+1

vertKeys = sorted(vertKeys, key=operator.itemgetter(0))
print(str(vertKeys) + '\n\n')


#findout = open(outname + '_indices.csv','wb')

#i = 0
old_rot = 0;


count = 0


data = vel.next()

image = []
for ind in range(64):
	image.append([])
	for jind in range(1280):
		image[ind].append(0)
	

while (data):
	mybytes = array.array('B',data[1])
	# the first 42 bytes are ethernet headers
	bin = mybytes[42:]


	# each call here produces 12*32 new points, i will 
	# increment to about 79,000 before this is done
	#if (i%100 == 0): print(i)
	
	# this will have 2604 1206 byte packets per second, so split files int 1 second files

	if (filecounter >= startind):
		new_rot = processBin1206(bin,fout, rotCor,vertCor,distCor,vertOffCor,horizOffCor,vertKeys,image)
	else:
		new_rot = 0

	count = count+1;

	# start a new file every rotation
	if (new_rot < old_rot):
		#i = 0
		fout = open(outname + str(filecounter) +'.csv','wb')
		print(str(filecounter) + ', ' + str(count*1248) + ', ' + str(new_rot) + '\n')
	
		if (filecounter >= startind):
		
			for jind in range(1280):
				for ind in range(64):
					fout.write(str(image[ind][jind]) + ', ')
				fout.write('\n')
		filecounter = filecounter +1


		image = []
		for ind in range(64):
			image.append([])
			for jind in range(1280):
				image[ind].append(0)
	


	old_rot = new_rot
	
	data = vel.next()
