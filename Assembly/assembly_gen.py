import math
import re

emptyreg=[3,4,5,6,7,8,9,10,11,12]
busyreg=[]

fil=open("sample1.txt","r")
icg=fil.readlines(1200)
r=-1
# print(icg)
ass=[]
for line in icg:
    
    #If the line has Label
    line1=line
    if(':' in line):
        st=line[:line.index(':')+1]
        print(st)
        line1=line[line.index(':')+1:]


    #Only assignment
    check=re.findall("[a-zA-Z]+\d*=\d+",line)
    check1=re.findall("[a-zA-Z]+\d*=[a-zA-Z]+\d*",line)
    
    #Constant Assignment
    if(len(check)!=0):
        var=check[0].split("=")
        st="STR {},#{}".format(var[0],var[1])
        print(st)

    #Variable Assignment
    if(len(check1)!=0):

        #If not in the statement
        if( check1[0].split("=")[1]=="not"):
            # print(line.split(" "))
            v=line.split(" ")[-1].rstrip()
            
            #Performing not on variable
            if(re.findall("[a-zA-Z]+\d*",v)!=0):
                lhs_var=check1[0].split("=")[0]
                r=emptyreg.pop(0)
                busyreg.append(r)
                st="LDR R{},{}".format(r,v)
                print(st)
                st="NOT R{}".format(r)
                print(st)
                st="STR {},R{}".format(r,lhs_var)
                print(st)
                r=busyreg.pop(-1)
                emptyreg.append(r)

            #Not operation on value
            if(re.findall("^\d*",v)!=0):
                lhs_var=check1[0].split("=")[0]
                r=emptyreg.pop(0)
                busyreg.append(r)
                st="LDR R{},#{}".format(r,v)
                print(st)
                st="NOT R{}".format(r)
                print(st)
                st="STR {},R{}".format(lhs_var,v)

        #If var assignment
        if( check1[0].split("=")[1]!="not"):
            var=check1[0].split("=")
            r=emptyreg.pop(0)
            st="LDR R{},{}".format(r,var[1])
            print(st)
            busyreg.append(r)
            st="STR {},R{}".format(var[0],r)
            print(st)
            r=busyreg.pop(-1)
            emptyreg.append(r)
            # print("Var assgn",check1)
    
    
    # +
    if('+' in line or '-' in line or '*' in line or '/' in line or '>' in line or '>=' in line or '<' in line or '<=' in line):
        var=re.findall("\w+",line1)

        # var + var
        if(len(re.findall("^[a-z]+(\d)*",var[1]))!=0 and len(re.findall("^[a-z]+(\d)*",var[2]))!=0):
            r+=1
            r=emptyreg.pop(0)
            st="LDR R{}, {}".format(r,re.findall("^[a-z]+\d*",var[1])[0])
            busyreg.append(r)
            var[1]="R{}".format(r)
            print(st)
            r+=1
            r=emptyreg.pop(0)
            busyreg.append(r)
            st="LDR R{}, {}".format(r,re.findall("^[a-z]+\d*",var[2])[0])
            var[2]="R{}".format(r)
            print(st)
            if('+' in line1):
                st="ADD {},{},{}".format(var[1],var[1],var[2])
            if('-' in line1):
                st="SUB {},{},{}".format(var[1],var[1],var[2])
            if('*' in line1):
                st="MUL {},{},{}".format(var[1],var[1],var[2])
            if('/' in line1):
                st="DIV {},{},{}".format(var[1],var[1],var[2])
            if('>' in line1):
                st="DIV {},{},{}".format(var[1],var[1],var[2])
            if('>=' in line1):
                st="DIV {},{},{}".format(var[1],var[1],var[2])
            if('<' in line1):
                st="DIV {},{},{}".format(var[1],var[1],var[2])
            if('<=' in line1):
                st="DIV {},{},{}".format(var[1],var[1],var[2])
            
            print(st)
            st="STR {},{}".format(var[0],var[1])
            print(st)
            r=busyreg.pop(-1)
            emptyreg.append(r)
            r=busyreg.pop(-1)
            emptyreg.append(r)

        #num + num
        if(len(re.findall("^\d+",var[1]))!=0 and len(re.findall("^\d+",var[2]))!=0):
            r+=1
            r=emptyreg.pop(0)
            busyreg.append(r)
            if('+' in line1):
                st="ADD R{},#{},#{}".format(r,re.findall("^\d+",var[1])[0], re.findall("^\d+",var[2])[0] )
            if('-' in line1):
                st="ADD R{},#{},#{}".format(r,re.findall("^\d+",var[1])[0], re.findall("^\d+",var[2])[0] )
            if('*' in line1):
                st="ADD R{},#{},#{}".format(r,re.findall("^\d+",var[1])[0], re.findall("^\d+",var[2])[0] )
            if('/' in line1):
                st="ADD R{},#{},#{}".format(r,re.findall("^\d+",var[1])[0], re.findall("^\d+",var[2])[0] )
            
            var[1]="R{}".format(r)
            print(st)
            st="STR {},{}".format(var[0],var[1])
            print(st)
            r=busyreg.pop(-1)
            emptyreg.append(r)
        
        # Var + Num
        if(len(re.findall("^[a-z]+(\d)*",var[1]))!=0 and len(re.findall("^\d+",var[2]))!=0):
            r+=1
            r=emptyreg.pop(0)
            busyreg.append(r)
            st="LDR R{},{}".format(r,re.findall("^[a-z]+\d*",var[1])[0])
            var[1]="R{}".format(r)
            print(st)
            if('+' in line1):
                st="ADD {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )
            if('-' in line1):
                st="ADD {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )
            if('*' in line1):
                st="ADD {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )
            if('/' in line1):
                st="ADD {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )

            print(st)
            st="STR {},{}".format(var[0],var[1])
            print(st)
            r=busyreg.pop(-1)
            emptyreg.append(r)

        # Num + var
        if(len(re.findall("^[a-z]+(\d)*",var[2]))!=0 and len(re.findall("^\d+",var[1]))!=0):
            r+=1
            r=emptyreg.pop(0)
            busyreg.append(r)
            st="LDR R{},{}".format(r,re.findall("^[a-z]+\d*",var[2])[0])
            var[2]="R{}".format(r)
            print(st)
            if('+' in line1):
                st="ADD {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
            if('-' in line1):
                st="ADD {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
            if('*' in line1):
                st="ADD {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
            if('/' in line1):
                st="ADD {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
             
            print(st)
            st="MOV {},{}".format(var[0],var[2])
            print(st)
            r=busyreg.pop(-1)
            emptyreg.append(r)            
    
    #if statement
    if('if' in line):
        # line1=line
        # if(':' in line):
        #     st=line[:line.index(':')+1]
        #     #Print the label
        #     print(st,len(st))
        #     line1=line[line.index(':')+1:]
        
        var=re.findall("[a-zA-Z]+\d*",line1)
        var.remove("goto")
        var.remove("if")
        # print(var)
        st="CMP {},#1".format(var[0])
        print(st)
        st="BNE {}".format(var[1])
        print(st)
