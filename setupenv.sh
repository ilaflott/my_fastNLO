#!bin/bash


###for LHAPDF
export PATH=$PWD/local/bin:$PATH
export PYTHONPATH=$PWD/local/lib/python2.7/site-packages
#export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH #not needed?


source /Users/ilaflott/Working/root/bin/thisroot.sh

#. $(brew --prefix root6)/libexec/thisroot.sh

#function rootcompile()
#{
#    if [[ $# -ne 1 ]]
#    then
#        echo "to compile macro someScript.C to someScript.exe, do..."
#        echo "rootcompile someScript.C"
#    else
#        local NAME=$1
#        g++ "${NAME}" $(root-config --cflags --libs) -Werror -Wall -O2 -o "${NAME/%.C/}.exe"
#    fi
#}