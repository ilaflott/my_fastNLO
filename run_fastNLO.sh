#!bin/bash

PDFunc="L6"

Nybins=4
datadirtag="fnl6362"
#datadirtag="fnl6362b"
datadir="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.${datadirtag}"

declare -a Oarr=("NLO" "NNLO")
NOs=${#Oarr[@]}
echo "NOs=$NOs"

gridver="3"
### DEBUG
#gridver="0"
### DEBUG
echo "grids.v${gridver}"

declare -a scalearr=("kScale1" "kProd")
###DEBUG
#declare -a scalearr=("kProd")
###DEBUG
Nscales=${#scalearr[@]}
echo "Nscale=$Nscales"


#nnlo pdfs --> use NNLO grid file(s)
declare -a nnlopdfarr=("CT14nnlo" "NNPDF30_nnlo_as_0121" "NNPDF31_nnlo_as_0108" "NNPDF31_nnlo_as_0110" "NNPDF31_nnlo_as_0112" "NNPDF31_nnlo_as_0114" "NNPDF31_nnlo_as_0116" "NNPDF31_nnlo_as_0117" "NNPDF31_nnlo_as_0118" "NNPDF31_nnlo_as_0119" "NNPDF31_nnlo_as_0120" "NNPDF31_nnlo_as_0122" "NNPDF31_nnlo_as_0124")
### DEBUG
#declare -a nnlopdfarr=("CT14nnlo")
### DEBUG
Nnnlopdfs=${#nnlopdfarr[@]}

#nlo pdfs --> use NLO grid file(s)
declare -a nlopdfarr=("CT14nlo" "NNPDF30_nlo_as_0121" "NNPDF31_nlo_as_0116" "NNPDF31_nlo_as_0118" "NNPDF31_nlo_as_0120")
### DEBUG
#declare -a nlopdfarr=("CT14nlo")
### DEBUG
Nnlopdfs=${#nlopdfarr[@]}

#Npdfs=${#pdfarr[@]}
#echo "Npdfs=$Npdfs"

for (( i=0; i<${Nscales}; i++ ));
do
    
    for (( k=0; k<${NOs}; k++ ));
    do	
	order=${Oarr[k]}
	
	if [[ "$order" == "NLO" ]]
	then
	    
	    for (( j=0; j<${Nnlopdfs}; j++ )); #loop over nlopdfarr
	    do	    
		for (( ybin=0; ybin<Nybins; ybin++ ));
		do
		    echo "i=$i"
		    echo "now doing scale=${scalearr[i]}"
		    echo "for order=$order"		
		    echo "for nlopdf=${nlopdfarr[j]}"
		    echo "ybin=${ybin}, running fnlo-tk-rootout"
		    
 	            #make new file
    		    fnlo-tk-rootout ${datadir}/grids.v${gridver}/1jet.NLO.${datadirtag}_y${ybin}_ptjet.tab ${nlopdfarr[j]} ${PDFunc} _ _ ${scalearr[i]}
		    
	    	    #remove the old file; probably don't need to, just to be safe.
	    	    rm ${datadir}/grids.v${gridver}/1jet.NLO.${datadirtag}_${scalearr[i]}_y${ybin}_${nlopdfarr[j]}_${PDFunc}.root
		    
	    	    #move new file to old file's name!
	    	    mv ${datadir}/grids.v${gridver}/1jet.NLO.${datadirtag}_y_${nlopdfarr[j]}_${PDFunc}_${scalearr[i]}.root ${datadir}/grids.v${gridver}/1jet.NLO.${datadirtag}_${scalearr[i]}_y${ybin}_${nlopdfarr[j]}_${PDFunc}.root	 
		    
		done #ybin loop
		root -l -q "analyze_fastNLO_output.C++(  \"NLO\", \"${PDFunc}\", \"${gridver}\", \"${scalearr[i]}\", \"${nlopdfarr[j]}\")"	
		
	    done #nlopdfs loop
	else
	    #loop over nnlopdfarr
	    for (( j=0; j<${Nnnlopdfs}; j++ ));
	    do
		for (( ybin=0; ybin<Nybins; ybin++ ));
		do
		    echo "i=$i"
		    echo "now doing scale=${scalearr[i]}"
		    echo "for order=$order"		
		    echo "for nnlopdf=${nnlopdfarr[j]}"
		    echo "ybin=${ybin}, running fnlo-tk-rootout"
	            #make new file
    		    fnlo-tk-rootout ${datadir}/grids.v${gridver}/1jet.NNLO.${datadirtag}_y${ybin}_ptjet.tab ${nnlopdfarr[j]} ${PDFunc} _ _ ${scalearr[i]}
		    
	    	    #remove the old file; probably don't need to, just to be safe.
	    	    rm ${datadir}/grids.v${gridver}/1jet.NNLO.${datadirtag}_${scalearr[i]}_y${ybin}_${nnlopdfarr[j]}_${PDFunc}.root
		    
	    	    #move new file to old file's name!
	    	    mv ${datadir}/grids.v${gridver}/1jet.NNLO.${datadirtag}_y_${nnlopdfarr[j]}_${PDFunc}_${scalearr[i]}.root ${datadir}/grids.v${gridver}/1jet.NNLO.${datadirtag}_${scalearr[i]}_y${ybin}_${nnlopdfarr[j]}_${PDFunc}.root	 
		    
		done #ybin loop
		root -l -q "analyze_fastNLO_output.C++(  \"NNLO\", \"${PDFunc}\", \"${gridver}\", \"${scalearr[i]}\", \"${nnlopdfarr[j]}\")"	
		
	    done #nnlopdfs loop
	fi
	
    done #end loop over orders
    
done #end loop over scales



#source update_fNLO_files.sh


return
