package RAM_wr_seq_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_seq_item_pkg::*;

class RAM_wr_seq_c extends uvm_sequence #(RAM_seq_item_c);
`uvm_object_utils(RAM_wr_seq_c)
RAM_seq_item_c RAM_seq_item_obj;

function new(string name = "RAM_wr_seq_c");
            super.new(name);
endfunction

task body();
    bit [1:0] prev_cmd = 2'b00;
     repeat(10000) begin
        RAM_seq_item_obj = RAM_seq_item_c::type_id::create("RAM_seq_item_obj");
            start_item(RAM_seq_item_obj);
                if(prev_cmd==2'b00) begin
                    assert(RAM_seq_item_obj.randomize() with {din[9:8] inside {2'b00, 2'b01}; rx_valid == 1;});
                    if(!RAM_seq_item_obj.randomize()) begin
                        $display("ERROR: Randomization of write only failed at iteration %0d", $time);
                        $display("Current values: %s", RAM_seq_item_obj.convert2string_stimulus());
                    end
                end
            finish_item(RAM_seq_item_obj);
        prev_cmd = RAM_seq_item_obj.din[9:8];

`uvm_info("WRITE_SEQ", $sformatf("WRITE command generated: %b", RAM_seq_item_obj.din[9:8]),UVM_LOW)
            end
        endtask
    endclass
endpackage 