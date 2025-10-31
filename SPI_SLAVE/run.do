vlib work
vlog -work work SPI_slave.sv +define+SIM
vlog -work work SPI_golden.v
vlog -work work SPI_interface.sv
vlog -work work SPI_shared_pkg.sv
vlog -work work SPI_seq_item.sv
vlog -work work SPI_sequence.sv
vlog -work work SPI_config_object.sv
vlog -work work SPI_sequencer.sv
vlog -work work SPI_driver.sv
vlog -work work SPI_monitor.sv
vlog -work work SPI_agent.sv
vlog -work work SPI_scoreboard.sv
vlog -work work SPI_coverage.sv
vlog -work work SPI_env.sv
vlog -work work SPI_test.sv
vlog -work work SPI_top.sv

vsim -voptargs=+acc work.SPI_top -classdebug -uvmcontrol=all -cover -sv_seed random

add wave -position insertpoint sim:/SPI_top/SPI_if/*
add wave -position insertpoint sim:/SPI_top/DUT/*

coverage save SPI_coverage.ucdb -onexit
run -all

vcover report SPI_coverage.ucdb -details -annotate -all -output SPI_coverage_report.txt