package SPI_Wrapper_sequence_pkg;
import uvm_pkg::*;
import SPI_Wrapper_seq_item_pkg::*;
`include "uvm_macros.svh"

class wrapper_reset_sequence extends uvm_sequence #(SPI_Wrapper_seq_item);
`uvm_object_utils(wrapper_reset_sequence)
SPI_Wrapper_seq_item seq_item;
    
function new(string name = "wrapper_reset_sequence");
    super.new(name);
endfunction
    
task body();
    seq_item = SPI_Wrapper_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n = 0;
    seq_item.MOSI = 0;
    seq_item.SS_n = 1;
    seq_item.MOSI_data = 0;
    finish_item(seq_item);
endtask
endclass

class wrapper_write_only_sequence extends uvm_sequence #(SPI_Wrapper_seq_item);
    `uvm_object_utils(wrapper_write_only_sequence)
    SPI_Wrapper_seq_item seq_item;
    bit [2:0] last_op = 3'b000;
    
    function new(string name = "wrapper_write_only_sequence");
        super.new(name);
    endfunction
    
    task body();
        repeat(1000) begin
            seq_item = SPI_Wrapper_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            
            if (last_op == 3'b000) begin
                assert(seq_item.randomize() with {
                    rst_n == 1;
                    MOSI_data[10:8] inside {3'b000, 3'b001};
                });
            end
            else begin
                assert(seq_item.randomize() with {
                    rst_n == 1;
                    MOSI_data[10:8] == 3'b000;
                });
            end
            
            finish_item(seq_item);
            last_op = seq_item.MOSI_data[10:8];
        end
    endtask
endclass

class wrapper_read_only_sequence extends uvm_sequence #(SPI_Wrapper_seq_item);
    `uvm_object_utils(wrapper_read_only_sequence)
    SPI_Wrapper_seq_item seq_item;
    bit [2:0] last_op = 3'b110;
    
    function new(string name = "wrapper_read_only_sequence");
        super.new(name);
    endfunction
    
    task body();
        repeat(1000) begin
            seq_item = SPI_Wrapper_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            
            if (last_op == 3'b110) begin
                assert(seq_item.randomize() with {
                    rst_n == 1;
                    MOSI_data[10:8] inside {3'b110, 3'b111};
                });
            end
            else begin
                assert(seq_item.randomize() with {
                    rst_n == 1;
                    MOSI_data[10:8] == 3'b110;
                });
            end
            
            finish_item(seq_item);
            last_op = seq_item.MOSI_data[10:8];
        end
    endtask
endclass

class wrapper_write_read_sequence extends uvm_sequence #(SPI_Wrapper_seq_item);
`uvm_object_utils(wrapper_write_read_sequence)
    SPI_Wrapper_seq_item seq_item;
    bit [2:0] last_op = 3'b000;
    
    function new(string name = "wrapper_write_read_sequence");
        super.new(name);
    endfunction
    
    task body();
        repeat(1000) begin
            seq_item = SPI_Wrapper_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            
            case(last_op)
                3'b000: begin
                    assert(seq_item.randomize() with {
                        rst_n == 1;
                        MOSI_data[10:8] inside {3'b000, 3'b001};
                    });
                end
                3'b001: begin
                    assert(seq_item.randomize() with {
                        rst_n == 1;
                        MOSI_data[10:8] dist {3'b110 := 60, 3'b000 := 40};
                    });
                end
                3'b110: begin
                    assert(seq_item.randomize() with {
                        rst_n == 1;
                        MOSI_data[10:8] inside {3'b110, 3'b111};
                    });
                end
                3'b111: begin
                    assert(seq_item.randomize() with {
                        rst_n == 1;
                        MOSI_data[10:8] dist {3'b000 := 60, 3'b110 := 40};
                    });
                end
                default: begin
                    assert(seq_item.randomize() with {rst_n == 1;});
                end
            endcase
            
            finish_item(seq_item);
            last_op = seq_item.MOSI_data[10:8];
        end
    endtask
endclass

endpackage