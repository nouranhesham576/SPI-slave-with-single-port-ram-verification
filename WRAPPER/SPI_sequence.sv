package SPI_sequence_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import SPI_seq_item_pkg::*;

class SPI_reset_sequence extends uvm_sequence #(SPI_seq_item);
`uvm_object_utils(SPI_reset_sequence);  
SPI_seq_item seq_item ;

function new (string name = "SPI_reset_sequence");
    super.new(name);
endfunction

task body();
seq_item =SPI_seq_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n=0;
//inputs
seq_item.MOSI =0;
seq_item.SS_n =0;
seq_item.tx_valid=0;
seq_item.tx_data=0;
//outputs from DUT
seq_item.rx_valid=0;
seq_item.rx_data=0;
seq_item.MISO=0;
//outputs from Golden model
seq_item.rx_data_golden=0;
seq_item.rx_valid_golden=0;
seq_item.MISO_golden=0;
finish_item(seq_item);
endtask
endclass

class SPI_main_sequence extends uvm_sequence #(SPI_seq_item);
`uvm_object_utils(SPI_main_sequence);  
SPI_seq_item seq_item ;

function new (string name = "SPI_main_sequence");
    super.new(name);
endfunction

task body();
repeat(5000) begin
    seq_item =SPI_seq_item::type_id::create("seq_item"); 
    start_item(seq_item);
    assert(seq_item.randomize());
    finish_item(seq_item);
end
endtask

endclass

endpackage

