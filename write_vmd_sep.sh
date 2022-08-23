F=`for i in $@;do f=${i%/*}; g=${f##*/};h=${g%.vasp};echo $h;done`
F2=`echo $F | tr ' ' '-'`  
echo $F2
infile=test.vmd
echo='#created with script' > $infile
n=0
for structure in $@;do
f=${structure%/*}; g=${f##*/};h=${g%.vasp};echo $h
if echo $structure | grep -qi "poscar";then TYPE='POSCAR'
elif echo $structure | grep -qi "contcar";then TYPE='POSCAR'
elif echo $structure | grep -qi "OUTCAR";then TYPE='OUTCAR'
elif echo $structure | grep -qi "out";then TYPE='OUTCAR'
else echo 'You wrote this function for vasp files. Guessing you are giving me a POSCAR here';TYPE='POSCAR'
fi
 echo "mol new $structure type $TYPE first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all" >> $infile
 echo "mol rename top $h" >> $infile
n=$(( n + 1 ))
done
