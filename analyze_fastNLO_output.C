#include <cstdlib>
#include <cstring>
#include <cassert>
#include <iostream>
//#include <cmath>
//#include <fstream>
//#include <sstream>
//#include <utility>
//#include <algorithm>
//#include <vector>
//#include <sys/stat.h>
//#include <unistd.h>

#include "TROOT.h"
#include "TSystem.h"
#include "TProfile.h"
#include "TStyle.h"
#include "TKey.h"
#include "TClass.h"
#include "TFile.h"
#include "TH1.h"
#include "TH1D.h"
#include "TCanvas.h"
#include "TAxis.h"
#include "TLine.h"
#include "TLegend.h"

#include "fNLO_Klaus_relstatunc.h"
const bool debugMode=true;

const int NFILES=4;
const int NYBINS=4;
const int NHISTS=10;

//const std::string ERRTYPE="L6";
//const std::string ERRTYPE="HC";
//const std::string ERRTYPE="HP";

//const std::string VER="0";
//const std::string VER="1";

//const::std::string SCALE="kScale1"; 
//const std::string SCALE="kProd"  ;

void checkStatErrs(std::string filename, int NORDERS){
  //gotta be careful; the update option will let me overwrite stuff. 
  TFile* f=TFile::Open(filename.c_str(),"READ");
  for(int j=0; j<NORDERS; j++){//loop over orders
    for(int ybin=1;ybin<=4; ybin++){
      std::string h_xsec_str="h"+std::to_string(j)+"100"+std::to_string(ybin)+"00";
      TH1D* h_xsec=(TH1D*)f->Get(h_xsec_str.c_str());
      const int nbinsx=h_xsec->GetNbinsX();
      std::cout<<"h_xsec->GetName()="<<h_xsec->GetName()<<std::endl;
      for(int xbin=1;xbin<=nbinsx;xbin++){
	std::cout<<"h_xsec->GetBinError("<<xbin<<")="<<h_xsec->GetBinError(xbin)<<std::endl;
      }
    }
  }
  f->Close();
  return;
}
void assignCorrectStatErrs(std::string filename, int NORDERS){
  bool funcdebug=true;
  //gotta be careful; the update option will let me overwrite stuff. 
  TFile* f=TFile::Open(filename.c_str(),"UPDATE");
  for(int j=0; j<NORDERS; j++){//loop over orders
    for(int ybin=1;ybin<=4; ybin++){
      
      std::string h_xsec_str="h"+std::to_string(j)+"100"+std::to_string(ybin)+"00";
      TH1D* h_xsec=(TH1D*)f->Get(h_xsec_str.c_str());
      if(funcdebug)std::cout<<"now assigning errors for histname "<<h_xsec_str<<std::endl;
      
      //std::string h_xsecunc_up_str  ="h"+std::to_string(j)+"100"+std::to_string(ybin)+"02";
      //TH1D* h_xsecunc_up=(TH1D*)f->Get(h_xsecunc_up_str.c_str());
      
      //std::string h_xsecunc_down_str="h"+std::to_string(j)+"100"+std::to_string(ybin)+"01";
      //TH1D* h_xsecunc_down=(TH1D*)f->Get(h_xsecunc_down_str.c_str());

      double* statunc;
      int nbinsx_relstatunc;
      if(filename.find("NNLO")!=std::string::npos){//in NNLO file --> h01 --> NNLO, h11 --> NLO, h21 --> LO
	if(j==0){
	  statunc       = (double*)relstatunc_NNLO[ybin-1].data();
	  nbinsx_relstatunc = (int)relstatunc_NNLO[ybin-1].size();      }
	else if(j==1){
	  statunc       = (double*)relstatunc_NLO[ybin-1].data();
	  nbinsx_relstatunc = (int)relstatunc_NLO[ybin-1].size();       }
	else continue;
      }
      else{ //we have an NLO file --> h01 --> NLO, h11 --> LO
	if(j==0){
	  statunc       = (double*)relstatunc_NLO[ybin-1].data();
	  nbinsx_relstatunc = (int)relstatunc_NLO[ybin-1].size();      }
	else continue;
      }
      
      
      const int nbinsx=h_xsec->GetNbinsX();
      if(nbinsx!=nbinsx_relstatunc){
	std::cout<<"ERROR: # of pT bins according to stat unc array is different than # of pT bins in the histogram! Skipping."<<std::endl;
	continue;      }
      
      for(int xbin=1;xbin<=nbinsx;xbin++){
	if(funcdebug)std::cout<<"//-------------------------------------------------------------//"<<std::endl;
	//if(funcdebug)std::cout<<"  h_xsecunc_up->GetBinContent("<<xbin<<")="<<  h_xsecunc_up->GetBinContent(xbin)<<std::endl;
	//if(funcdebug)std::cout<<"h_xsecunc_down->GetBinContent("<<xbin<<")="<<h_xsecunc_down->GetBinContent(xbin)<<std::endl;
	//float avg_rel_err=(h_xsecunc_up->GetBinContent(xbin)-h_xsecunc_down->GetBinContent(xbin))/2.;
	//if(funcdebug)std::cout<<"  avg_rel_err="<<  avg_rel_err<<std::endl;

	if(funcdebug)std::cout<<std::endl;
	if(funcdebug)std::cout<<"h_xsec->GetBinContent("<<xbin<<")="<<h_xsec->GetBinContent(xbin)<<std::endl;
	if(funcdebug)std::cout<<"err before adjustment="<<h_xsec->GetBinError(xbin)<<std::endl;
	float val_err    =h_xsec->GetBinContent(xbin)*((statunc[xbin-1])/100.);
	h_xsec->SetBinError(xbin,val_err);
	if(funcdebug)std::cout<<"err after adjustment="<<h_xsec->GetBinError(xbin)<<std::endl;
	if(funcdebug)std::cout<<std::endl;
      } 
      h_xsec->Write();
    }//end ybin loop
  }//end loop over orders
  f->Close();
  return;
}

//for NNLO we have
//"CT14nnlo" "NNPDF30_nnlo_as_0121" "NNPDF31_nnlo_as_0120" "NNPDF31_nnlo_as_0122"
//for NLO we have
//"CT14nlo" "NNPDF30_nlo_as_0121" "NNPDF31_nlo_as_0120"
void combineNLOandNNLORootFiles(std::string ERRTYPE="L6",			       
				std::string VER="2",			       
				std::string SCALE="kProd",
				std::string PDF="CT14"
				){
  
  if(PDF.find("nnlo")==std::string::npos){
    std::cout<<"ERROR! PDF input="<<PDF<<". must be an nnlo PDF!"<<std::endl;
    return; }
    
  std::cout<<std::endl<<"----- running combineNLOandNNLORootFiles -----"<<std::endl;
  int NORDERS=3;//gonna loop over each object in the NNLO hist --> 3 orders
    
  std::string outfilename="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v"+VER+"/1jet.NNLO.fnl6362_"+SCALE+"_"+PDF+"_"+ERRTYPE+"_TEST.root";
  if(debugMode)std::cout<<"now opening output file: "<<outfilename<<std::endl;  
  TFile* fout=TFile::Open( (outfilename).c_str(), "RECREATE");
  
  std::string nnloPDF=PDF;
  std::string NNLOfilename="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v"+VER+"/1jet.NNLO.fnl6362_"+SCALE+"_"+nnloPDF+"_"+ERRTYPE+".root";
  if(debugMode)std::cout<<"opening NNLO file "<<NNLOfilename<<std::endl;
  TFile* NNLOfin=TFile::Open( (NNLOfilename).c_str(), "READ");
  
  std::string nloPDF=PDF;
  nloPDF.replace( nloPDF.find("nnlo"),4,"nlo");
  std::cout<<"nloPDF="<<nloPDF<<std::endl;
  std::string NLOfilename="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v"+VER+"/1jet.NLO.fnl6362_"+SCALE+"_"+nloPDF+"_"+ERRTYPE+".root";
  if(debugMode)std::cout<<"opening NLO file "<<NLOfilename<<std::endl;
  TFile* NLOfin=TFile::Open( (NLOfilename).c_str(), "READ");
  
   for(int j=0; j<NORDERS; j++){    
    for(int i=0; i<NYBINS; i++){    
      for(int k=0; k<NHISTS; k++){//loop over hist names
	
	//no histnames with these ints, skip
	if( (k>=3) && (k<=5) )continue; 
	

	if(j==0 || j==2){//in this case, it's either NNLO or LO from the NNLO file, and we can just copy those over (no one cares about LO)
	  std::string histname="h"+std::to_string(j)+"100"+std::to_string(i+1)+"0"+std::to_string(k);
	  if(debugMode)std::cout<<"from finNNLO, opening hist "<<histname<<std::endl;	
	  TH1D* h=(TH1D*)NNLOfin->Get((histname).c_str());		  

	  fout->cd();
	  if(debugMode)std::cout<<"writing to new file."<<std::endl;
	  h->Write(histname.c_str());	  
 	  h->Delete();

	  if(k==1||k==2||k==8||k==9){
	    std::string spectraname=histname+"_spectra";
	    if(debugMode)std::cout<<"from finNNLO, opening hist "<<spectraname<<std::endl;	
	    TH1D* h_spectra=(TH1D*)NNLOfin->Get((spectraname).c_str());

	    fout->cd();
	    if(debugMode)std::cout<<"writing to new file."<<std::endl;
	    h_spectra->Write(spectraname.c_str());
	    h_spectra->Delete();
	  }
	}
	else if (j==1){//in this case, it's an NLO hist from the NLO file, and I want to copy that from the NLO file so it's paired with CT14nlo and not CT14nnlo, and fixing the name to stick with the convention my analysis code assumes down the line
	  //grab NLO hist from NLO file --> hist name starts with 'h0100'
	  std::string histname="h0100"+std::to_string(i+1)+"0"+std::to_string(k);
	  if(debugMode)std::cout<<"from finNLO, opening hist "<<histname<<std::endl;	
	  TH1D* h=(TH1D*)NLOfin->Get((histname).c_str());	
	  
	  std::string outhistname="h1100"+std::to_string(i+1)+"0"+std::to_string(k);
	  fout->cd();
	  if(debugMode)std::cout<<"writing to new file."<<std::endl;
	  h->Write(outhistname.c_str());
	  h->Delete();
	  
	  if(k==1||k==2||k==8||k==9){
	    std::string spectraname=histname+"_spectra"
;	    if(debugMode)std::cout<<"from finNLO, opening hist "<<spectraname<<std::endl;	
	    TH1D* h_spectra=(TH1D*)NLOfin->Get((spectraname).c_str());
	    
	    std::string outspectraname=outhistname+"_spectra";
	    fout->cd();
	    if(debugMode)std::cout<<"writing new hist name "<<outspectraname << " to new file."<<std::endl;
	    h_spectra->Write(outspectraname.c_str());
	    h_spectra->Delete();
	  }	  
	}
	
	
      }//end NHISTS loop
    }//end NORDERS loop
  }//end NYBINS loop
  
  fout->Close();
  NLOfin->Close();
  NNLOfin->Close();
    
  
  return;
}


//NOTE: This function also makes the scale + PDF error hists and write
void combineRootFiles(std::string FILEORDER="NNLO", 		       
		      std::string ERRTYPE="L6",			       
		      std::string VER="2",			       
		      std::string SCALE="kProd",
		      std::string PDF="CT14nnlo"
		      ){
  
  std::cout<<std::endl<<"----- running combineRootFiles -----"<<std::endl;

  int NORDERS=-1;
  if(FILEORDER=="NNLO") NORDERS=3;
  else if(FILEORDER=="NLO") NORDERS=2;
  else if(FILEORDER=="LO") NORDERS=1;
  else return;
  
  
  std::string outfilename="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v"+VER+"/1jet."+FILEORDER+".fnl6362_"+SCALE+"_"+PDF+"_"+ERRTYPE+".root";
  if(debugMode)std::cout<<"now opening output file: "<<outfilename<<std::endl;  
  TFile* fout=TFile::Open( (outfilename).c_str(), "RECREATE");
  
  //return;
  
  for(int i=0; i<NFILES; i++){//loop over files, basically loop over |y| bins
    std::string filename="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v"+VER+"/1jet."+FILEORDER+".fnl6362_"+SCALE+"_y";//"0_CT14nnlo_HC.root"
    filename+=std::to_string(i)+"_"+PDF+"_"+ERRTYPE+".root";
    if(debugMode)std::cout<<"opening file "<<filename<<std::endl;
    
    TFile* fin=TFile::Open((filename).c_str(),"READ");

    for(int j=0; j<NORDERS; j++){//loop over orders
      TH1D*   scaleerrUP_spectra=NULL; 
      TH1D* scaleerrDOWN_spectra=NULL;            
      TH1D*   pdferrUP_spectra=NULL; 
      TH1D* pdferrDOWN_spectra=NULL;            

      for(int k=0; k<NHISTS; k++){//loop over hist names

	//no histnames with these ints, skip
	if( (k>=3) && (k<=5) )continue; 
	
	//grab hist
	std::string histname="h"+std::to_string(j)+"10010"+std::to_string(k);
	if(debugMode)std::cout<<"opening hist "<<histname<<std::endl;	
	TH1D* h=(TH1D*)fin->Get((histname).c_str());	
	
	//rename hist according to fastNLO naming convention
	std::string outhistname="h"+std::to_string(j)+"100"+std::to_string(i+1)+"0"+std::to_string(k);
	////begin step 2 edit 
	//h->SetName((outhistname).c_str());
	//h->SetTitle(filename.c_str());
	////end step 2 edit 
	
	//for making scale err as spectra later
	if(k==0){//need to grab the spectra + clone it for each order to adjust the contents to be spectra, instead of fractional error content
	  scaleerrUP_spectra  =(TH1D*)h->Clone((histname+"_scaleerrUP_clone"  ).c_str());
	  scaleerrDOWN_spectra=(TH1D*)h->Clone((histname+"_scaleerrDOWN_clone").c_str());
	  pdferrUP_spectra  =(TH1D*)h->Clone((histname+"_pdferrUP_clone"  ).c_str());
	  pdferrDOWN_spectra=(TH1D*)h->Clone((histname+"_pdferrDOWN_clone").c_str());
	}
	
	////begin step 2 edit
	if(FILEORDER=="NNLO"){
	  if(debugMode)std::cout<<"renaming hist "<<outhistname<<" to ";
	  //if(     outhistname.find("h01")!=std::string::npos)
	  //outhistname.replace(0, 3, "h01");//for NNLO grid output, h01 (NNLO) --> h01 in joao's file, 
	  if(outhistname.find("h11")!=std::string::npos)
	    outhistname.replace(0, 3, "h21");//for NNLO grid output, h11 (LO) --> h21 in joao's file, 
	  else if(outhistname.find("h21")!=std::string::npos)
	    outhistname.replace(0, 3, "h11");//for NNLO grid output, h21 (NLO) --> h11 in joao's file, 
	  if(debugMode)std::cout<<outhistname<<std::endl;
	
	  h->SetName( (outhistname).c_str());
	  h->SetTitle(filename.c_str());
	}
	else {
	  h->SetName( (outhistname).c_str());
	  h->SetTitle(filename.c_str());
	}
	////end step 2 edit

	if(debugMode)std::cout<<"writing hist "<<outhistname<<" to output file"<<std::endl;		
	fout->cd();
	h->Write();
	
	
	if(k==8 || k==9){//make scale err spectra	  
	  std::string spectraname=outhistname+"_spectra";	  
	  if(k==8){//make scaleerrDOWN_spectra
	    scaleerrDOWN_spectra->SetName(spectraname.c_str());
	    for(int b=1; b<=h->GetNbinsX(); b++){
	      scaleerrDOWN_spectra->SetBinContent( b,
						   scaleerrDOWN_spectra->GetBinContent(b)*h->GetBinContent(b) + scaleerrDOWN_spectra->GetBinContent(b) ); 
	    }
	    scaleerrDOWN_spectra->Write();
	    scaleerrDOWN_spectra->Delete();
	  }//end make scaleerrDOWN_spectra	  
	  else if(k==9){//make scaleerrUP_spectra
	    scaleerrUP_spectra  ->SetName(spectraname.c_str());
	    for(int b=1; b<=h->GetNbinsX(); b++){
	      scaleerrUP_spectra  ->SetBinContent( b, 
						   scaleerrUP_spectra->GetBinContent(b)*h->GetBinContent(b) + scaleerrUP_spectra->GetBinContent(b) );
	    }
	    scaleerrUP_spectra  ->Write();
	    scaleerrUP_spectra->Delete();
	  }//end make scaleerrUP_spectra	  	  	  
	}//end make scale err spectra
	
	if(k==1 || k==2){//make pdf err spectra	  
	  std::string spectraname=outhistname+"_spectra";	  
	  if(k==1){//make pdferrDOWN_spectra
	    pdferrDOWN_spectra->SetName(spectraname.c_str());
	    for(int b=1; b<=h->GetNbinsX(); b++){
	      pdferrDOWN_spectra->SetBinContent( b,
						 pdferrDOWN_spectra->GetBinContent(b)*h->GetBinContent(b) + pdferrDOWN_spectra->GetBinContent(b) );	    
	    }
	    pdferrDOWN_spectra->Write();
	    pdferrDOWN_spectra->Delete();
	  }//end make pdferrDOWN_spectra	  
	  else if(k==2){//make pdferrUP_spectra
	    pdferrUP_spectra  ->SetName(spectraname.c_str());
	    for(int b=1; b<=h->GetNbinsX(); b++){
	      pdferrUP_spectra  ->SetBinContent( b, 
						 pdferrUP_spectra->GetBinContent(b)*h->GetBinContent(b) + pdferrUP_spectra->GetBinContent(b) );	    	    
	    }
	    pdferrUP_spectra  ->Write();
	    pdferrUP_spectra->Delete();
	  }//end make pdferrUP_spectra	  	  	  	  
	}//end make pdf err spectra	
	
	h->Delete();
      }//end loop over hist names
    }//end loop over orders
    fin->Close();        
  }
  //if(debugMode)fout->ls();
  fout->Close();
  //std::cout<<"checking staterrs BEFORE correcting them!"<<std::endl;
  //checkStatErrs((std::string)outfilename, NORDERS);
  std::cout<<"assigning correct stat errs"<<std::endl;
  assignCorrectStatErrs((std::string)outfilename, NORDERS);
  //std::cout<<"checking staterrs AFTER correcting them!"<<std::endl;
  //checkStatErrs((std::string)outfilename, NORDERS);
  return;
}



void compareSpectra_joao   (std::string FILEORDER, std::string ERRTYPE, std::string VER, std::string SCALE, std::string PDF){ 
  
  std::cout<<std::endl<<"----- running compareSpectra_joao -----"<<std::endl;
  
  gStyle->SetOptStat(0);
  gROOT->ForceStyle();
  
  std::string foutname="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v"+VER+"/1jet."+FILEORDER+".fnl6362_"+SCALE+"_"+PDF+"_"+ERRTYPE+"_JOAOCOMPARE";
  if(debugMode)std::cout<<"now opening fout: "<<foutname+".root"<<std::endl;
  TFile* fout=TFile::Open((foutname+".root").c_str(), "RECREATE");
  
  TCanvas* canv=new TCanvas("canv", "canv", 800, 800) ;
  canv->cd();
  canv->Print( ( foutname+".pdf[").c_str());//open the pdf file  
  
  std::string fjoaoname="makeHistFromJoaoOutput/JoaoOutput_09.24.20/CMS-5.02TeV-spectra-";
  if       (SCALE=="kProd")fjoaoname+="muHTp/CT14NNLO_PDF/fout_murEQmufEQHTp_v3.root";
  else if(SCALE=="kScale1")fjoaoname+="muPT/CT14NNLO_PDF/fout_murEQmufEQpt_v3.root";
  else if(SCALE=="kScale2")fjoaoname+="muPT/CT14NNLO_PDF/fout_murEQmufEQpt_v3.root";
  if(debugMode)std::cout<<"now opening joaofile: "<<fjoaoname<<std::endl;
  TFile* fjoao=TFile::Open((fjoaoname).c_str(), "READ");
  
  std::string fNLOname="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v"+VER+"/1jet."+FILEORDER+".fnl6362_"+SCALE+"_"+PDF+"_"+ERRTYPE+".root";
  if(debugMode)std::cout<<"now opening fNLO file: "<<fNLOname<<std::endl;
  TFile* fNLO=TFile::Open((fNLOname).c_str(), "READ");
  //fNLO->ls();

  //return;
  
  TIter next(fNLO->GetListOfKeys());
  TKey *key;
  
  while ( (key = (TKey*)next()) ) {//loop over all objects in the root file
    
    std::cout<<std::endl<<"-------------------------------------"<<std::endl;
    
    //if(debugMode)std::cout<<"found key! TKey->GetName()="<<key->GetName()<<std::endl;//debug
    
    TClass *cl = gROOT->GetClass(key->GetClassName());
    if (!cl->InheritsFrom("TH1D")) continue;//if its not a TH1D forget it
    
    TH1D* hist_fNLO = (TH1D*)key->ReadObj();
    std::string histname=(std::string)hist_fNLO->GetName();
    if(histname.find("06")!=std::string::npos ||
       histname.find("07")!=std::string::npos 
       ) {
      if(debugMode)std::cout<<"skipping histname="<<histname<<std::endl;
      continue;
    }
    if(histname.substr(6,7)!="00"){
      if(debugMode)std::cout<<"skipping histname="<<histname<<std::endl;
      continue;
    }

    int nbins=hist_fNLO->GetNbinsX();
    std::vector<double> bins={};
    for(int i=1; i<=nbins; i++)
      bins.push_back(hist_fNLO->GetBinLowEdge(i));
    bins.push_back(hist_fNLO->GetBinLowEdge(nbins)+
		   hist_fNLO->GetBinWidth  (nbins) );
    
    std::string joaohistname=histname;
    if(FILEORDER=="NLO"){
      if(     joaohistname.find("h01")!=std::string::npos)
	joaohistname.replace(0, 3, "h11");//for NLO grid output, h01 (NLO) --> h11 in joao's file, 
      else if(joaohistname.find("h11")!=std::string::npos)
	joaohistname.replace(0, 3, "h21");//for NLO grid output, h11 (LO) --> h21 in joao's file, 
      if(debugMode)std::cout<<"changed joaohistname="<<histname<<" to "<<joaohistname<<std::endl;      
    }
    ////begin step 1 edit
    //else if(FILEORDER=="NNLO"){
    //  if(     joaohistname.find("h01")!=std::string::npos)
    //	joaohistname.replace(0, 3, "h01");//for NNLO grid output, h01 (NNLO) --> h01 in joao's file, 
    //  else if(joaohistname.find("h11")!=std::string::npos)
    //	joaohistname.replace(0, 3, "h21");//for NNLO grid output, h11 (LO) --> h21 in joao's file, 
    //  else if(joaohistname.find("h21")!=std::string::npos)
    //	joaohistname.replace(0, 3, "h11");//for NNLO grid output, h21 (NLO) --> h11 in joao's file, 
    //  if(debugMode)std::cout<<"changed joaohistname="<<histname<<" to "<<joaohistname<<std::endl;      
    //}
    ////end step 1 edit
    
    
    
    TH1D* hist_joao= (TH1D*)fjoao->Get(joaohistname.c_str());    
    hist_joao=(TH1D*)hist_joao->TH1::Rebin(nbins, (joaohistname+"_rebin").c_str() , (double *)bins.data());
    
    TH1D* hist_ratio=(TH1D*)hist_fNLO->Clone( (histname+"_ratio").c_str());                
    hist_ratio->Divide(hist_joao);
    
    hist_ratio->SetMaximum(1.5);
    hist_ratio->SetMinimum(0.5);
    hist_ratio->SetTitle(("scale="+SCALE+", file order="+
			  FILEORDER+", PDFerr="+
			  ERRTYPE+", grids.v"+ VER +", " + histname  ).c_str());    
    //hist_ratio->GetYaxis()->SetTitle(( (std::string)hist_ratio->GetYaxis()->GetTitle() + " Ratio").c_str());
    hist_ratio->GetYaxis()->SetTitle( "Xsec Ratio, (Klaus)/(Joao)");
    hist_ratio->GetYaxis()->CenterTitle(true);

    fout->cd();
    hist_ratio->Write();
    
    if(debugMode)std::cout<<"histname="<<histname<<std::endl;    
    if(debugMode)std::cout<<"histname.substr(6,7)="<<histname.substr(6,7)<<std::endl;    
    if(histname.substr(6,7)=="00"){
      if(debugMode)std::cout<<"making ratio hist with Joao and Klaus' histogram!"<<std::endl;
      if(debugMode)std::cout<<"joaohistname="<<joaohistname<<std::endl;
      if(debugMode)std::cout<<"histname="<<histname<<std::endl;      
      
      TLine* one=new TLine(bins.at(0), 1., bins.at(nbins), 1.);
      one->SetLineStyle(7);
      one->SetLineColor(kBlack);
      one->SetLineWidth(2);      

      std::string joao_hlegdesc1 ="";
      if(     SCALE=="kProd"  )joao_hlegdesc1+="joao output: CMS-5.02TeV-spectra-muHTp/"      ;
      else if(SCALE=="kScale1")joao_hlegdesc1+="joao output: CMS-5.02TeV-spectra-muPT/"      ;
      else if(SCALE=="kScale2")joao_hlegdesc1+="joao output: CMS-5.02TeV-spectra-muPT/"      ;

      std::string joao_hlegdesc2="joao  hist name="+joaohistname+", order=";
      if(     joaohistname.find("h01")!=std::string::npos) joao_hlegdesc2+="NNLO";
      else if(joaohistname.find("h11")!=std::string::npos) joao_hlegdesc2+="NLO";
      else if(joaohistname.find("h21")!=std::string::npos) joao_hlegdesc2+="LO";
      else return;
      
      
      
      std::string klaus_hlegdesc="klaus hist name="+histname+", order=";
      if(FILEORDER=="NNLO"){
	////begin step 3 edit
	//if(     histname.find("h01")!=std::string::npos) klaus_hlegdesc+=" NNLO";
	//else if(histname.find("h11")!=std::string::npos) klaus_hlegdesc+=" LO";
	//else if(histname.find("h21")!=std::string::npos) klaus_hlegdesc+=" NLO";
	//else return;
	if(     histname.find("h01")!=std::string::npos) klaus_hlegdesc+=" NNLO";
	else if(histname.find("h11")!=std::string::npos) klaus_hlegdesc+=" NLO";
	else if(histname.find("h21")!=std::string::npos) klaus_hlegdesc+=" LO";
	else return;
	////end step 3 edit
      }
      else if(FILEORDER=="NLO"){
	if(     histname.find("h01")!=std::string::npos) klaus_hlegdesc+=" NLO";
	else if(histname.find("h11")!=std::string::npos) klaus_hlegdesc+=" LO";
	else return;
      }
      
      

      TLegend* leg=new TLegend(0.4,0.75,0.9,0.9);
      leg->SetFillStyle(0);
      leg->SetBorderSize(0.);
      leg->AddEntry( (TObject*) 0, (klaus_hlegdesc).c_str(), "");
      leg->AddEntry( (TObject*) 0, (joao_hlegdesc2).c_str()    , "");
      leg->AddEntry( (TObject*) 0, (joao_hlegdesc1).c_str()    , "");
      
      
      
      hist_ratio->GetXaxis()->SetMoreLogLabels(true);
      hist_ratio->GetXaxis()->SetNoExponent(true);
      canv->cd()->SetLogx(1);
      canv->cd();
      hist_ratio->Draw("HIST ][ ");
      one->Draw();
      leg->Draw();
      canv->Print((foutname+".pdf").c_str());
      
    }
    
    hist_ratio->Delete();
    hist_joao->Delete();
    hist_fNLO->Delete();
  }  
  
  canv->Print((foutname+".pdf]").c_str());
  //if(debugMode)fout->ls();
  fout->Close();
  fjoao->Close();
  fNLO->Close();
  return;
}


// void compareSpectra_scales   (std::string ERRTYPE, std::string, std::string){ return;}
// void compareSpectra_gridVer  (std::string ERRTYPE, std::string, std::string){ return;}
// void compareSpectra_fileOrder(std::string ERRTYPE, std::string, std::string){ return;}

//for NNLO we have
//"CT14nnlo" "NNPDF30_nnlo_as_0121" "NNPDF31_nnlo_as_0120" "NNPDF31_nnlo_as_0122"
//for NLO we have
//"CT14nlo" "NNPDF30_nlo_as_0121" "NNPDF31_nlo_as_0120"
void analyze_fastNLO_output(   std::string FILEORDER="NNLO", 		       
			       std::string ERRTYPE="L6",			       
			       std::string VER="2",			       
			       //std::string SCALE="kProd",
			       std::string SCALE="kScale1",
			       //			       std::string PDF="CT14nnlo"){
			       std::string PDF="NNPDF31_nnlo_as_0116"){
			       //			       std::string PDF="NNPDF31_nnlo_as_0118"){
			       //			       std::string PDF="NNPDF31_nnlo_as_0120"){
//			       std::string PDF="NNPDF30_nnlo_as_0121"){
  std::cout<<std::endl<<"################# ----- running analyze_fastNLO_output ----- #################"<<std::endl;
  
  //combineRootFiles(FILEORDER, ERRTYPE, VER, SCALE, PDF);  //run this immediately after fnlo-tk-rootout is done with it's job for all |y| bins for given inputs; puts results from all |y| bins into one file
  
  //this now works for CT14 only! gotta figure out how to make it make sense for NNPDF...
  combineNLOandNNLORootFiles(ERRTYPE, VER, SCALE, PDF); // run this after NLO and NNLO combined files have been created; this combines NNLO using an nnlo PDF with the NLO using an nlo pdf into one file.
  

  //DEPRECATED
  //compareSpectra_joao     (FILEORDER, ERRTYPE, VER , SCALE, PDF); //compare all spectra in one of the fast NLO outputs to output from Joao  
  //compareSpectra_scales   (ERRTYPE, FILEORDER,  VER   );//compare all spectra in two ROOT files across scale choice
  //compareSpectra_gridVer  (ERRTYPE, FILEORDER,  SCALE );  //compare all spectra in two ROOT files across grid version
  //compareSpectra_fileOrder(ERRTYPE,       VER,  SCALE );  //compare all spectra in two ROOT files across NLO/NNLO files
  
  
  return;
}
