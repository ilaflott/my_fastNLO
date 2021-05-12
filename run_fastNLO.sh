#!bin/bash



## ----- stuff that doesn't change (much) ----- ##
PDFunc="L6"
Nybins=4

declare -a Oarr=("NLO" "NNLO")
NOs=${#Oarr[@]}
echo "NOs=$NOs"

declare -a scalearr=("kScale1" "kProd")
###DEBUG
#declare -a scalearr=("kProd")
###DEBUG
Nscales=${#scalearr[@]}
echo "Nscale=$Nscales"

dorunfastNL0=0
docombineNLOandNNLOrootfiles=1
doupdaterootfiles=1


## ----- stuff that changes more ----- ##
#datadirtag="fnl6362"
datadirtag="fnl6362b"
datadir="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.${datadirtag}"

#gridver="3"
gridver="0"
### DEBUG
#gridver="0"
### DEBUG
echo "grids.v${gridver}"

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



if [[ $dorunfastNLO -eq 1 ]]
then
    ## this loop actually runs fastNLO on the grids
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
		root -l -q "analyze_fastNLO_output.C++(  \"NLO\", \"${PDFunc}\", \"${gridver}\", \"${scalearr[i]}\", \"${nlopdfarr[j]}\", \"${datadirtag}\")"	
		    
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
		    root -l -q "analyze_fastNLO_output.C++(  \"NNLO\", \"${PDFunc}\", \"${gridver}\", \"${scalearr[i]}\", \"${nnlopdfarr[j]}\", \"${datadirtag}\")"			    
		done #nnlopdfs loop
	    fi	    
	done #end loop over orders	
    done #end loop over scales
fi

## this loop is to put the NLO spectra using an nlo PDF into the NNLO file, replacing the NLO estimate that uses an nnlo PDF
## this loop actually runs fastNLO on the grids
fromdir="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.${datadirtag}/grids.v${gridver}"

todir="/Users/ilaflott/Working/CERNbox/SEMIFINAL_RESULTS/NLOSpectra_NPCs/fNLOJetsSpectra/R04"
declare -a todirscalearr=("murmufpt_v0b" "murmufHTp_v0b")

scptodir="/home/ilaflott/5p02TeV_ppJetAnalysis/CMSSW_7_5_8/src/doAnalysis/doUnfolding/smearTheory/fNLOJetsSpectra/R04"
declare -a scptodirscalearr=("murEQmufEQpt_v0b" "murEQmufEQHTp_v0b")

echo "Replacing NLO spectra in NNLO file with NLO spectra using nlo PDF! Then updating the spectra files where need be!"
for (( i=0; i<${Nscales}; i++ ));
do
    if [[ $docombineNLOandNNLOrootfiles -eq 1 ]]
    then
	for (( j=0; j<${Nnlopdfs}; j++ )); #loop over nlopdfarr
	do	
            echo ""
	    echo "	root -l -q \"analyze_fastNLO_output.C++(  \"NLO\", \"${PDFunc}\", \"${gridver}\", \"${scalearr[i]}\", \"${nlopdfarr[j]}\", \"${datadirtag}\", true)\"	"
	    root -l -q "analyze_fastNLO_output.C++(  \"NLO\", \"${PDFunc}\", \"${gridver}\", \"${scalearr[i]}\", \"${nlopdfarr[j]}\", \"${datadirtag}\", true)"	
	done
    fi
    
    if [[ $doupdaterootfiles -eq 1 ]]
    then
	for (( j=0; j<${Nnnlopdfs}; j++ )); #loop over nlopdfarr
	do	

            echo ""
	    
	    #where to copy to locally
	    localtarget="${todir}/fout_${targnnlopdf}_${todirscalearr[i]}.root"
	    #echo "localtarget=${localtarget}"
	    
	    forJohnlocaltarget="/Users/ilaflott/Desktop/forJohn_latest_fastNLO/fout_${targnnlopdf}_${todirscalearr[i]}.root"
	    #echo "forJohnlocaltarget=${forJohnlocaltarget}"

	    #where to copy to on hexfarm
	    hexfarmtarget="${scptodir}/fnl5020_R04Jets_ybins_${targnnlopdf}_${scptodirscalearr[i]}.root"
	    #echo "hexfarmtarget=${hexfarmtarget}"
	    
	    targnnlopdf="${nnlopdfarr[j]}"
	    #echo "targnnlopdf=${targnnlopdf}"
	    
	    outputfile="${fromdir}/1jet.NNLO.${datadirtag}_${scalearr[i]}_${targnnlopdf}_${PDFunc}_TEST.root"
	    #echo "outputfile=${outputfile}"
	    	    
	    #check if file exists with the _TEST.root string at the end. if it doesn't, remove it and grab the one without [because that's one without a corresponding nlo PDF, so it doesn't have _TEST.root at the end]
	    if [[ -f "$outputfile" ]]
	    then
		echo "file exists! outputfile=$outputfile"
		echo "ls ${outputfile}"
		ls ${outputfile}
		
		echo "copying..."
 	        cp ${outputfile} ${localtarget}	
 	        cp ${outputfile} ${forJohnlocaltarget}	
		#scp ${outputfile} ilaflott@hexfarm.rutgers.edu:${hexfarmtarget}
	    else 
		echo "file does not exist! trying diff filename"
		outputfile="${fromdir}/1jet.NNLO.${datadirtag}_${scalearr[i]}_${targnnlopdf}_${PDFunc}.root"
		echo "outputfile=${outputfile}"
		echo "ls $outputfile"
		ls $outputfile
		
		if [[ -f "$outputfile" ]]
		then
		    echo "file exists after trying diff filename!"
		    echo "copying..."
		    cp ${outputfile} ${localtarget}	
		    cp ${outputfile} ${forJohnlocaltarget}	
		    #scp ${outputfile} ilaflott@hexfarm.rutgers.edu:${hexfarmtarget}
		else
		    echo "something wrong... check bash script...return"
		    return
		fi
	    fi
	done
    fi
#source update_fNLO_files.sh
done

return