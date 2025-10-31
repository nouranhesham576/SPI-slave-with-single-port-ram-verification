package SPI_coverage_pkg;
 import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;
import SPI_shared_pkg::*;
class SPI_coverage extends uvm_component;
`uvm_component_utils(SPI_coverage)
uvm_analysis_export #(SPI_seq_item) cov_export;
uvm_tlm_analysis_fifo #(SPI_seq_item) cov_fifo;
SPI_seq_item seq_item_cov;

covergroup cov_cg ;

rx_data_cp: coverpoint seq_item_cov.rx_data[9:8]  iff(seq_item_cov.rst_n){
  bins b00 = {2'b00};
  bins b01 = {2'b01};
  bins b10 = {2'b10};
  bins b11 = {2'b11};
  bins trans_00_01 = (2'b00 => 2'b01);//write addreess to write data
  bins trans_10_11 = (2'b10 => 2'b11); //read address to write data
  bins trans_00_00 = (2'b00 => 2'b00); // hold 
  bins trans_01_01 = (2'b01 => 2'b01); // hold 
  bins trans_10_10 = (2'b10 => 2'b10); // hold 
  bins trans_11_11 = (2'b11 => 2'b11); // hold 
 }

 SS_n_cp: coverpoint seq_item_cov.SS_n  iff(seq_item_cov.rst_n){
    bins normal_transaction = (1 => 0[*13] => 1);
    bins extended_transaction = (1 => 0[*23] => 1);
 }

MOSI_cp: coverpoint seq_item_cov.MOSI  {  
    bins write_addr = (0 => 0 => 0);
    bins write_data    = (0 => 0 => 1);
    bins read_addr  = (1 => 1 => 0);
    bins read_data     = (1 => 1 => 1);
}

SSn_MOSI_cross: cross SS_n_cp, MOSI_cp iff(seq_item_cov.rst_n){
     ignore_bins illegal_cross = binsof(SS_n_cp.normal_transaction) && binsof(MOSI_cp.read_data)
                    || binsof(SS_n_cp.extended_transaction) && binsof(MOSI_cp.write_addr)
                    || binsof(SS_n_cp.normal_transaction) && binsof(MOSI_cp.write_addr)
                    || binsof(SS_n_cp.extended_transaction) && binsof(MOSI_cp.read_data)
                    || binsof(SS_n_cp.extended_transaction) && binsof(MOSI_cp.write_data)
                    || binsof(SS_n_cp.extended_transaction) && binsof(MOSI_cp.read_addr);
}
endgroup

function new(string name = "SPI_coverage" , uvm_component parent = null);
    super.new(name, parent);
            seq_item_cov = SPI_seq_item::type_id::create("seq_item_cov");
            cov_cg = new(); 
    endfunction 

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
         cov_export =new("cov_export",this);
         cov_fifo =new("cov_fifo",this);
  endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
      cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
    cov_fifo.get(seq_item_cov);
    cov_cg.sample();
end
endtask

endclass
endpackage