package SPI_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::*;

class SPI_scoreboard extends uvm_scoreboard;
`uvm_component_utils(SPI_scoreboard)
uvm_analysis_export #(SPI_seq_item) sb_export;
uvm_tlm_analysis_fifo #(SPI_seq_item) sb_fifo;
SPI_seq_item seq_item_sb;

int error_count = 0;
int correct_count = 0;

function new(string name = "SPI_scoreboard", uvm_component parent = null);
    super.new(name, parent);
endfunction
    
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo", this);
endfunction
    
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        sb_fifo.get(seq_item_sb);
        check_data(seq_item_sb);
    end
endtask

task check_data(SPI_seq_item item);
if (item.rx_data !== item.rx_data_golden) begin
error_count++;
    `uvm_error("SCOREBOARD", $sformatf("rx_data Mismatch - Expected: 0x%0h, Got: 0x%0h | %s", 
                    item.rx_data_golden, item.rx_data, item.convert2string())) 
    end
else correct_count++;
    
if (item.rx_valid !== item.rx_valid_golden) begin
error_count++;
    `uvm_error("SCOREBOARD", $sformatf("rx_valid Mismatch - Expected: %0b, Got: %0b | %s", 
                    item.rx_valid_golden, item.rx_valid, item.convert2string()))
    end
else correct_count++;

if (item.MISO !== item.MISO_golden) begin
error_count++;
    `uvm_error("SCOREBOARD", $sformatf("MISO Mismatch - Expected: %0b, Got: %0b | %s", 
                    item.MISO_golden, item.MISO, item.convert2string()))
    end
else correct_count++;
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