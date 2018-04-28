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
ExecStep $xv_path/bin/xsim mainBus_time_synth -key {Post-Synthesis:sim_1:Timing:mainBus} -tclbatch mainBus.tcl -log simulate.log
