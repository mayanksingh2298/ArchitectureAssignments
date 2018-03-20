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
ExecStep $xv_path/bin/xelab -wto 259efc0b753d4284a9a547a77ae4cefa -m64 --debug typical --relax --mt 8 -L blk_mem_gen_v8_3_5 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot MasterController_behav xil_defaultlib.MasterController xil_defaultlib.glbl -log elaborate.log
