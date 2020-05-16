import re
import math
# R0-12 must be used
# R0-2 should be used to get the address from variables of C program
# rest other registers should be used for the other purpose
# reading the address of C variable should be done twice, once while load and other while store 
emptyaddreg=[0,1,2]
busyaddreg=[]
emptyreg=[3,4,5,6,7,8,9,10,11,12]
busyreg=[]

def var3(st):
    print("hi")
    global emptyreg
    global emptyaddreg
    global busyreg
    global busyaddreg
    if(len(re.findall("[a-zA-z]+",st[0]))==1 and len(re.findall("[0-9]+",st[2]))==1):#j=1
        x = emptyaddreg.pop(0)
        busyaddreg.append(x)        
        printst = "LDR R{}, ={}".format(x,st[0])
        print(printst)
        y=emptyreg.pop(0)
        busyreg.append(y)
        printst = "MOV R{}, #{}".format(y,st[2])
        print(printst)
        printst = "STR R{}, [R{}]".format(x,y)
        busyaddreg.remove(x)
        emptyaddreg.append(x)
        emptyaddreg = list(set(emptyaddreg))
        busyreg.remove(y)
        emptyreg.append(y)
        emptyreg = list(set(emptyreg))
        print(printst)
    if(len(re.findall("R[0-9]+",st[0]))==1 and len(re.findall("[A-za-z]+",st[2]))==1):#Rn = a
        x = emptyaddreg.pop(0)
        busyaddreg.append(x)        
        printst = "LDR R{}, ={}".format(x,st[2])
        print(printst)
        y=emptyreg.pop(0)
        busyreg.append(y)
        printst = "LDR R{}, [R{}]".format(y,x)
        print(printst)
        printst = "MOV {}, R{}".format(st[0],y)
        print(printst)
        busyaddreg.remove(x)
        emptyaddreg.append(x)
        emptyaddreg = list(set(emptyaddreg))
        busyreg.remove(y)
        emptyreg.append(y)
        emptyreg = list(set(emptyreg))
        #print(busyreg,busyaddreg,emptyreg,emptyaddreg)
    if(len(re.findall("^R[0-9]+$",st[0]))==1 and len(re.findall("[0-9]+",st[2]))==1):#Rn = 3
        printst = "MOV {}, #{}".format(st[0],st[2])
        print(printst)
    if(len(re.findall("R[0-9]+",st[2]))==1 and len(re.findall("[A-za-z]+",st[0]))==1):# a=Rn
        x = emptyaddreg.pop(0)
        busyaddreg.append(x)        
        printst = "LDR R{}, ={}".format(x,st[0])
        print(printst)
        printst = "STR {},[R{}]".format(st[2],x)
        print(printst)
        busyaddreg.remove(x)
        emptyaddreg.append(x)
        emptyaddreg = list(set(emptyaddreg))

def var4(st):
    global emptyreg
    global emptyaddreg
    global busyreg
    global busyaddreg



    

if __name__ == "__main__":
    fil=open("icg.txt","r")
    icg=fil.readlines(1200)
    print(icg[0])
    for stat in icg:
        print("enter")
        st = stat.split(" ")
        print("split",st)
        if(len(st)==3):
            print("if")
            var3(st)



