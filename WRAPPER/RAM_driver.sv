package RAM_driver_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_seq_item_pkg::*;
import RAM_config_pkg::*;

class RAM_driver_c extends uvm_driver #(RAM_seq_item_c);
`uvm_component_utils(RAM_driver_c)
virtual RAM_interface RAM_if;
RAM_seq_item_c RAM_seq_item_obj;

function new (string name = "RAM_driver_c", uvm_component parent = null);
            super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
        if (RAM_if == null) begin
                `uvm_info("DRIVER", "RAM_if is null in driver; waiting for assignment", UVM_LOW)
            end
        wait (RAM_if != null);

    forever begin
            RAM_seq_item_obj = RAM_seq_item_c::type_id::create("RAM_seq_item_obj");
            seq_item_port.get_next_item(RAM_seq_item_obj);
            @(posedge RAM_if.clk);
            // Drive DUT signals only after ensuring RAM_if is valid
            RAM_if.rst_n    = RAM_seq_item_obj.rst_n;
            RAM_if.rx_valid = RAM_seq_item_obj.rx_valid;
            RAM_if.din      = RAM_seq_item_obj.din;

            seq_item_port.item_done();
`uvm_info("Run phase", RAM_seq_item_obj.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage
