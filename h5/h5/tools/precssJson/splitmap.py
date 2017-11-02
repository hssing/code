#!/usr/bin/python
# android-build.py
# Build android

import sys
import json
import time
import os
import math

# square size 
COUNT = 35
COLS = 801
ROWS = 801

def store(data, fname, path):
	gen_dir = os.path.join(os.getcwd(), path)
	filePath = os.path.join(gen_dir, fname)
	json_file = open(filePath, 'w')
	json_file.write(json.dumps(data))

# begin from 0 ...
def index2cell(idx, cols):
    x = int(idx % cols)
    y = int(idx / this.info.cols)
    return [x, y]

# begin from 0 ...
def cell2index(cx, cy, cols):
    return int(cy * cols + cx)

def fillRect(ri, cj, data):
	ret = {}
	for i in range(ri, ri + COUNT):
		for j in range(cj, cj + COUNT):
			k1 = cell2index(j-cj, i-ri, COLS)
			k = cell2index(j, i, COLS)
			if k >= 0 and k < len(data) and data[k] != 0:
				ret[k] = data[k]
	return ret

if __name__ == "__main__":
	f = file('infile/' + 'ditu.json')
	data = json.load(f)

	COLS = float(data['width'])
	ROWS = float(data['height'])
	subFiles = []

	for i in range(0, int(math.ceil(ROWS/COUNT))):
		for j in range(0, int(math.ceil(COLS/COUNT))):
			alldata = []
			for l in range(len(data['layers'])):
				arr = data['layers'][l]['data']
				t = fillRect(i*COUNT, j*COUNT, arr)
				alldata.append(t)

			k = cell2index(j, i, math.ceil(COLS/COUNT))
			fn = ""
			alldata = filter(None, alldata)
			if alldata:
				fn = "%d.json"%(k)
				store(alldata, fn, '../../egret/dresource/Config/Map/')
				# store(alldata, fn, 'outfile/')
			subFiles.append(fn)

	for l in range(len(data['layers'])):
		data['layers'][l]['data'] = []

	data['subFiles'] = subFiles
	data["clipRange"] = COUNT
	store(data, 'ditu.json', '../../egret/resource/assets/Map/')
	# store(data, 'ditu.json', 'outfile/')
        
	print ' [[[SUCCESS]]] '
