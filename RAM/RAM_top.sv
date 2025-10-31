import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_test_pkg::*;

module RAM_top();
    bit clk;
    initial begin
        clk=0;
        forever #10 clk=~clk;
    end
    
    RAM_interface RAM_if (clk);
 
   RAM_golden goldenmodel(
        .din   (RAM_if.din),
        .clk     (RAM_if.clk),
        .rst_n   (RAM_if.rst_n),
        .rx_valid(RAM_if.rx_valid),
        .dout    (RAM_if.dout_golden),
        .tx_valid(RAM_if.tx_valid_golden)
    );

   RAM DUT(
        .din   (RAM_if.din),
        .clk     (RAM_if.clk),
        .rst_n   (RAM_if.rst_n),
        .rx_valid(RAM_if.rx_valid),
        .dout    (RAM_if.dout),
        .tx_valid(RAM_if.tx_valid)
    );

   //RAM_assertions SVA(RAM_if);

    initial begin
        uvm_config_db #(virtual RAM_interface)::set(null,"uvm_test_top", "RAM_if", RAM_if);
        run_test("RAM_test");
    end
endmodule