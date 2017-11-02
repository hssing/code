#!/usr/bin/python
# android-build.py
# Build android

import sys
import os, os.path
from optparse import OptionParser
import re
import shutil
import string

# def getMessgeName(pattarn_str): 

#     strs_matchobj = re.search(r'(\S*) (\S*)', pattarn_str, re.M|re.I)
#     moudleName_str = strs_matchobj.group(2)
#     moudleName_str = re.sub(r'<\d+>{', "", moudleName_str)
#     return moudleName_str

# def getMoudleId(pattarn_str):

#     moudleId_matchObj = re.search(r'\d+', pattarn_str, re.M|re.I)
#     moudleId = moudleId_matchObj.group()
#     return str(int(moudleId) / 100)

# def getMoudleName(pattarn_str):

#     strs_matchobj = re.search(r'(\S*) (\S*)', pattarn_str, re.M|re.I)
#     moudleName_str = strs_matchobj.group(2)
#     strs = moudleName_str.split('_')
#     return string.capitalize(strs[1])

# def genNetMsgFile(moudleId, moudleName, messageNameList, gen_dir, proto_fileName):
    
#     if len(messageNameList) == 0:
#         return

#     print("genNetMsgFile start")
#     fileName = moudleName + ".ts"
#     filePath = os.path.join(gen_dir, fileName)
#     print(filePath)
#     write_file = open(filePath, 'w')
#     write_file.write("namespace msg {\n\n")
#     write_file.write("\texport class " + moudleName + " extends NetMsg {\n\n")
#     write_file.write('\t\tpublic proto: string = "net/proto.proto";\n')
#     write_file.write('\t\tpublic modId: number = ' + moudleId + ';\n')
#     write_file.write('\t\tpublic subIds = \n\t\t[\n')
#     for messageName in messageNameList :
#         write_file.write('\t\t\t"' + messageName + '",\n' )
#     write_file.write('\t\t];\n')
#     write_file.write('\t}\n')
#     write_file.write("\n}")
#     write_file.close()

#     print("genNetMsgFile end")

# def dealWithFile(serverProtoDir, proto_fileName, write_file):

#     moudleId = ""
#     moudleName = ""
#     messageNameList = []
#     client_proto_dir = os.path.join(os.getcwd(), "../egret/resource/net")
#     netMsg_dir = os.path.join(os.getcwd(), "../egret/src/NetMsg")
    
#     read_file = open(os.path.join(serverProtoDir, proto_fileName))

#     lines = read_file.readlines()
#     for line in lines:
#         toc_matchObj = re.search(r'message.*toc.*', line, re.M|re.I)
#         tos_matchObj = re.search(r'message.*tos.*', line, re.M|re.I)
#         if toc_matchObj  or tos_matchObj :
#             if moudleId == "" or moudleName == "":
#                 moudleId = getMoudleId(line)
#                 moudleName = getMoudleName(line)
            
#             messageName = getMessgeName(line)
#             messageNameList.append(messageName) 
#             line = re.sub(r'<\d+>', "", line)
#             write_file.write(line)
#         else:
#             write_file.write(line)
    
#     genNetMsgFile(moudleId, moudleName, messageNameList, netMsg_dir, proto_fileName)
#     read_file.close()

def reGenerateConfig(project_path):

    web_path = os.path.join(project_path, "bin-release/web")
    print(web_path)
    fileList = []
    for item in os.listdir(web_path):
        fileList.insert(len(fileList), item)

    resource_path = os.path.join(project_path, "resource")
    publish_path = os.path.join(project_path, "bin-release", "web", max(fileList))
    current_dir = os.getcwd()
    
    os.chdir(project_path)
    os.rename("resource", "resource1")
    os.chdir(current_dir)

    if sys.platform == 'win32':
        ln_command = "mklink /d " + resource_path + " " + os.path.join(publish_path, "resource")
        print(ln_command)
        result = os.system(ln_command)
        if result != 0:
            raise Exception("windows paltform failed to link the resource dir")
    else:
        os.symlink(os.path.join(publish_path, "resource"), resource_path)

    res_build_command = "res build " + project_path
    print(res_build_command)
    result = os.system(res_build_command)
    if result != 0:
        raise Exception("Failed to re generate Config.json")

    os.chdir(project_path)
    if sys.platform == 'win32':
        os.removedirs("resource")
    else:
        os.unlink("resource")
    os.rename("resource1", "resource")
    os.chdir(current_dir)

def build(serverProtoDir):

    project_path = os.path.abspath("../egret")

    # publish_command = "egret publish ../egret --runtime html5 --version myrelease"
    # result = os.system(publish_command)
    # if result != 0:
    #     raise Exception("Failed to publish project")

    reGenerateConfig(project_path)

# -------------- main --------------
if __name__ == '__main__':
    #parse the params
    usage = """
    This script is used to parse proto file of server to generate .ts and proto file of client
    """

    parser = OptionParser(usage=usage)
    parser.add_option("-d", "--dir", dest="serverProtoDir", default='net',
                      help='It is dir of proto dir of server')
    (opts, args) = parser.parse_args()
    try:
        build(opts.serverProtoDir)
    except Exception as e:
        print e
        sys.exit(1)
