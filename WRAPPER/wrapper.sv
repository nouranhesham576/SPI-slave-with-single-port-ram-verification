module SPI_Wrapper (MOSI,MISO,SS_n,clk,rst_n);

input  MOSI, SS_n, clk, rst_n;
output MISO;

wire [9:0] rx_data_din;
wire       rx_valid;
wire       tx_valid;
wire [7:0] tx_data_dout;

RAM   RAM_instance   (rx_data_din,clk,rst_n,rx_valid,tx_data_dout,tx_valid);

SLAVE SLAVE_instance (MOSI,MISO,SS_n,clk,rst_n,rx_data_din,rx_valid,tx_data_dout,tx_valid);

//ASSERTIONS
property assert_reset;
    @(posedge clk) (!rst_n) |=> (MISO=='0);
endproperty
assert property (assert_reset);
cover property (assert_reset);


property MISO_STABLE_NOT_READ;
  @(posedge clk) disable iff (!rst_n)
  $fell(SS_n) |=> (!MOSI) [*0:3] ##1 ($stable(MISO) throughout (!SS_n));
endproperty
assert property (MISO_STABLE_NOT_READ);
cover property (MISO_STABLE_NOT_READ);

endmodule