interface SPI_interface ( clk);
input clk;
  logic rst_n;
  logic MOSI;
  logic MISO;
  logic SS_n;
  logic tx_valid;
  logic [7:0] tx_data;
  logic [9:0] rx_data;
  logic rx_valid;
  logic  [9:0] rx_data_golden;
  logic rx_valid_golden;
  logic MISO_golden;
endinterface
