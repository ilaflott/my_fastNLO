#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <cassert>
#include <string>

#include "TROOT.h"
#include "TStyle.h"
#include "TFile.h"
#include "TKey.h"
#include "TClass.h"
#include "TH1.h"
#include "TH2.h"
#include "TCanvas.h"
#include "TLegend.h"
#include "TPaveText.h"
#include "TLine.h"
#include "TAttLine.h"
#include "TAxis.h"
#include "TF1.h"

const std::string basedir="fastnlo_toolkit-2.3.1-2753/data/1jet.CMS5-ak04.fnl6362/grids.v";

void makeRelStatUnc_targDat(std::string ybin, std::string order, std::string gridver){
  std::string fname=basedir+gridver+"/1jet."+order+".fnl6362_y"+ybin+"_ptjet_copy.dat";
  std::string foutname=basedir+gridver+"/1jet."+order+".fnl6362_y"+ybin+"_ptjet_relstatunc.txt";

  //open the text file
  std::ifstream instr_dat_file(fname, std::ifstream::in);
  if(!instr_dat_file.is_open()){
    std::cout<<"dat file is zombie. exit"<<std::endl;return;}
  
  std::string currentLine;
  int linecount=0;
  while(!instr_dat_file.eof()){
    linecount++;
    if(linecount<=3){//first three lines are junk; skip
      getline(instr_dat_file,currentLine);
      std::cout<<"currentLine="<<currentLine<<std::endl;
      continue;
    }
    else {//actually grab stuff --> rel stat unc for i'th pT bin is the 5'th column val divided by the 4'th column val
      getline(instr_dat_file,currentLine);
      //std::cout<<"currentLine="<<currentLine<<std::endl;      
    }
  }
  

  
  return;
}

void makeRelStatUnc(){
  //test and/or debug
  makeRelStatUnc_targDat("0","NLO","2");
  
  ////run for real
  //for(int i=0, i<4; i++){
  //  for(int j=0; j<1; j++){
  //    std::string order="";
  //    if(j==0)order="NLO";
  //    else if(j==1)order="NNLO";
  //    makeRelStatUnc_targDat(std::to_string(i), order, "2");
  //  }
  //}

  return;
}
