#! /usr/bin/python

import struct
import os
import sys
import getopt

_DELTA = 0x9E3779B9  

def _long2str(v, w):  
    n = (len(v) - 1) << 2  
    if w:  
        m = v[-1]  
        if (m < n - 3) or (m > n): return ''  
        n = m  
    s = struct.pack('<%iL' % len(v), *v)  
    return s[0:n] if w else s  
  
def _str2long(s, w):  
    n = len(s)  
    m = (4 - (n & 3) & 3) + n  
    s = s.ljust(m, "\0")  
    v = list(struct.unpack('<%iL' % (m >> 2), s))  
    if w: v.append(n)  
    return v  
  
def encrypt(str, key):  
    if str == '': return str  
    v = _str2long(str, True)  
    k = _str2long(key.ljust(16, "\0"), False)  
    n = len(v) - 1  
    z = v[n]  
    y = v[0]  
    sum = 0  
    q = 6 + 52 // (n + 1)  
    while q > 0:  
        sum = (sum + _DELTA) & 0xffffffff  
        e = sum >> 2 & 3  
        for p in xrange(n):  
            y = v[p + 1]  
            v[p] = (v[p] + ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z))) & 0xffffffff  
            z = v[p]  
        y = v[0]  
        v[n] = (v[n] + ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[n & 3 ^ e] ^ z))) & 0xffffffff  
        z = v[n]  
        q -= 1  
    return _long2str(v, False)  
  
def decrypt(str, key):  
    if str == '': return str  
    v = _str2long(str, False)  
    k = _str2long(key.ljust(16, "\0"), False)  
    n = len(v) - 1  
    z = v[n]  
    y = v[0]  
    q = 6 + 52 // (n + 1)  
    sum = (q * _DELTA) & 0xffffffff  
    while (sum != 0):  
        e = sum >> 2 & 3  
        for p in xrange(n, 0, -1):  
            z = v[p - 1]  
            v[p] = (v[p] - ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z))) & 0xffffffff  
            y = v[p]  
        z = v[n]  
        v[0] = (v[0] - ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[0 & 3 ^ e] ^ z))) & 0xffffffff  
        y = v[0]  
        sum = (sum - _DELTA) & 0xffffffff  
    return _long2str(v, True)  

def encryptOneFile(file, key, sign):
    bytesFile = open(file, "rb+")
    encryBytes = encrypt(bytesFile.read(), key)
    encryBytes = sign + encryBytes
    bytesFile.seek(0)
    bytesFile.write(encryBytes)
    bytesFile.close()
    print "encrypt " + file
    pass

def decryptOneFile(file, key, sign):
    bytesFile = open(file, "rb+")
    encryBytes = bytesFile.read()
    signedKey = encryBytes[0:len(sign)]
    if signedKey != sign:
        print "not signed by [ " + sign + " ]"
        return

    encryBytes = encryBytes[len(sign):]
    encryBytes = decrypt(encryBytes, key)
    bytesFile.seek(0)
    bytesFile.write(encryBytes)
    bytesFile.close()
    print "decrypted " + file
    pass

def doEncrypt(file, key, sign):
    if os.path.isdir(file):
        for fpathe,dirs,fs in os.walk(file):
            for f in fs:
                 subfile = os.path.join(fpathe,f)
                 ext = os.path.splitext(subfile)
                 if ext[1] == '.lua':
                    encryptOneFile( subfile, key, sign )
                    pass
    elif os.path.isfile(file):
        encryptOneFile(file, key, sign)
    else:
        print "no such file or directory " + file

    print "encrypt done...."
    pass


def doDecrypt(file, key, sign):
    if os.path.isdir(file):
        for fpathe,dirs,fs in os.walk(file):
            for f in fs:
                 subfile = os.path.join(fpathe,f)
                 ext = os.path.splitext(subfile)
                 if ext[1] == '.lua':
                    decryptOneFile( subfile, key, sign )
                    pass
    elif os.path.isfile(file):
        decryptOneFile(file, key, sign)
    else:
        print "no such file or directory " + file

    print "decrypt done...."
    pass


def usage():
    print "usage:"
    print "  -h the usages of the command:"
    print "  -d do decrypt action:"
    print "  -e do encrypt action"
    print "  -k key,the encrypt key"
    print "  -s sign, the sign key"
    print "  -f the target file"


opts, args = getopt.getopt(sys.argv[1:], "hdek:s:f:")
action = 0
key = ""
sign = ""
tfile = ""
for opt, val in opts:
    if opt == '-h':
        usage()
        sys.exit(0)
    elif opt == '-e':
        action = 1
    elif opt == '-d':
        action = 2
    elif opt == '-k':
        key = val
    elif opt == '-s':
        sign = val
    elif opt == '-f':
        tfile = val

if key == "" or sign == "" or action == 0 or tfile == "":
    usage()
    sys.exit(0)


if action == 1:
    doEncrypt(tfile, key, sign)
elif action == 2:
    doDecrypt(tfile, key, sign)

#if len(sys.argv) > 3:
#    doEncrypt(sys.argv[1] , sys.argv[2], sys.argv[3])
