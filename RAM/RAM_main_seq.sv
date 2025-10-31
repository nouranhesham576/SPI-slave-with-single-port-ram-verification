package RAM_main_seq_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_seq_item_pkg::*;

class RAM_main_seq_c extends uvm_sequence #(RAM_seq_item_c);
`uvm_object_utils(RAM_main_seq_c)  

RAM_seq_item_c RAM_seq_item ;

function new (string name = "RAM_main_seq_c");
            super.new(name);
endfunction

task body();
        repeat(10000) begin
            RAM_seq_item = RAM_seq_item_c::type_id::create("RAM_seq_item");
            start_item(RAM_seq_item);
            assert (RAM_seq_item.randomize());
            finish_item(RAM_seq_item);
        end
        endtask
    endclass
endpackage