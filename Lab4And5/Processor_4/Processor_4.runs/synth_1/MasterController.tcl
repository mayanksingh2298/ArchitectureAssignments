# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.cache/wt [current_project]
set_property parent.project_path /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.srcs/sources_1/imports/hdl/BRAM_wrapper.vhd
  /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Lab4.vhf
  /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab5/Lab5Controller.vhf
}
add_files /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.srcs/sources_1/bd/BRAM/BRAM.bd
set_property used_in_implementation false [get_files -all /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.srcs/sources_1/bd/BRAM/ip/BRAM_blk_mem_gen_0_0/BRAM_blk_mem_gen_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.srcs/sources_1/bd/BRAM/BRAM_ooc.xdc]
set_property is_locked true [get_files /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4And5/Processor_4/Processor_4.srcs/sources_1/bd/BRAM/BRAM.bd]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top MasterController -part xc7a35tcpg236-1


write_checkpoint -force -noxdef MasterController.dcp

catch { report_utilization -file MasterController_utilization_synth.rpt -pb MasterController_utilization_synth.pb }
