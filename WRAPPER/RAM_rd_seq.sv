package RAM_rd_seq_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_seq_item_pkg::*;

class RAM_rd_seq_c extends uvm_sequence #(RAM_seq_item_c);
`uvm_object_utils(RAM_rd_seq_c)

RAM_seq_item_c RAM_seq_item_obj;

function new(string name = "RAM_rd_seq_c");
            super.new(name);
endfunction

task body();
    bit [1:0] prev_cmd = 2'b00;
        repeat(10000) begin
                RAM_seq_item_obj = RAM_seq_item_c::type_id::create("RAM_seq_item_obj");
                start_item(RAM_seq_item_obj);
                    if(prev_cmd == 2'b10) begin
                    assert(RAM_seq_item_obj.randomize() with {din[9:8] inside {2'b10, 2'b11}; rx_valid == 1;});
                    end
                    else if (prev_cmd == 2'b11) begin
                    assert (RAM_seq_item_obj.randomize() with { din[9:8] == 2'b10; rx_valid == 1; });
                    end
                    assert(!RAM_seq_item_obj.randomize()) 
                finish_item(RAM_seq_item_obj);

`uvm_info("READ_SEQ", $sformatf("READ command generated: %b", RAM_seq_item_obj.din[9:8]), UVM_LOW)
                prev_cmd = RAM_seq_item_obj.din[9:8];
            end
        endtask
    endclass
endpackage 