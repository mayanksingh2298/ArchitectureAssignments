# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4/lab4.cache/wt [current_project]
set_property parent.project_path /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4/lab4.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4/lab4.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/Lab4/Lab4.vhf
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top MainDataPath -part xc7a35tcpg236-1


write_checkpoint -force -noxdef MainDataPath.dcp

catch { report_utilization -file MainDataPath_utilization_synth.rpt -pb MainDataPath_utilization_synth.pb }