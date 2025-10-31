package RAM_monitor;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_seq_item_pkg::*;

class RAM_monitor extends uvm_monitor;
`uvm_component_utils(RAM_monitor)

virtual RAM_interface RAM_if;
RAM_seq_item_c RAM_seq_item_obj;
uvm_analysis_port #(RAM_seq_item_c) mon_ap;

function new(string name = "RAM_monitor", uvm_component parent = null);
            super.new(name,parent); 
endfunction

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
            mon_ap = new("mon_ap", this);
endfunction

task run_phase(uvm_phase phase);
        super.run_phase(phase);
            // wait until the virtual interface handle is set by the agent/config
            if (RAM_if == null) begin
                `uvm_info("MON", "RAM_if is null in monitor; waiting for assignment", UVM_LOW)
            end
            wait (RAM_if != null);
        forever begin
                RAM_seq_item_obj = RAM_seq_item_c::type_id::create("RAM_seq_item_obj");
                @(posedge RAM_if.clk);
                RAM_seq_item_obj.rst_n = RAM_if.rst_n;
                RAM_seq_item_obj.rx_valid = RAM_if.rx_valid;
                RAM_seq_item_obj.din = RAM_if.din;

                //DUT outputs
                RAM_seq_item_obj.dout = RAM_if.dout;
                RAM_seq_item_obj.tx_valid = RAM_if.tx_valid;

                //Golden outputs
                RAM_seq_item_obj.dout = RAM_if.dout_golden;
                RAM_seq_item_obj.tx_valid = RAM_if.tx_valid_golden;

                mon_ap.write(RAM_seq_item_obj);
`uvm_info("run phase", RAM_seq_item_obj.convert2string(), UVM_HIGH)
            end
        endtask
    endclass
endpackage