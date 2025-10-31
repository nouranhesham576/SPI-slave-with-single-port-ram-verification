package RAM_rst_seq_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_seq_item_pkg::*;
import RAM_sequencer_pkg::*;

class RAM_rst_seq_c extends uvm_sequence #(RAM_seq_item_c);
    `uvm_object_utils(RAM_rst_seq_c)    
    RAM_seq_item_c RAM_seq_item_obj;

function new(string name = "RAM_rst_seq_c");
        super.new(name);
endfunction

task body();
        RAM_seq_item_obj = RAM_seq_item_c::type_id::create("RAM_seq_item_obj");
        start_item(RAM_seq_item_obj);
        RAM_seq_item_obj.rst_n=0;
        RAM_seq_item_obj.rx_valid=0;
        RAM_seq_item_obj.din=0;
        RAM_seq_item_obj.dout=0;
        RAM_seq_item_obj.tx_valid=0;
        finish_item(RAM_seq_item_obj);
endtask 

endclass
endpackage