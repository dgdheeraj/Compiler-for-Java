import math
import re

fil=open("sample1.txt","r")
icg=fil.readlines(1200)
r=-1
# print(icg)
ass=[]
for line in icg:
    # +
    if('+' in line):
        line1=line
        if(':' in line):
            st=line[:line.index(':')+1]
            print(st)
            line1=line[line.index(':')+1:]
        var=re.findall("\w+",line1)

        # var + var
        if(len(re.findall("^[a-z]+(\d)*",var[1]))!=0 and len(re.findall("^[a-z]+(\d)*",var[2]))!=0):
            r+=1
            st="MOV R{},{}".format(r,re.findall("^[a-z]+\d*",var[1])[0])
            var[1]="R{}".format(r)
            print(st)
            r+=1
            st="MOV R{},{}".format(r,re.findall("^[a-z]+\d*",var[2])[0])
            var[2]="R{}".format(r)
            print(st)
            st="ADD {},{},{}".format(var[1],var[1],var[2])
            print(st)
            st="MOV {},{}".format(var[0],var[1])
            print(st)

        #num + num
        if(len(re.findall("^\d+",var[1]))!=0 and len(re.findall("^\d+",var[2]))!=0):
            r+=1
            st="ADD R{},#{},#{}".format(r,re.findall("^\d+",var[1])[0], re.findall("^\d+",var[2])[0] )
            var[1]="R{}".format(r)
            print(st)
            st="MOV {},{}".format(var[0],var[1])
            print(st)
        
        # Var + Num
        if(len(re.findall("^[a-z]+(\d)*",var[1]))!=0 and len(re.findall("^\d+",var[2]))!=0):
            r+=1
            st="MOV R{},{}".format(r,re.findall("^[a-z]+\d*",var[1])[0])
            var[1]="R{}".format(r)
            print(st)
            st="ADD {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )
            print(st)
            st="MOV {},{}".format(var[0],var[1])
            print(st)

        # Num + var
        if(len(re.findall("^[a-z]+(\d)*",var[2]))!=0 and len(re.findall("^\d+",var[1]))!=0):
            r+=1
            st="MOV R{},{}".format(r,re.findall("^[a-z]+\d*",var[2])[0])
            var[2]="R{}".format(r)
            print(st)
            st="ADD {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
            print(st)
            st="MOV {},{}".format(var[0],var[2])
            print(st)
            
