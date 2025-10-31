package RAM_sequencer_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;

class RAM_sequencer_c extends uvm_sequencer #(RAM_seq_item_c);
`uvm_component_utils(RAM_sequencer_c)

function new(string name = "RAM_sequencer_c" , uvm_component parent = null);
            super.new(name,parent);
endfunction

endclass
endpackage