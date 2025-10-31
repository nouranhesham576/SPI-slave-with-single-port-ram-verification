vlib work

vlog -sv -work work -f src_files.list +define+SIM

vsim -voptargs=+acc -classdebug -uvmcontrol=all -assertdebug work.SPI_Wrapper_top

#add wave -position insertpoint sim:/SPI_Wrapper_top/DUT/*
#add wave -position insertpoint sim:/SPI_Wrapper_top/DUT_RAM/*
#add wave -position insertpoint sim:/SPI_Wrapper_top/DUT_SLAVE/*

#add wave -position insertpoint sim:/SPI_Wrapper_top/GOLDEN/*
#add wave -position insertpoint sim:/SPI_Wrapper_top/GM_SLAVE/*
#add wave -position insertpoint sim:/SPI_Wrapper_top/GM_RAM/*

add wave -position insertpoint sim:/SPI_Wrapper_top/wrapper_if/*
add wave -position insertpoint sim:/SPI_Wrapper_top/spi_if/*
add wave -position insertpoint sim:/SPI_Wrapper_top/ram_if/*

run -all