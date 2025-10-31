package SPI_sequencer_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import SPI_seq_item_pkg::*;

class SPI_sequencer extends uvm_sequencer #(SPI_seq_item);
`uvm_component_utils(SPI_sequencer)

function new (string name = "SPI_sequencer",uvm_component parent = null);
    super.new(name,parent);
endfunction
    
endclass
endpackage
