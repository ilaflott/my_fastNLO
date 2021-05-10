#!bin/bash

PDFunc="L6"
#PDFunc="HS"
#PDFunc="MC"
#PDFunc="NN"

Nybins=4

datadir="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362"

#order="NNLO"
#echo "order=${order}"
#declare -a Oarr=("NLO" "NNLO")
declare -a Oarr=("NNLO")
#declare -a Oarr=("NLO")
NOs=${#Oarr[@]}
echo "NOs=$NOs"

gridver="2"
echo "grids.v${gridver}"

declare -a scalearr=("kScale1" "kProd")
#declare -a scalearr=("kProd")
Nscales=${#scalearr[@]}
echo "Nscale=$Nscales"

##what i want to run RIGHT NOW
#declare -a pdfarr=("NNPDF31_nnlo_as_0116" "NNPDF31_nnlo_as_0118")
declare -a pdfarr=("NNPDF31_nnlo_as_0124" "NNPDF31_nnlo_as_0119" "NNPDF31_nnlo_as_0108" "NNPDF31_nnlo_as_0110" "NNPDF31_nnlo_as_0112" "NNPDF31_nnlo_as_0114" "NNPDF31_nnlo_as_0117")
#when i run the NLO, i need to uncomment combineNLOandNNLORootFiles
#declare -a pdfarr=("NNPDF31_nlo_as_0116" "NNPDF31_nlo_as_0118")

##all nnlo PDFs with corresponding nlo PDFS, and the nlo ones below them!
#declare -a pdfarr=("CT14nnlo" "NNPDF30_nnlo_as_0121" "NNPDF31_nnlo_as_0116" "NNPDF31_nnlo_as_0118" "NNPDF31_nnlo_as_0120")
#declare -a pdfarr=("CT14nlo" "NNPDF30_nlo_as_0121" "NNPDF31_nlo_as_0116" "NNPDF31_nlo_as_0118" "NNPDF31_nlo_as_0120")
##orig list.
#declare -a pdfarr=("CT14nnlo" "NNPDF30_nnlo_as_0121" "NNPDF31_nnlo_as_0120" "NNPDF31_nnlo_as_0122")



Npdfs=${#pdfarr[@]}
echo "Npdfs=$Npdfs"

for (( i=0; i<${Nscales}; i++ ));
do
    echo "i=$i"
    echo "now doing scale=${scalearr[i]}"
    for (( j=0; j<${Npdfs}; j++ ));
    do
	for (( k=0; k<${NOs}; k++ ));
	do	
	    echo "k=$k"
	    echo "for order=${Oarr[k]}"
	    for (( ybin=0; ybin<Nybins; ybin++ ));
	    do
	    	echo "ybin=${ybin}"
	    	#make new file
	    	fnlo-tk-rootout ${datadir}/grids.v${gridver}/1jet.${Oarr[k]}.fnl6362_y${ybin}_ptjet.tab ${pdfarr[j]} ${PDFunc} _ _ ${scalearr[i]}
	    	#remove the old file
	    	rm ${datadir}/grids.v${gridver}/1jet.${Oarr[k]}.fnl6362_${scalearr[i]}_y${ybin}_${pdfarr[j]}_${PDFunc}.root
	    	#move new file to old file's name!
	    	mv ${datadir}/grids.v${gridver}/1jet.${Oarr[k]}.fnl6362_y_${pdfarr[j]}_${PDFunc}_${scalearr[i]}.root ${datadir}/grids.v${gridver}/1jet.${Oarr[k]}.fnl6362_${scalearr[i]}_y${ybin}_${pdfarr[j]}_${PDFunc}.root	 
	    done    
     	    #end loop over ybins
	    root -l -q "analyze_fastNLO_output.C++(  \"${Oarr[k]}\", \"${PDFunc}\", \"${gridver}\", \"${scalearr[i]}\", \"${pdfarr[j]}\")"	
	done
	#end loop over orders
    done
    #end loop over pdfs
done

#source update_fNLO_files.sh
#end loop over scales


return





##### GRIDS VERSION 1 kScale1 scale choice

fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y0_ptjet.tab CT14nnlo L6 _ _ kScale1
rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y0_CT14nnlo_L6.root
mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y0_CT14nnlo_L6.root

fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y1_ptjet.tab CT14nnlo L6 _ _ kScale1
rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y1_CT14nnlo_L6.root
mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y1_CT14nnlo_L6.root

fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y2_ptjet.tab CT14nnlo L6 _ _ kScale1
rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y2_CT14nnlo_L6.root
mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y2_CT14nnlo_L6.root

fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y3_ptjet.tab CT14nnlo L6 _ _ kScale1
rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y3_CT14nnlo_L6.root
mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale1_y3_CT14nnlo_L6.root

root -l -q "analyze_fastNLO_output.C++(  \"NLO\", \"L6\", \"1\", \"kScale1\")"
#
###### GRIDS VERSION 1 kScale2 scale choice
##
##fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y0_ptjet.tab CT14nnlo L6 _ _ kScale2
##rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y0_CT14nnlo_L6.root
##mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y0_CT14nnlo_L6.root
##
##fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y1_ptjet.tab CT14nnlo L6 _ _ kScale2
##rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y1_CT14nnlo_L6.root
##mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y1_CT14nnlo_L6.root
##
##fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y2_ptjet.tab CT14nnlo L6 _ _ kScale2
##rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y2_CT14nnlo_L6.root
##mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y2_CT14nnlo_L6.root
##
##fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y3_ptjet.tab CT14nnlo L6 _ _ kScale2
##rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y3_CT14nnlo_L6.root
##mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kScale2_y3_CT14nnlo_L6.root
##
##root -l -q "analyze_fastNLO_output.C++(  \"NLO\", \"L6\", \"1\", \"kScale2\")"
#
#
##### GRIDS VERSION 1 kProd scale choice
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y0_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y0_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y0_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y1_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y1_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y1_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y2_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y2_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y2_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y3_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y3_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NLO.fnl6362_kProd_y3_CT14nnlo_L6.root
#
#root -l -q "analyze_fastNLO_output.C++(  \"NLO\", \"L6\", \"1\", \"kProd\")"
#
#
#
#return

## -----------------------------------------##
### --- COMMENT: Below here, NNLO files only.
## -----------------------------------------##

#### GRIDS VERSION 1 kScale1 scale choice

#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y0_ptjet.tab CT14nnlo L6 _ _ kScale1
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y0_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y0_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y1_ptjet.tab CT14nnlo L6 _ _ kScale1
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y1_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y1_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y2_ptjet.tab CT14nnlo L6 _ _ kScale1
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y2_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y2_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y3_ptjet.tab CT14nnlo L6 _ _ kScale1
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y3_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale1.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale1_y3_CT14nnlo_L6.root

root -l -q "analyze_fastNLO_output.C++(  \"NNLO\", \"L6\", \"1\", \"kScale1\")"

##### GRIDS VERSION 1 kScale2 scale choice
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y0_ptjet.tab CT14nnlo L6 _ _ kScale2
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y0_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y0_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y1_ptjet.tab CT14nnlo L6 _ _ kScale2
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y1_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y1_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y2_ptjet.tab CT14nnlo L6 _ _ kScale2
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y2_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y2_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y3_ptjet.tab CT14nnlo L6 _ _ kScale2
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y3_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kScale2.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kScale2_y3_CT14nnlo_L6.root
#
#root -l -q "analyze_fastNLO_output.C++(  \"NNLO\", \"L6\", \"1\", \"kScale2\")"

#echo ""
#echo "-----------------------------------------------------------------------------------"
#echo ""


#### GRIDS VERSION 1 kProd scale choice

#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y0_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y0_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y0_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y1_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y1_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y1_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y2_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y2_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y2_CT14nnlo_L6.root
#
#fnlo-tk-rootout fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y3_ptjet.tab CT14nnlo L6 _ _ kProd
#rm fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y3_CT14nnlo_L6.root
#mv fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_y_CT14nnlo_L6_kProd.root fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v1/1jet.NNLO.fnl6362_kProd_y3_CT14nnlo_L6.root

root -l -q "analyze_fastNLO_output.C++(  \"NNLO\", \"L6\", \"1\", \"kProd\")"

return