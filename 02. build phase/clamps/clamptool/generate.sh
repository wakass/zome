#!/bin/bash
OPENSCAD="/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD"
OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

while read -r name value; do
for j in {1..3}; do
   if [[ $j -eq 2 ]]; then
            HOLDER_ANGLE=$(echo "180 - $value" | bc -l)
   else
	HOLDER_ANGLE=$value	
   fi
   for i in {0..3}; do
            $OPENSCAD \
                -D item=$i \
                -D holder_angle=$HOLDER_ANGLE \
                -o "../HolderExport/${name}${j}_${i}.stl" \
                ./CornerHolder.scad
        done
done
done < corner_configs.txt


