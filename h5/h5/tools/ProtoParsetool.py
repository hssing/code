#!/usr/bin/python
# android-build.py
# Build android

import sys
import os, os.path
from optparse import OptionParser
import re
import shutil
import string

def getMessgeName(pattarn_str): 

    strs_matchobj = re.search(r'(\S*) (\S*)', pattarn_str, re.M|re.I)
    moudleName_str = strs_matchobj.group(2)
    moudleName_str = re.sub(r'<\d+>.*', "", moudleName_str)
    return moudleName_str

def getMoudleId(pattarn_str):

    moudleId_matchObj = re.search(r'\d+', pattarn_str, re.M|re.I)
    moudleId = moudleId_matchObj.group()
    return str(int(moudleId) / 100)

def getSubId(pattarn_str):

    moudleId_matchObj = re.search(r'\d+', pattarn_str, re.M|re.I)
    moudleId = moudleId_matchObj.group()
    return str(int(moudleId) % 100)

def getMoudleName(pattarn_str):

    strs_matchobj = re.search(r'(\S*) (\S*)', pattarn_str, re.M|re.I)
    moudleName_str = strs_matchobj.group(2)
    strs = moudleName_str.split('_')
    return string.capitalize(strs[1])

def genNetMsgFile(moudleId, moudleName, messageNameList, subIdList, gen_dir, proto_fileName):
    
    if len(messageNameList) == 0:
        return

    tocList = []
    tosList = []
    print("genNetMsgFile start")
    fileName = moudleName + ".ts"
    filePath = os.path.join(gen_dir, fileName)
    print(filePath)
    write_file = open(filePath, 'w')
    write_file.write("namespace msg {\n\n")
    write_file.write("\texport class " + moudleName + " extends NetMsg {\n\n")
    # write_file.write('\t\tpublic proto: string = "net/proto.proto";\n')
    write_file.write('\t\tpublic modId: number = ' + moudleId + ';\n')
    write_file.write('\t\tpublic subIds = \n\t\t{\n')

    for index in range(len(messageNameList)):
        messageName = messageNameList[index]
        subId = subIdList[index]
        write_file.write('\t\t\t' + subId + ' : "' + messageName + '",\n' )
        if re.search(r'toc$', messageName) != None:
            tocList.append('\"'+messageName+'\"')
        if re.search(r'tos$', messageName) != None:
            tosList.append('\"'+messageName+'\"')
    write_file.write('\t\t};\n')

    write_file.write('\n')

    tocStr = "string"
    if tocList:
        tocStr = '|'.join(tocList) 
    write_file.write('\t\tpublic on(name: ' + tocStr + ', event: events.Event): void {\n')
    write_file.write('\t\t\tsuper.on(name, event);\n')
    write_file.write('\t\t}\n')

    write_file.write('\n')

    tosStr = "string"
    if tosList:
        tosStr = '|'.join(tosList) 
    write_file.write('\t\tpublic send(name: ' + tosStr + ', obj?: Object): void {\n')
    write_file.write('\t\t\tsuper.send(name, obj);\n')
    write_file.write('\t\t}\n')

    write_file.write('\t}\n')
    write_file.write("\n}")
    write_file.close()

    print("genNetMsgFile end")

def dealWithFile(serverProtoDir, proto_fileName, write_file):

    moudleId = ""
    moudleName = ""
    messageNameList = []
    subIdList = []
    client_proto_dir = os.path.join(os.getcwd(), "../egret/resource/net")
    netMsg_dir = os.path.join(os.getcwd(), "../egret/src/NetMsg")
    
    read_file = open(os.path.join(serverProtoDir, proto_fileName))

    lines = read_file.readlines()
    for line in lines:
        toc_matchObj = re.search(r'message.*toc.*', line, re.M|re.I)
        tos_matchObj = re.search(r'message.*tos.*', line, re.M|re.I)
        if toc_matchObj  or tos_matchObj :
            if moudleId == "" or moudleName == "":
                moudleId = getMoudleId(line)
                moudleName = getMoudleName(line)
            
            messageName = getMessgeName(line)
            messageNameList.append(messageName) 
            subId = getSubId(line)
            subIdList.append(subId)
            line = re.sub(r'<\d+>', "", line)
            write_file.write(line)
        else:
            write_file.write(line)
    
    genNetMsgFile(moudleId, moudleName, messageNameList, subIdList, netMsg_dir, proto_fileName)
    read_file.close()

def build(serverProtoDir):

    serverProtoDir = os.path.abspath(serverProtoDir)
    client_proto_dir = os.path.join(os.getcwd(), "../egret/resource/net")
    netMsg_dir = os.path.join(os.getcwd(), "../egret/src/NetMsg")
    
    if os.path.isdir(client_proto_dir) == False :
        os.makedirs(client_proto_dir)
    else:
        shutil.rmtree(client_proto_dir)
        os.makedirs(client_proto_dir)

    if os.path.isdir(netMsg_dir) == False:
        os.makedirs(netMsg_dir)
    else:
        shutil.rmtree(netMsg_dir)
        os.makedirs(netMsg_dir)

    write_file = open(os.path.join(client_proto_dir, "proto.proto"), 'w')
    for item in os.listdir(serverProtoDir):
        print(item)
        suffix = ""
        matchObj = re.search(r'proto$', item, re.M|re.I)
        
        if matchObj :
            suffix = matchObj.group()

        if suffix == 'proto' and os.path.isfile(os.path.join(serverProtoDir, item)):
            dealWithFile(serverProtoDir, item, write_file)
    write_file.close()

# -------------- main --------------
if __name__ == '__main__':
    #parse the params
    usage = """
    This script is used to parse proto file of server to generate .ts and proto file of client
    """

    parser = OptionParser(usage=usage)
    parser.add_option("-d", "--dir", dest="serverProtoDir", default='../../cproto',
                      help='It is dir of proto dir of server')
    (opts, args) = parser.parse_args()
    try:
        build(opts.serverProtoDir)
    except Exception as e:
        print e
        sys.exit(1)
