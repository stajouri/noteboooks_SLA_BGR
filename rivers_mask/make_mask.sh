# use cdftools polymask to create a mask given the corners of the polygon

#-------------------------------

cat << eof > kara_part2_mask.txt
kara_part2
6 0
1144 1207
1295 1207
1259 1157
1228 1155
1215 1149
1187 1175
eof

/gpfswork/rech/cli/uor98hu/CDFTOOLS/bin/cdfpolymask -p kara_part2_mask.txt -ref /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.GAI-S/1y/1980/eORCA025.L75-IMHOTEP.GAI_y1980.1y_gridT.nc -o /gpfswork/rech/cli/uor98hu/MYDATA/rivers_mask/kara_part2_mask.nc
