import math
import re
import sys

emptyreg=[3,4,5,6,7,8,9,10,11,12]
busyreg=[]

if len(sys.argv) != 2: 
    print("Correct usage: Enter filename\n")
    exit()

if len(sys.argv) == 2 :
	icg_file = str(sys.argv[1])
fil=open(icg_file,"r")
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
        r=emptyreg.pop(0)
        busyreg.append(r)
        st="MOV R{},#{}".format(var[1],r)
        print(st)        
        st="STR {},R{}".format(var[0],r)
        print(st)
        r=busyreg.pop(-1)
        emptyreg.append(r)

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
                st="STR {},R{}".format(lhs_var,r)
                print(st)
                r=busyreg.pop(-1)
                emptyreg.append(r)

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
        # print(var)
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
                st="CMP R{},R{}".format(var[1],var[2])
                print(st)

                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVGT R{},#1".format(var[1])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st="MOVNGT R{},#0".format(var[1])
                # st="GT {},{},{}".format(var[1],var[1],var[2])
            if('>=' in line1):
                st="CMP {},{}".format(var[1],var[2])
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVGE {},#1".format(var[1])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st="MOVNGE {},#0".format(var[1])
            if('<' in line1):
                st="CMP {},{}".format(var[1],var[2])
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                
                st="MOVLT {},#1".format(var[1])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st="MOVNLT {},#0".format(var[1]) 
            if('<=' in line1):
                st="CMP {},{}".format(var[1],var[2])
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVLE {},#1".format(var[1])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st="MOVNLE {},#0".format(var[1])
                
            print(st)
            st="STR {},{}".format(var[0],var[1])
            print(st)
            r=busyreg.pop(-1)
            emptyreg.append(r)
            r=busyreg.pop(-1)
            emptyreg.append(r)

        #num + num
        '''
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
        '''

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
                st="SUB {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )
            if('*' in line1):
                st="MUL {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )
            if('/' in line1):
                st="DIV {},#{}".format(var[1],re.findall("^\d+",var[2])[0] )
            if('>' in line1):
                st="CMP R{},#{}".format(var[1],re.findall("^\d+",var[2])[0])
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                
                st="MOVGT R{},#1".format(var[1])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st="MOVNGT R{},#0".format(var[1])
            if('>=' in line1):
                st="CMP {},#{}".format(var[1],re.findall("^\d+",var[2])[0])
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVGE {},#1".format(var[1])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st="MOVNGE {},#1".format(var[1])
            if('<' in line1):
                st="CMP {},#{}".format(var[1],re.findall("^\d+",var[2])[0])
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                st="MOVLT {},#1".format(var[1])
                r=busyreg.pop(-1)
                emptyreg.append(r)

            if('<=' in line1):
                st="CMP {},#{}".format(var[1],re.findall("^\d+",var[2])[0])
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                st="MOVLT {},#1".format(var[1])
                
                # st="MOVLE {},#1".format(var[1])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st="MOVNLE {},#0".format(var[1])
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
                st="SUB {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
            if('*' in line1):
                st="MUL {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
            if('/' in line1):
                st="DIV {},#{}".format(var[2],re.findall("^\d+",var[1])[0] )
            if('>' in line1):
                st="CMP {},{}".format(var[2],re.findall("^\d+",var[1])[0] )
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVGT {},#1".format(var[2])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
                # print(st)
                # st=
            if('>=' in line1):
                st="CMP {},{}".format(var[2],re.findall("^\d+",var[1])[0] )
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVGE {},#1".format(var[2])

                r=busyreg.pop(-1)
                emptyreg.append(r)
                
            if('<' in line1):
                st="CMP {},{}".format(var[2],re.findall("^\d+",var[1])[0] )
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVLT {},#1".format(var[2])

                r=busyreg.pop(-1)
                emptyreg.append(r)
                
            if('<=' in line1):
                st="CMP {},{}".format(var[2],re.findall("^\d+",var[1])[0] )
                print(st)
                
                r1=emptyreg.pop(0)
                busyreg.append(r1)
                var[1]="R{}".format(r1)
                
                st="MOVLE {},#1".format(var[2])
                
                r=busyreg.pop(-1)
                emptyreg.append(r)
                
            print(st)
            st="STR {},{}".format(var[0],var[2])
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
        st="BEQ {}".format(var[1])
        print(st)
