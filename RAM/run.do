vlib work
vmap work work

vlog -work work RAM.sv +define+SIM
vlog -work work RAM_interface.sv
vlog -work work RAM_goldenmodel.sv
vlog -work work RAM_Config.sv
vlog -work work RAM_seq_item.sv
vlog -work work RAM_rd_seq.sv
vlog -work work RAM_wr_seq.sv
vlog -work work RAM_rd_wr_seq.sv
vlog -work work RAM_rst_seq.sv
vlog -work work RAM_main_seq.sv
vlog -work work RAM_driver.sv
vlog -work work RAM_mon.sv
vlog -work work RAM_agent.sv
vlog -work work RAM_sb.sv
vlog -work work RAM_coverage.sv
vlog -work work RAM_env.sv
vlog -work work RAM_sequencer.sv
vlog -work work RAM_test.sv
vlog -work work RAM_top.sv

vsim -voptargs=+acc work.RAM_top -classdebug -uvmcontrol=all -cover -sv_seed random

add wave -position insertpoint sim:/RAM_top/RAM_if/*
add wave -position insertpoint sim:/RAM_top/DUT/*

coverage save RAM_coverage.ucdb -onexit
run -all

vcover report RAM_coverage.ucdb -details -annotate -all -output RAM_coverage_report.txt
