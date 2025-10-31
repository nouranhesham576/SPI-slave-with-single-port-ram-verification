package RAM_Scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;

class RAM_Scoreboard extends uvm_scoreboard;
`uvm_component_utils(RAM_Scoreboard)

uvm_analysis_export #(RAM_seq_item_c) sb_export;
uvm_tlm_analysis_fifo #(RAM_seq_item_c) dut_fifo;
uvm_tlm_analysis_fifo #(RAM_seq_item_c) ref_fifo;

RAM_seq_item_c dut_item;

int error_count = 0;
int correct_count = 0;

function new(string name = "RAM_Scoreboard", uvm_component parent = null);
      super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export=new("sb_export",this);
      dut_fifo = new("dut_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect(dut_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
      forever begin
        dut_fifo.get(dut_item);

        if ((dut_item.dout !== dut_item.dout) || (dut_item.tx_valid !== dut_item.tx_valid)) begin
  `uvm_error("SCOREBOARD", $sformatf("Mismatch: DUT(dout=%0h, tx_valid=%0b) | REF(dout=%0h, tx_valid=%0b)",
                                             dut_item.dout, dut_item.tx_valid, dut_item.dout, dut_item.tx_valid))
          error_count++;
        end
        else correct_count++;
      end
    endtask


function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD", "================== SCOREBOARD REPORT ==================", UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Total Checked: %0d", correct_count + error_count), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Passed:        %0d", correct_count), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Failed:        %0d", error_count), UVM_NONE)
    `uvm_info("SCOREBOARD", "========================================================", UVM_NONE)
endfunction

  endclass
endpackage