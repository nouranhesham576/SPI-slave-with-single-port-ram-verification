package SPI_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;
import SPI_shared_pkg::*;

class SPI_driver extends uvm_driver #(SPI_seq_item);
`uvm_component_utils(SPI_driver)
virtual SPI_interface SPI_vif;
SPI_seq_item stim_seq_item;

function new(string name = "SPI_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction 

function void build_phase(uvm_phase phase);
            super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        stim_seq_item = SPI_seq_item::type_id::create("stim_seq_item");
        seq_item_port.get_next_item(stim_seq_item);
            SPI_vif.rst_n = stim_seq_item.rst_n;                   
            SPI_vif.tx_data = stim_seq_item.tx_data;     
            SPI_vif.tx_valid = stim_seq_item.tx_valid;   
            SPI_vif.SS_n = stim_seq_item.SS_n;    
            SPI_vif.MOSI = stim_seq_item.MOSI_data; 
            @(negedge SPI_vif.clk);
            seq_item_port.item_done();
        end
`uvm_info("DRIVER", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
     
endtask
endclass
endpackage