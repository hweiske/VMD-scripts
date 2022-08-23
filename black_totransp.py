from PIL import Image
from sys import argv
im = Image.open(argv[1])
im = im.convert("RGBA")
datas = im.getdata()
newData = []
for item in datas:
    if item[0] == 0 and item[1] == 0 and item[2] == 0:
        newData.append((0,0,0, 0))
    else:
        newData.append(item)
im.putdata(newData)
im.size  
im.getbbox()
im2 = im.crop(im.getbbox())
im2.size 
newData2=[]
datas2=im2.getdata()
for item in datas2:
    if item[3] == 0:
        newData2.append((0,0,0,0))
    else:
        newData2.append(item)
im2.putdata(newData2)
im2.save(argv[1])

