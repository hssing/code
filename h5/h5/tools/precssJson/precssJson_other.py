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
      

        #s删除layers
        del test['layers'][0]


        #删除tilesets
        del test['tilesets'][0]   


    store(test,'other_' + fname) 

    print ' [[[SUCCESS]]] '

