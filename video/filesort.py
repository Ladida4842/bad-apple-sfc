#this does 2 things:
#   1: identifies duplicate frames
#   2: distributes frames into each bank by best fit
#NOTE:
#   bank $C0 contains code at the end
#   bank $40 contains the 64 byte rom header at the end
#   banks $41-$7D contain the sample data
#   banks $7E/$7F are RAM, so can only use half of them via $3E/$3F

import os, hashlib

d = "frames/"

def hexify(number):
    return hex(number).replace("0x","$").upper()

files = {}          #hash: filesize
unique = {}         #hash: [list of files with that hash]

count = 0
for item in next(os.walk(d))[2]:
    if item.startswith("ba") == True and item.endswith(".bin") == True:
        if count > 4380:
            break
        count += 1
        filehash = hashlib.md5(open(d+item,"rb").read()).hexdigest()
        if filehash not in unique:
            unique[filehash] = [item]
            files[filehash] = os.stat(d+item).st_size
        else:
            unique[filehash].append(item)

banksize = [0xC000]+[65536]*0x3F+[0x2A0]+[0x2E0]*0x3B+[0x3C7F]+[65536]+[32768]*2
banks = [[] for x in range(0x80)]

for cur in list(sorted(files, key=files.get, reverse=True)):
    start = 0
    while files[cur] > banksize[start]:
        start += 1
    banksize[start] -= files[cur]
    banks[start].append(unique[cur])
print(str(banksize))

with open("files.txt", "w") as outfile:
    init = 0xC0
    for group in banks:
        assert init != 0x80     #IndexError on the "while" above triggers instead
        if init < 0x7C:
            outfile.write("\n"+"org "+hexify(init)+"FD20")
        elif init == 0x7C:
            outfile.write("\n"+"org "+hexify(init)+"C381")
        elif init == 0x7E or init == 0x7F:
            outfile.write("\n"+"org "+hexify(init&0x3F)+"8000")
        else:
            outfile.write("\n"+"org "+hexify(init)+"0000")
        for groupie in group:
            for posse in groupie:
                outfile.write("\n\t"+posse.replace(".bin",":"))
            outfile.write("\t"+"incbin "+d+posse)
        init += 1
        if init > 0xFF:
            init = 0x40