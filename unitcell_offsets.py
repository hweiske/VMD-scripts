from ase.io import read
from sys import argv
from ase.neighborlist import NeighborList
from ase.data import covalent_radii
import numpy as np
from argparse import ArgumentParser

parser = ArgumentParser(description='''plot bonds which occur due to PBCs. include in vmdloadscripts via 
set pbcbonds [exec python3 unitcell_offsets.py [molinfo top get filename] -i top]
eval $pbcbonds''',add_help=True)
parser.add_argument("yourstructure",
                    help="Structure to be plotted")
parser.add_argument("-c", "--coloring",default='gray',
        help="coloring methods of vmd. currently: colorID(see --ID), Element")
parser.add_argument("-r", "--radius",default='0.08',
        help="radius of the bonds. default bonds are 0.1, default here: 0.08")
parser.add_argument("-R", "--resolution",default='30',
        help="resolution of the bond-cylinder")
parser.add_argument("-m", "--material",default='AOChalky',
        help="materials of the bonds")
parser.add_argument("-I", "--ID",default='2',
        help="colorID for colorID coloring")
parser.add_argument("-A", "--ASEbondcutoff",default='1',
        help="cutoff for bonding in the ASE neighborlist")
parser.add_argument('-i', '--index',default='top',
        help='index of the molecule for vmd')
args = parser.parse_args()
args_dict=vars(args)
    ##############################################################################
atoms=read(args_dict['yourstructure'])
resolution=args_dict['resolution']
bondradius=args_dict['radius']
material=args_dict['material']
coloring=args_dict['coloring']
index=args_dict['index']
CUTOFF=float(args_dict['ASEbondcutoff'])
ID=args_dict['ID']
if coloring.capitalize() == 'ColorID'.capitalize():
        colora=f'graphics {index} color {ID}'
        colorb=f'graphics {index} color {ID}'
        print(colora)
cutoffs = CUTOFF * covalent_radii[atoms.numbers]
nl = NeighborList(cutoffs=cutoffs, self_interaction=False)
nl.update(atoms)
bondatoms = []
print(f'graphics {index} material {material}')
for a in range(len(atoms)):
    indices, offsets = nl.get_neighbors(a)
    for a2, offset in zip(indices, offsets):
        if offset[0] != 0 or offset[1] != 0 or offset[2] !=0:
            R = np.dot(offset, atoms.cell)
            mida = 0.5 * (atoms.positions[a] + atoms.positions[a2] + R)
            midb = 0.5 * (atoms.positions[a] + atoms.positions[a2] - R)
            if coloring.capitalize() == 'Element'.capitalize():
                print(f'graphics {index} color [color Element {atoms[a].symbol}]')
            print(f'graphics {index} '+r' cylinder {'+f'{mida[0]} {mida[1]} {mida[2]}'+r'} {'+f'{atoms.positions[a][0]} {atoms.positions[a][1]} {atoms.positions[a][2]} '+r'} '+f'radius {bondradius} resolution {resolution} filled yes')
            if coloring.capitalize() == 'Element'.capitalize():
                print(f'graphics {index} color [color Element {atoms[a2].symbol}]')
            print(f'graphics {index} '+r' cylinder {'+f'{atoms.positions[a2][0]} {atoms.positions[a2][1]} {atoms.positions[a2][2]}'+r'} {'+f'{midb[0]} {midb[1]} {midb[2]} '+r'} '+f'radius {bondradius} resolution {resolution} filled yes')
