package SPI_Wrapper_agent_pkg;
import uvm_pkg::*;
import SPI_Wrapper_sequencer_pkg::*;
import SPI_Wrapper_driver_pkg::*;
import SPI_Wrapper_monitor_pkg::*;
import SPI_Wrapper_config_pkg::*;
import SPI_Wrapper_seq_item_pkg::*;
`include "uvm_macros.svh"

class SPI_Wrapper_agent extends uvm_agent;
`uvm_component_utils(SPI_Wrapper_agent)
    
SPI_Wrapper_sequencer sqr;
SPI_Wrapper_driver driv;
SPI_Wrapper_monitor mon;
SPI_Wrapper_config wrapper_cfg;
uvm_analysis_port #(SPI_Wrapper_seq_item) agent_analport;
    
function new(string name = "SPI_Wrapper_agent", uvm_component parent = null);
        super.new(name, parent);
endfunction
    
function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(SPI_Wrapper_config)::get(this, "", "Config_key", wrapper_cfg))
                `uvm_fatal("build_phase", "unable to get wrapper config")

        if(wrapper_cfg.is_active==UVM_ACTIVE) begin
                sqr = SPI_Wrapper_sequencer::type_id::create("sqr", this);
                driv = SPI_Wrapper_driver::type_id::create("driv", this);
        end

        mon = SPI_Wrapper_monitor::type_id::create("mon", this);
        agent_analport = new("agent_analport", this);
endfunction
    
function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.wrapper_vif = wrapper_cfg.wrapper_vif;
        mon.mon_ap.connect(agent_analport);
        if (wrapper_cfg.is_active == UVM_ACTIVE) begin
                driv.wrapper_vif = wrapper_cfg.wrapper_vif;
                driv.seq_item_port.connect(sqr.seq_item_export);
        end
endfunction

endclass
endpackage