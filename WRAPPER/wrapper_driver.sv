package SPI_Wrapper_driver_pkg;
import uvm_pkg::*;
import SPI_Wrapper_seq_item_pkg::*;
import SPI_Wrapper_config_pkg::*;
`include "uvm_macros.svh"

class SPI_Wrapper_driver extends uvm_driver #(SPI_Wrapper_seq_item);
`uvm_component_utils(SPI_Wrapper_driver)

virtual SPI_Wrapper_interface wrapper_vif;
SPI_Wrapper_seq_item stim_seq_item;
    
function new(string name = "SPI_Wrapper_driver", uvm_component parent = null);
        super.new(name, parent);
endfunction
    
task run_phase(uvm_phase phase);
        super.run_phase(phase);
forever begin
        stim_seq_item = SPI_Wrapper_seq_item::type_id::create("stim_seq_item");
        seq_item_port.get_next_item(stim_seq_item);

        wrapper_vif.rst_n = stim_seq_item.rst_n;
        wrapper_vif.SS_n = stim_seq_item.SS_n;
        wrapper_vif.MOSI = stim_seq_item.MOSI;
        
        @(negedge wrapper_vif.clk);
        
        seq_item_port.item_done();
        end
    endtask
endclass
endpackage