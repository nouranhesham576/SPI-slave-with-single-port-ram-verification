package RAM_rd_wr_seq_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_seq_item_pkg::*;

class RAM_rd_wr_seq_c extends uvm_sequence #(RAM_seq_item_c);
`uvm_object_utils(RAM_rd_wr_seq_c)
RAM_seq_item_c RAM_seq_item_obj;

function new(string name = "RAM_rd_wr_seq_c");
            super.new(name);
endfunction

task body();
    bit [1:0] prev_cmd;
        repeat(100) begin
                RAM_seq_item_obj = RAM_seq_item_c::type_id::create("RAM_seq_item_obj");
                if(prev_cmd==2'b00) begin
                    assert(RAM_seq_item_obj.randomize() with {din[9:8] inside {2'b00,2'b01}; rx_valid==1;});
                end
                else if(prev_cmd==2'b01) begin
                    assert(RAM_seq_item_obj.randomize() with{ din[9:8] dist {2'b00:= 40, 2'b10:=60}; rx_valid==1;});
                end
                else if(prev_cmd==2'b10) begin
                    assert(RAM_seq_item_obj.randomize() with {din[9:8] inside {2'b11,2'b01}; rx_valid==1;});
                end
                else if(prev_cmd==2'b11) begin
                    assert(RAM_seq_item_obj.randomize() with{ din[9:8] dist {2'b00:= 60, 2'b10:=40}; rx_valid==1;});
                end
                else begin //default
                assert(RAM_seq_item_obj.randomize() with {din[9:8] == 2'b00; rx_valid == 1;});

                start_item(RAM_seq_item_obj);
                finish_item(RAM_seq_item_obj);

                assert(!RAM_seq_item_obj.randomize()) ;
`uvm_info("WRITE_READ_SEQ", $sformatf("CMD=%b (prev=%b) DATA/ADDR=%h", RAM_seq_item_obj.din[9:8], prev_cmd, RAM_seq_item_obj.din[7:0]), UVM_LOW)
                prev_cmd = RAM_seq_item_obj.din[9:8];
            end
            end
        endtask
    endclass
endpackage