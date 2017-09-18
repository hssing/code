#! /usr/bin/python 
#! encoding=utf-8
import time
import xlrd
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

class excel:
    fname = ""

    def __init__(self,fname):
        self.fname = fname

    def parse(self):
        self.data = xlrd.open_workbook(self.fname)
        sheet = self.data.sheets()[0]
        
        nrows = sheet.nrows
        ncols = sheet.ncols
        
        keys = []
        for i in range(0, ncols):
            keys.append(sheet.cell(0, i).value)

        
        self.values = [] 
        for i in range(1, nrows):
            rowdata = {} 
            for j in range(0, ncols):
                cell = sheet.cell(i, j)
                rowdata[keys[j]] = cell.value
            
            self.values.append(rowdata)
    
    def getData(self):
        return self.values

    def wirte2lua(self):
        cfgName = self.fname.split(".")[-2]
        cfgfile = open(cfgName + ".lua","w")
        cfgfile.write("--created by huangsheng\n")
        cfgfile.write("--date:" + time.strftime("%Y-%m-%d %H:%M:%S") + "\n\n") 
        cfgfile.write(cfgName + " = {}\n\n")

        for i in range(len(self.values)):
            cfgId = self.values[i]["id"]
            is_instof = isinstance(cfgId, str)
            if is_instof:
                cfgId = int(cfgId)
            cfgfile.write(cfgName + "[" + str(cfgId) + "] = {\n")
            for key, value in self.values[i].items():
                cfgfile.write("\t" + str(key) + " = " + str(value) + "\n")

            cfgfile.write("}\n\n");

        cfgfile.close()

inst = excel("mytest.xlsx")
inst.parse()
inst.wirte2lua()

