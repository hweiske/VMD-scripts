import numpy as np
from sys import argv
from ase.io import read
##script that calculates points on a bezier curve for drawing an arc for the visualization of angles in molecules
#script is called by the vmd_pick_angles.tcl script; output is caught by the script as well.
#this script exists because tcl is clunky and slow.
#for reference https://en.wikipedia.org/wiki/B%C3%A9zier_curve

#handled by the script
atom_1=int(argv[2]) # c i
center_atom=int(argv[3])
atom_3=int(argv[4])
atoms=read(argv[1]) 
#
def Bezier_3(t,b0,b1,b2,b3): #cubic
    return((1-t)**3*b0+3*t*(1-t)**2*b1+3*t**2*(1-t)*b2+t**3*b3) #simple polynomial

#not using quadratic
#def Bezier_2(t,b0,b1,b2): #quadratic
#    return((1-t)**2*b0+2*t*(1-t)*b1+t**2*b2) #simple polynomial

##definition of points in space + vectors
pos_1=atoms[atom_1].position
pos_2=atoms[center_atom].position
pos_3=atoms[atom_3].position
pos_1_middle=(pos_1+pos_2)/2
pos_3_middle=(pos_3+pos_2)/2
vec_1=(pos_1_middle-pos_2)
vec_2=(pos_3_middle-pos_2)
#b1=pos_2+vec_1+vec_2 for second order bezier
mid1=pos_2+1.5*vec_1+0.5*vec_2
mid2=pos_2+1.5*vec_2+0.5*vec_1

T=np.arange(0,1,0.005) #didn't test lower resolutions
Bezier=[ Bezier_3(t,pos_1_middle,mid1,mid2,pos_3_middle) for t in T] #Bezier curve from pos_1_middle to pos_3_middle using mid1 and mid2 for the curvature; t because it is often used for animations, irrelevant here.

#Bezier=[ Bezier_2(t,b0,b1,b2) for t in T]
#write
print(r'draw color black')
for n,val in enumerate(Bezier[1:],1):
    print(r'draw cylinder {'+f'{Bezier[n-1][0]} {Bezier[n-1][1]} {Bezier[n-1][2]}'  + r'} {' +f'{val[0]} {val[1]} {val[2]}' + r'} radius 0.05') 
    #print(r'draw sphere {' +f'{val[0]} {val[1]} {val[2]}' + r'} radius 0.1') #not pretty
