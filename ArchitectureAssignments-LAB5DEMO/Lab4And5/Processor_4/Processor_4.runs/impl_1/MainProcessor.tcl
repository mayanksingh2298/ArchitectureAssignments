proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/ArchitectureAssignments-LAB5DEMO/Lab4And5/Processor_4/Processor_4.cache/wt [current_project]
  set_property parent.project_path /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/ArchitectureAssignments-LAB5DEMO/Lab4And5/Processor_4/Processor_4.xpr [current_project]
  set_property ip_output_repo /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/ArchitectureAssignments-LAB5DEMO/Lab4And5/Processor_4/Processor_4.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files -quiet /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/ArchitectureAssignments-LAB5DEMO/Lab4And5/Processor_4/Processor_4.runs/synth_1/MainProcessor.dcp
  add_files -quiet /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/ArchitectureAssignments-LAB5DEMO/Lab4And5/Processor_4/Processor_4.srcs/sources_1/bd/BRAM/ip/BRAM_blk_mem_gen_0_0/BRAM_blk_mem_gen_0_0.dcp
  set_property netlist_only true [get_files /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/ArchitectureAssignments-LAB5DEMO/Lab4And5/Processor_4/Processor_4.srcs/sources_1/bd/BRAM/ip/BRAM_blk_mem_gen_0_0/BRAM_blk_mem_gen_0_0.dcp]
  read_xdc /home/mayanksingh2298/IIT_Course/sem4/col216/Labs/ArchitectureAssignments-LAB5DEMO/Lab4And5/Processor.xdc
  link_design -top MainProcessor -part xc7a35tcpg236-1
  write_hwdef -file MainProcessor.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force MainProcessor_opt.dcp
  catch { report_drc -file MainProcessor_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force MainProcessor_placed.dcp
  catch { report_io -file MainProcessor_io_placed.rpt }
  catch { report_utilization -file MainProcessor_utilization_placed.rpt -pb MainProcessor_utilization_placed.pb }
  catch { report_control_sets -verbose -file MainProcessor_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force MainProcessor_routed.dcp
  catch { report_drc -file MainProcessor_drc_routed.rpt -pb MainProcessor_drc_routed.pb -rpx MainProcessor_drc_routed.rpx }
  catch { report_methodology -file MainProcessor_methodology_drc_routed.rpt -rpx MainProcessor_methodology_drc_routed.rpx }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file MainProcessor_timing_summary_routed.rpt -rpx MainProcessor_timing_summary_routed.rpx }
  catch { report_power -file MainProcessor_power_routed.rpt -pb MainProcessor_power_summary_routed.pb -rpx MainProcessor_power_routed.rpx }
  catch { report_route_status -file MainProcessor_route_status.rpt -pb MainProcessor_route_status.pb }
  catch { report_clock_utilization -file MainProcessor_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force MainProcessor_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  catch { write_mem_info -force MainProcessor.mmi }
  write_bitstream -force -no_partial_bitfile MainProcessor.bit 
  catch { write_sysdef -hwdef MainProcessor.hwdef -bitfile MainProcessor.bit -meminfo MainProcessor.mmi -file MainProcessor.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

