#credit to Patrick
#first argument something.vmd which loads all files
#second argument something.vmd which loads representations and so on.
NAME='rendering'
PICTURES='./'
SCRIPTS='./'
echo "render options Tachyon '/usr/local/vmd/lib/vmd/tachyon_LINUXAMD64 -aasamples 12 %s -format TARGA'" > "${NAME}.vmd"
echo "play $1 " >>"${NAME}.vmd"
echo "play $2 " >>"${NAME}.vmd"
echo "play $SCRIPTS/makemovie_orientations_notraj.tcl" >>"${NAME}.vmd"
echo "make_movie_files" >> "${NAME}.vmd" #call the makemove proc from abouve
echo "quit" >> "${NAME}.vmd"
echo "Now plotting, give me time"
vmd -e "${NAME}.vmd"
   for i in $PICTURES/*dat;do
	   f=${i%.dat}
   echo "Rendering $f"
   sed -i 's/Resolution.*/Resolution 7000 4000/' $i 
   tachyon  -aasamples 12 $i -format TARGA -o $f.tga
   convert $f.tga $f.png
   rm $f.tga $i
   python $SCRIPTS/black_totransp.py $f.png
done
