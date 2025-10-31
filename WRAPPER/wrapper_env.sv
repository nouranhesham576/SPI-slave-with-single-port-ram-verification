package SPI_Wrapper_env_pkg;
import uvm_pkg::*;
import SPI_Wrapper_agent_pkg::*;
import SPI_Wrapper_scoreboard_pkg::*;
`include "uvm_macros.svh"

class SPI_Wrapper_env extends uvm_env;
`uvm_component_utils(SPI_Wrapper_env)

SPI_Wrapper_agent wrapper_agt;
SPI_Wrapper_scoreboard sb;

    
function new(string name = "SPI_Wrapper_env", uvm_component parent = null);
        super.new(name, parent);
endfunction
    
function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wrapper_agt = SPI_Wrapper_agent::type_id::create("wrapper_agt", this);
        sb = SPI_Wrapper_scoreboard::type_id::create("sb", this);
endfunction
    
function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        wrapper_agt.agent_analport.connect(sb.sb_export);
endfunction
endclass
endpackage