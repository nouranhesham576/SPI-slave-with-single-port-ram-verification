package RAM_seq_item_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;

class RAM_seq_item_c extends uvm_sequence_item;
`uvm_object_utils(RAM_seq_item_c)

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
rand logic rst_n,rx_valid;
rand logic [9:0] din;
logic tx_valid;
logic [7:0] dout;
logic tx_valid_golden;
logic [7:0] dout_golden;

function new(string name = "RAM_seq_item_c");
        super.new(name);
endfunction

constraint rst_n_constraint {rst_n dist{1:=95 , 0:=5};}
constraint rx_valid_constraint {rx_valid dist{1:=95, 0:=5};}
     
 
function string convert2string();
    return $sformatf("%s rst_n=0b%0b, rx_valid=0b%0b, din=0b%0b, tx_valid=0b%0b, dout=0b%0b,
    tx_valid_golden=0b%0b, dout_golden=0b%0b",
    super.convert2string(), rst_n, rx_valid, din, tx_valid, dout,
                     tx_valid_golden, dout_golden);
endfunction

function string convert2string_stimulus();
    return $sformatf("%s rst_n= 0b%0b, rx_valid=0b%b, din= 0b%b"
    ,super.convert2string(),rst_n, rx_valid,din);     
endfunction
endclass
endpackage