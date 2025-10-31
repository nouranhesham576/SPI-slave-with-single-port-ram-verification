package SPI_agent_pkg;
import uvm_pkg::*;
import SPI_sequencer_pkg::*;
import SPI_driver_pkg::*;
import SPI_monitor_pkg::*;
import SPI_config_pkg::*;
import SPI_seq_item_pkg::*;
`include "uvm_macros.svh"

class SPI_agent extends uvm_agent;
`uvm_component_utils(SPI_agent)
SPI_sequencer sqr;
SPI_driver driv;
SPI_monitor mon;
SPI_config SPI_cfg;         
uvm_analysis_port #(SPI_seq_item) agent_analport; 

function new(string name = "SPI_agent" , uvm_component parent = null);
 super.new(name, parent);
endfunction 

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(SPI_config):: get(this,"","Config_key",SPI_cfg))begin 
`uvm_fatal("build_phase","unable to get configuration object");
end
mon = SPI_monitor ::type_id::create("mon",this);
agent_analport = new("agent_analport",this);

if(SPI_cfg.is_active == UVM_ACTIVE) begin
    sqr = SPI_sequencer::type_id::create("sqr",this);
    driv = SPI_driver::type_id::create("driv",this);
end
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
mon.SPI_vif = SPI_cfg.SPI_vif;
mon.mon_ap.connect(agent_analport);

if(SPI_cfg.is_active == UVM_ACTIVE) begin
        driv.SPI_vif = SPI_cfg.SPI_vif;
        driv.seq_item_port.connect(sqr.seq_item_export);
    end

endfunction
endclass

endpackage