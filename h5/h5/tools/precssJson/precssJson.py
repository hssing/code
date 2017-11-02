# -*- coding: utf-8 -*-
import json
import time
import os
import math



def store(data,fname):
    if not os.path.exists('outfile'):
        os.mkdir("outfile")
    with open('outfile/' + fname, 'w') as json_file:
        json_file.write(json.dumps(data))


if __name__ == "__main__":
    for fname in os.listdir('infile'):  
        f = file('infile/' + fname)
        test = json.load(f)
      
        arr = test['layers'][0]['data']  
        test['layers'][0]['data']  = filter(None, arr)

        le = len(test['layers'][0]['data'])

        width = test['layers'][0]['width'] * test['tilewidth']
        height = test['layers'][0]['height'] * test['tileheight']
        sqrtV = math.sqrt( le )
        test['layers'][0]['width'] = int(sqrtV)
        test['layers'][0]['height'] = int(sqrtV)
        test['width'] = sqrtV
        test['height'] = sqrtV
        test['tilewidth'] = int(width / test['layers'][0]['width'])
        test['tileheight'] = int(height / test['layers'][0]['height'])
        test['tilesets'][0]['tileoffset']['x'] = 0
        test['tilesets'][0]['tileoffset']['y'] = 0

        #s删除layers
        arr_i = []
        for i in range(len(test['layers'])):
            if i != 0 :
                arr_i.append(i)

        arr_i = sorted(arr_i, reverse=True)
        for i in arr_i:
            print i 
            del test['layers'][i]

        #删除tilesets
        arr_i = []
        for i in range(len(test['tilesets'])):
            if i != 0 :
                arr_i.append(i)

        arr_i = sorted(arr_i, reverse=True)
        for i in arr_i:
            print i 
            del test['tilesets'][i]            

    store(test,fname) 

    print ' [[[SUCCESS]]] '

