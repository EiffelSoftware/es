#Environment to run the testcases
#--------------------------------
#
#- Set up the environment to use the Eiffel Studio Delivery 
#  created from the cdd branch (e.g. using the estudio_tools.sh from 
#  Bernd Schoeller, Andreas Leitner, Philipp Bönhof).
#
#- Set EIFFEL_SRC to point to the Source directory of the CDD 6.0 branch:
#  (CDD_60_BRANCH/Src)
#
#- SET GOBO to point to the directory where GOBO was installed
#
#- Add GOBO to the path

#Adapt these lines to match your environment:
export CFLAGS='-DCAPTURE_REPLAY'
activate_estudio 1XX_wkbench  #assumes that estudio_tools are installed, and the cdd delivery is available via ~/estudio/1XX_wkbench
CURRENT_DIR=`pwd`
export EIFFEL_SRC=$CURRENT_DIR/../Src/ #works, when this script is executed from its folder
export GOBO=~/ETH/Masterarbeit/gobo
export ERL_G=~/ETH/Masterarbeit/erl_g #not used for all testcases

#this should work without changes:
export PATH=$PATH:$GOBO/bin/:$ERL_G/bin/
