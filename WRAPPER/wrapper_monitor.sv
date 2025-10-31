package SPI_Wrapper_monitor_pkg;
import uvm_pkg::*;
import SPI_Wrapper_seq_item_pkg::*;
`include "uvm_macros.svh"

class SPI_Wrapper_monitor extends uvm_monitor;
 `uvm_component_utils(SPI_Wrapper_monitor)
    
virtual SPI_Wrapper_interface wrapper_vif;
SPI_Wrapper_seq_item rsp_seq_item;
uvm_analysis_port #(SPI_Wrapper_seq_item) mon_ap;
    
function new(string name = "SPI_Wrapper_monitor", uvm_component parent = null);
        super.new(name, parent);
endfunction
    
function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
endfunction
    
task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rsp_seq_item = SPI_Wrapper_seq_item::type_id::create("rsp_seq_item");
            @(negedge wrapper_vif.clk);
            rsp_seq_item.rst_n = wrapper_vif.rst_n;
            rsp_seq_item.SS_n = wrapper_vif.SS_n;
            rsp_seq_item.MOSI = wrapper_vif.MOSI;
            rsp_seq_item.MISO = wrapper_vif.MISO;
            rsp_seq_item.MISO_golden = wrapper_vif.MISO_golden;
            mon_ap.write(rsp_seq_item);
        end
    endtask
endclass
endpackage