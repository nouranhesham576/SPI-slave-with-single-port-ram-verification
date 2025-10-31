package RAM_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;

class RAM_coverage_c extends uvm_component;

`uvm_component_utils(RAM_coverage_c)
uvm_analysis_port #(RAM_seq_item_c) cov_export;
uvm_tlm_analysis_fifo #(RAM_seq_item_c) cov_fifo;
RAM_seq_item_c RAM_seq_item_obj;
virtual RAM_interface RAM_if;

covergroup RAM_coverage;
        din_cp: coverpoint RAM_seq_item_obj.din [9:8] {
                bins write_addr = {2'b00};
                bins write_data = {2'b01};
                bins read_addr  = {2'b10};
                bins read_data  = {2'b11};
            }
        transaction_order_cp: coverpoint RAM_seq_item_obj.din[9:8]{
                bins wa_to_wd = (2'b00 => 2'b01);
                bins ra_to_rd = (2'b10 => 2'b11);
                bins wa_wd_ra_rd = (2'b00 => 2'b01 => 2'b10 => 2'b11);
            }
        rx_valid_cp: coverpoint RAM_seq_item_obj.rx_valid {
                bins low = {0};
                bins high = {1};
            }
              
        cross_din_rx: cross din_cp, rx_valid_cp {
                ignore_bins read_opo = binsof(din_cp.read_data)&& binsof(rx_valid_cp.low);
            }

        tx_valid_cp: coverpoint RAM_seq_item_obj.tx_valid {
                bins low = {0};
                bins high = {1};
            }
                
        cross_din_tx: cross din_cp,tx_valid_cp {
                ignore_bins loW_din =binsof(tx_valid_cp.low) && binsof(din_cp.read_data);
                ignore_bins high_wr_addr =binsof(tx_valid_cp.high) && binsof(din_cp.write_addr);
                ignore_bins high_wr_data =binsof(tx_valid_cp.high) && binsof(din_cp.write_data);
            }
        endgroup

function new(string name = "RAM_coverage_c", uvm_component parent = null);
            super.new(name,parent);
            RAM_coverage = new();
endfunction

function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo", this);
            RAM_seq_item_obj = RAM_seq_item_c::type_id::create("RAM_seq_item_obj");
endfunction

function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(RAM_seq_item_obj);
                RAM_coverage.sample();
            end
endtask
    endclass
endpackage