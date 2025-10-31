module SPI_Wrapper_golden ( MOSI, SS_n, clk, rst_n,MISO_golden);
input MOSI, SS_n, clk, rst_n;
output MISO_golden;

wire [9:0] rx_data_golden;//din
wire rx_valid_golden;
wire [7:0] dout_golden;//tx_data
wire tx_valid_golden;

spi_golden spi_golden (MOSI, MISO_golden, SS_n,clk,rst_n,rx_data_golden,rx_valid_golden,
dout_golden[7:0], tx_valid_golden);

RAM_golden ram_golden (clk,rst_n,rx_data_golden, rx_valid_golden,dout_golden, tx_valid_golden);

endmodule

