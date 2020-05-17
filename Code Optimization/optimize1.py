import re
import sys

if len(sys.argv) != 2: 
    print("Correct usage: Enter filename\n")
    exit()

icg_file = sys.argv[1]

def printicg(list_of_lines,) :
	for line in list_of_lines :
		print(line.strip())

def eval_wrap(line) :
	final=''
	line1=line
	if(':' in line):
		st=line[:line.index(':')+1]
		final+=st
		line1=line[line.index(':')+1:]
	
	if('+' in line or '-' in line or '*' in line or '/' in line or '>' in line or '>=' in line or '<' in line or '<=' in line):
		var=re.findall("\w+",line1)
		if(len(re.findall("^\d+",var[1]))!=0 and len(re.findall("^\d+",var[2]))!=0):
			val=0
			if('+' in line):
				val=int(var[1])+int(var[2])
			if('-' in line):
				val=int(var[1])-int(var[2])
			if('*' in line):
				val=int(var[1])*int(var[2])
			if('/' in line):
				val=int(var[1])/int(var[2])
			if('>' in line):
				val=int(var[1])>int(var[2])
			if('>=' in line):
				val=int(var[1])>=int(var[2])
			if('<' in line):
				val=int(var[1])<int(var[2])
			if('<=' in line):
				val=int(var[1])<=int(var[2])
			# print(var)
			if(val==True):
				val=1
			if(val==False):
				val=0
			final+=var[0]+"="+str(val)
			return final
		return line
	return line

def fold_constants(list_of_lines) :
	new_list_of_lines = []
	for line in list_of_lines :
		new_list_of_lines.append(eval_wrap(line))
	return new_list_of_lines








def const_prop(list_of_lines):
	new_list_of_lines = []
	constants=dict()

	#get constants
	for line in list_of_lines :
		final=''
		line1=line
		if(':' in line):
			st=line[:line.index(':')+1]
			final+=st
			line1=line[line.index(':')+1:]
		check=re.findall("^[a-zA-Z]+\d*=\d+$",line1)
		if(len(check)!=0):
			# print(check)
			vval=check[0].split("=")
			# print(vval)
			constants[vval[0]]=vval[1]
	#print(constants)

	#Replace constants
	for line in list_of_lines :
		if "if" in line:
			new_list_of_lines.append(line)
			continue
		
		final=''
		line1=line
		if(':' in line):
			st=line[:line.index(':')+1]
			final+=st
			line1=line[line.index(':')+1:]

		if("=" not in line1):
			new_list_of_lines.append(line)
			continue
			
		lhs=line1[:line1.index("=")+1]
		rhs=line1[line1.index("=")+1:]
		# lag=0
		for c in constants.keys():
			# print(line1.index("="))
			if(c in rhs):
				rhs=rhs.replace(c,constants[c])
				#print("fhhhhhhhhhhhhhhhhhhh",rhs)									
				# t=final+lhs+rhs.replace(c,constants[c])
				# print(final)
				# new_list_of_lines.append(final)
				# flag=1
		#print("rhs",rhs)
		l=final+lhs+rhs
		#print(line,l)
		# if(flag==0):
		new_list_of_lines.append(l)

	return new_list_of_lines


def common_sub_expr(list_of_lines):
	new_list_of_lines = []

	for i,line in enumerate(list_of_lines) :
		final=''
		line1=line
		if(':' in line):
			st=line[:line.index(':')+1]
			final+=st
			line1=line[line.index(':')+1:]	

		if("=" not in line1):
			# new_list_of_lines.append(line)
			continue

		rhs=line1[line1.index("=")+1:].strip()
		lhs=line1[:line1.index("=")].strip()
		for j in range(i+1,len(list_of_lines)):
			l=list_of_lines[j]
			if("=" not in l):
				continue
			lhs_i=l[:l.index("=")].strip()
			rhs_i=l[l.index("=")+1:].strip()
			if rhs==rhs_i and len(re.findall("^\d+$",rhs_i.strip()))==0:
				# print("found",line1,rhs,l,rhs_i)
				new_str=lhs_i+"="+lhs
				# print(new_str	)
				list_of_lines[j]=new_str
	return list_of_lines

if __name__ == "__main__" :

	if len(sys.argv) == 2 :
		icg_file = str(sys.argv[1])
	
	list_of_lines = []
	f = open(icg_file, "r")
	for line in f :
		list_of_lines.append(line)
	f.close()

	# printicg(list_of_lines, "ICG")
	# print("\n")

	constant_prop=const_prop(list_of_lines)
	
	folded_constants = fold_constants(constant_prop)
	# printicg(folded_constants)
	# common_sub_expr(list_of_lines)
	printicg(common_sub_expr(folded_constants))


