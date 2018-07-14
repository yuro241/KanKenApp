import re
import sys

args = sys.argv

f1 = open(args[1],"r")
escape=[]
escape1=[]

for line in f1:
    escape.append(line)
f1.close()

for i in range(len(escape)):
    escape1.append(escape[i].split())
    del(escape1[i][2])
    print(escape1[i])

f2 = open(args[2],"a")
for i in range(len(escape1)):
    f2.write(escape1[i][0]+","+escape1[i][1]+"\n")
