package RAM_agent_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_config_pkg::*;
import RAM_sequencer_pkg::*;
import RAM_seq_item_pkg::*;
import RAM_driver_pkg::*;
import RAM_monitor::*;
    
class RAM_agent extends uvm_agent;
`uvm_component_utils(RAM_agent)

RAM_config RAM_cfg;
RAM_sequencer_c RAM_seq;
RAM_driver_c RAM_dri;
RAM_monitor RAM_mon;
uvm_analysis_port #(RAM_seq_item_c) agent_ap;

function new(string name = "RAM_agent", uvm_component parent = null);
            super.new(name,parent);
endfunction
        
function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(RAM_config)::get(this, "", "Config_key", RAM_cfg)) begin
                `uvm_fatal("Build phase", "unable to get config obj in agent")
            end

        RAM_mon = RAM_monitor::type_id::create("RAM_mon",this);
        agent_ap=new("agent_ap",this);

        if(RAM_cfg.is_active == UVM_ACTIVE) begin
        RAM_seq = RAM_sequencer_c::type_id::create("RAM_seq",this);
        RAM_dri = RAM_driver_c::type_id::create("RAM_dri",this);
    end
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
          
     RAM_mon.RAM_if=RAM_cfg.RAM_if;
    RAM_mon.mon_ap.connect(agent_ap);

    if(RAM_cfg.is_active == UVM_ACTIVE) begin
        RAM_dri.RAM_if = RAM_cfg.RAM_if;
        RAM_dri.seq_item_port.connect(RAM_seq.seq_item_export);
    end
endfunction
    endclass
endpackage