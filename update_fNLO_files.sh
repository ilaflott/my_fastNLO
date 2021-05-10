#!/bin/bash

fromdir="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v2"
todir="/Users/ilaflott/Working/CERNbox/SEMIFINAL_RESULTS/NLOSpectra_NPCs/fNLOJetsSpectra/R04"
scptodir="/home/ilaflott/5p02TeV_ppJetAnalysis/CMSSW_7_5_8/src/doAnalysis/doUnfolding/smearTheory/fNLOJetsSpectra/R04"

##for the NNPDF31's that aren't used to the smeared NLO unfolding, only their NNLO hist is valid, and their NLO hist should not be used.
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0108_L6.root      ${todir}/fout_NNPDF31_nnlo_as_0108_murmufHTp_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0110_L6.root	${todir}/fout_NNPDF31_nnlo_as_0110_murmufHTp_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0112_L6.root	${todir}/fout_NNPDF31_nnlo_as_0112_murmufHTp_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0114_L6.root	${todir}/fout_NNPDF31_nnlo_as_0114_murmufHTp_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0117_L6.root	${todir}/fout_NNPDF31_nnlo_as_0117_murmufHTp_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0119_L6.root	${todir}/fout_NNPDF31_nnlo_as_0119_murmufHTp_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0122_L6.root	${todir}/fout_NNPDF31_nnlo_as_0122_murmufHTp_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0124_L6.root      ${todir}/fout_NNPDF31_nnlo_as_0124_murmufHTp_v4.root
#
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0108_L6.root    ${todir}/fout_NNPDF31_nnlo_as_0108_murmufpt_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0110_L6.root	${todir}/fout_NNPDF31_nnlo_as_0110_murmufpt_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0112_L6.root	${todir}/fout_NNPDF31_nnlo_as_0112_murmufpt_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0114_L6.root	${todir}/fout_NNPDF31_nnlo_as_0114_murmufpt_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0117_L6.root	${todir}/fout_NNPDF31_nnlo_as_0117_murmufpt_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0119_L6.root	${todir}/fout_NNPDF31_nnlo_as_0119_murmufpt_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0122_L6.root	${todir}/fout_NNPDF31_nnlo_as_0122_murmufpt_v4.root
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0124_L6.root    ${todir}/fout_NNPDF31_nnlo_as_0124_murmufpt_v4.root
#
#
#
##these are files that have a NLO estimate using an nlo version of an available nnlo PDF, hence the "_TEST" at the end of the name; it means combineNLOandNNLORootFiles was run on it
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0116_L6_TEST.root      ${todir}/fout_NNPDF31_nnlo_as_0116_murmufHTp_v4.root	
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0118_L6_TEST.root      ${todir}/fout_NNPDF31_nnlo_as_0118_murmufHTp_v4.root	
#cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0120_L6_TEST.root      ${todir}/fout_NNPDF31_nnlo_as_0120_murmufHTp_v4.root	
#
##cp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF30_nnlo_as_0121_L6_TEST.root      ${todir}/fout_NNPDF30_nnlo_as_0121_murmufHTp_v4.root	
##cp ${fromdir}/1jet.NNLO.fnl6362_kProd_CT14nnlo_L6_TEST.root		     ${todir}/fout_CT14nnlo_murmufHTp_v4.root		
#
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0116_L6_TEST.root    ${todir}/fout_NNPDF31_nnlo_as_0116_murmufpt_v4.root	
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0118_L6_TEST.root    ${todir}/fout_NNPDF31_nnlo_as_0118_murmufpt_v4.root	
#cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0120_L6_TEST.root    ${todir}/fout_NNPDF31_nnlo_as_0120_murmufpt_v4.root	
#
##cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF30_nnlo_as_0121_L6_TEST.root    ${todir}/fout_NNPDF30_nnlo_as_0121_murmufpt_v4.root	
##cp ${fromdir}/1jet.NNLO.fnl6362_kScale1_CT14nnlo_L6_TEST.root	    	     ${todir}/fout_CT14nnlo_murmufpt_v4.root                 


#return

#scp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0122_L6_TEST.root     ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_NNPDF31_nnlo_as_0122_murEQmufEQHTp_v4.root    
scp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF31_nnlo_as_0120_L6_TEST.root     ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_NNPDF31_nnlo_as_0120_murEQmufEQHTp_v4.root    
scp ${fromdir}/1jet.NNLO.fnl6362_kProd_NNPDF30_nnlo_as_0121_L6_TEST.root     ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_NNPDF30_nnlo_as_0121_murEQmufEQHTp_v4.root    
scp ${fromdir}/1jet.NNLO.fnl6362_kProd_CT14nnlo_L6_TEST.root		     ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_CT14nnlo_murEQmufEQHTp_v4.root		    
#scp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0122_L6_TEST.root   ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_NNPDF31_nnlo_as_0122_murEQmufEQpt_v4.root	    
scp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF31_nnlo_as_0120_L6_TEST.root   ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_NNPDF31_nnlo_as_0120_murEQmufEQpt_v4.root	    
scp ${fromdir}/1jet.NNLO.fnl6362_kScale1_NNPDF30_nnlo_as_0121_L6_TEST.root   ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_NNPDF30_nnlo_as_0121_murEQmufEQpt_v4.root	    
scp ${fromdir}/1jet.NNLO.fnl6362_kScale1_CT14nnlo_L6_TEST.root	             ilaflott@hexfarm.rutgers.edu:${scptodir}/fnl5020_R04Jets_ybins_CT14nnlo_murEQmufEQpt_v4.root                 

return







