from ase.io import read
from sys import argv
from ase.neighborlist import NeighborList
from ase.data import covalent_radii
import numpy as np
from argparse import ArgumentParser
from ase import Atoms
from ase.build import sort
parser = ArgumentParser(description='''mark atoms of the surface that are bonded to the molecule]
eval $pbcbonds''',add_help=True)
parser.add_argument("yourstructure",
                    help="Structure to be plotted")
parser.add_argument("-r", "--radius",default='0.25',
        help="radius of the sphere.")
parser.add_argument("-R", "--resolution",default='30',
        help="resolution of the bond-cylinder")
parser.add_argument("-m", "--material",default='Transparent',
        help="materials of the bonds")
parser.add_argument("-I", "--ID",default='1',
        help="colorID for colorID coloring")
parser.add_argument("-A", "--ASEbondcutoff",default='1',
        help="cutoff for bonding in the ASE neighborlist")
parser.add_argument("-a", "--atoms",default='2',
        help="number of bonding atoms of the molecule per molecule")
parser.add_argument("-n", "--number",default='1',
        help="number of molecules")
parser.add_argument('-i', '--index',default='top',
        help='index of the molecule for vmd')
parser.add_argument("-s", "--surfaceatoms",default='96',
        help="number of atoms in your slab/sheet")
args = parser.parse_args()
args_dict=vars(args)
    ##############################################################################
atoms=read(args_dict['yourstructure'])
resolution=args_dict['resolution']
mol_ats=int(args_dict['atoms'])
number_of_mols=int(args_dict['number'])
radius=args_dict['radius']
material=args_dict['material']
index=args_dict['index']
CUTOFF=float(args_dict['ASEbondcutoff'])
surf_len=int(args_dict['surfaceatoms'])
ID=args_dict['ID']
#color=f'graphics {index} color {ID}'
cutoffs = CUTOFF * covalent_radii[atoms.numbers]
nl = NeighborList(cutoffs=cutoffs, self_interaction=False)
nl.update(atoms)
bondatoms = []
#print(f'graphics {index} material {material}')
#print(color)
mol=Atoms(None,pbc=atoms.pbc,cell=atoms.cell)
surf=Atoms(None,pbc=atoms.pbc,cell=atoms.cell)
for n,ATOM in enumerate(atoms):
    if n >= surf_len:
        mol.append(ATOM)
    else:
        surf.append(ATOM)
zs=[p[2] for p in mol.positions]
triplebond=sort(mol,tags=zs)[:number_of_mols*mol_ats]
test_sys=surf+triplebond
cutoffs = CUTOFF * covalent_radii[test_sys.numbers]
nl = NeighborList(cutoffs=cutoffs, self_interaction=False)
nl.update(test_sys)
INDICES=[]
for a in range(surf_len):
    indices, offsets = nl.get_neighbors(a)
    for i in range(number_of_mols*mol_ats+1):
        if len(test_sys)-i in indices:
            INDICES.append(a)
#            print(a)
if INDICES:
    print('mol selection index',*INDICES)
    print(f"""mol representation VDW {radius} {resolution}
    mol color ColorID {ID}
    mol material {material}
    mol addrep {index}""")
else:
    print(r'puts {no bond.}')
            #print(f'graphics {index} '+r' sphere {'+f'{atoms.positions[a][0]} {atoms.positions[a][1]} {atoms.positions[a][2]} '+r'} '+f'radius {covalent_radii[test_sys[a].number]} resolution {resolution}')

          #  print(f'graphics {index} '+r' cylinder {'+f'{atoms.positions[a2][0]} {atoms.positions[a2][1]} {atoms.positions[a2][2]}'+r'} {'+f'{midb[0]} {midb[1]} {midb[2]} '+r'} '+f'radius {bondradius} resolution {resolution} filled yes')
