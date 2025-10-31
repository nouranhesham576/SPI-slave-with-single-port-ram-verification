package SPI_monitor_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import SPI_seq_item_pkg::*;
import SPI_shared_pkg::*;  

class SPI_monitor extends uvm_monitor;
    `uvm_component_utils(SPI_monitor)

    virtual SPI_interface SPI_vif;
    SPI_seq_item rsp_seq_item;
    uvm_analysis_port #(SPI_seq_item) mon_ap;

    function new(string name = "SPI_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction
task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        rsp_seq_item = SPI_seq_item::type_id::create("rsp_seq_item");
        @(negedge SPI_vif.clk);

        // DUT inputs
        rsp_seq_item.rst_n    = SPI_vif.rst_n;
        rsp_seq_item.SS_n     = SPI_vif.SS_n;
        rsp_seq_item.MOSI     = SPI_vif.MOSI;
        rsp_seq_item.tx_data  = SPI_vif.tx_data;
        rsp_seq_item.tx_valid = SPI_vif.tx_valid;

        // DUT outputs
        rsp_seq_item.MISO     = SPI_vif.MISO;
        rsp_seq_item.rx_data  = SPI_vif.rx_data;
        rsp_seq_item.rx_valid = SPI_vif.rx_valid;

        // Golden model outputs
        rsp_seq_item.MISO_golden     = SPI_vif.MISO_golden;
        rsp_seq_item.rx_data_golden  = SPI_vif.rx_data_golden;
        rsp_seq_item.rx_valid_golden = SPI_vif.rx_valid_golden;

        // send to scoreboard and coverage
        mon_ap.write(rsp_seq_item);
`uvm_info("MONITOR", rsp_seq_item.convert2string(), UVM_HIGH)
    end
endtask

endclass

endpackage