module SPI_top();
import uvm_pkg::*;
import SPI_test_pkg::*;
`include "uvm_macros.svh"
bit clk;

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

SPI_interface SPI_if(clk);

SLAVE DUT (SPI_if.MOSI,SPI_if.MISO,SPI_if.SS_n,SPI_if.clk,SPI_if.rst_n,
          SPI_if.rx_data,SPI_if.rx_valid,SPI_if.tx_data,SPI_if.tx_valid
);

spi_golden golden_ref (SPI_if.MOSI,SPI_if.MISO_golden,SPI_if.SS_n,SPI_if.clk,SPI_if.rst_n,
        SPI_if.rx_data_golden,SPI_if.rx_valid_golden,SPI_if.tx_data,SPI_if.tx_valid);

initial begin
    uvm_config_db#(virtual SPI_interface)::set(null, "uvm_test_top", "Config_key", SPI_if);
    run_test("SPI_test");     
end

endmodule