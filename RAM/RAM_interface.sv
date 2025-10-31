interface RAM_interface(clk);
    input clk;
    logic rst_n, rx_valid;
    logic [9:0] din;
    logic [7:0] dout;
    logic tx_valid;
    logic [7:0] dout_golden;
    logic tx_valid_golden;

endinterface