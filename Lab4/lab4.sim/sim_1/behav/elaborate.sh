#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto c583d4283bba4910b9413ca7d9fb7fda -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot MainDataPath_behav xil_defaultlib.MainDataPath -log elaborate.log
