module SPI_Wrapper_top ();
  
  import uvm_pkg::*;
  import SPI_Wrapper_test_pkg::*;
  
  `include "uvm_macros.svh"

  bit clk;

  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  SPI_Wrapper_interface wrapper_if (clk);
  SPI_interface spi_if (clk);
  RAM_interface ram_if (clk);

  SPI_Wrapper DUT (wrapper_if.MOSI,wrapper_if.MISO,wrapper_if.SS_n,wrapper_if.clk,wrapper_if.rst_n);

  SPI_Wrapper_golden GOLDEN (wrapper_if.MOSI, wrapper_if.SS_n, wrapper_if.clk, wrapper_if.rst_n, wrapper_if.MISO_golden);

  SLAVE DUT_SLAVE (spi_if.MOSI,spi_if.MISO,spi_if.SS_n,spi_if.clk,spi_if.rst_n,spi_if.rx_data,spi_if.rx_valid,spi_if.tx_data,spi_if.tx_valid);

  spi_golden GM_SLAVE (spi_if.MOSI,spi_if.MISO_golden,spi_if.SS_n,spi_if.clk,spi_if.rst_n,spi_if.rx_data_golden,spi_if.rx_valid_golden,spi_if.tx_data,spi_if.tx_valid);

  RAM DUT_RAM (ram_if.din,clk,ram_if.rst_n,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);

  RAM_golden GM_RAM (clk,ram_if.rst_n,ram_if.din,ram_if.rx_valid,ram_if.dout_golden,ram_if.tx_valid_golden);

  assign spi_if.MOSI     = DUT.MOSI;
  assign spi_if.SS_n     = DUT.SS_n;
  assign spi_if.rst_n    = DUT.rst_n;
  assign spi_if.tx_valid = DUT.tx_valid;
  assign spi_if.tx_data  = DUT.tx_data_dout;

  assign ram_if.rx_valid = DUT.rx_valid;
  assign ram_if.rst_n    = DUT.rst_n;
  assign ram_if.din      = DUT.rx_data_din;

  initial begin
    uvm_config_db#(virtual SPI_Wrapper_interface)::set(null, "uvm_test_top", "Config_key", wrapper_if);
    uvm_config_db#(virtual SPI_interface)::set(null, "uvm_test_top", "Config_key", spi_if);
    uvm_config_db#(virtual RAM_interface)::set(null, "uvm_test_top", "Config_key", ram_if);
    run_test("SPI_Wrapper_test");
  end

  initial begin
    $readmemh("ram.data", DUT.RAM_instance.MEM);
    $readmemh("ram.data", DUT_RAM.MEM);
    $readmemh("ram_golden.data", GM_RAM.mem);
    $readmemh("ram_golden.data", GOLDEN.ram_golden.mem);
  end
endmodule
