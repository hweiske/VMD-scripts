import numpy as np
from sys import argv
from ase.io import read
v_i=int(argv[2])
c_i=int(argv[3])
w_i=int(argv[4])
atoms=read(argv[1])
v=atoms[v_i].position
c=atoms[c_i].position
w=atoms[w_i].position
v=(v+c)/2
w=(w+c)/2
v1=(v-c)
w1=(w-c)
b0=v
b1=c+v1+w1
mid1=c+1.25*v1+0.75*w1
mid2=c+1.25*w1+0.75*v1
b2=w
def Bezier_3(t,b0,b1,b2,b3):
    return((1-t)**3*b0+3*t*(1-t)**2*b1+3*t**2*(1-t)*b2+t**3*b3)
def Bezier_2(t,b0,b1,b2):
    return((1-t)**2*b0+2*t*(1-t)*b1+t**2*b2)
T=np.arange(0,1,0.005)
Bezier=[ Bezier_3(t,b0,mid1,mid2,b2) for t in T]
#Bezier=[ Bezier_2(t,b0,b1,b2) for t in T]
for n,val in enumerate(Bezier[1:],1):
    print(r'draw cylinder {'+f'{Bezier[n-1][0]} {Bezier[n-1][1]} {Bezier[n-1][2]}'  + r'} {' +f'{val[0]} {val[1]} {val[2]}' + r'} radius 0.05')
    #print(r'draw sphere {' +f'{val[0]} {val[1]} {val[2]}' + r'} radius 0.1')
