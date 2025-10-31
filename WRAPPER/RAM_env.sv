package RAM_env;
`include "uvm_macros.svh"
import uvm_pkg::*;
import RAM_Scoreboard_pkg::*;
import RAM_coverage_pkg::*;
import RAM_agent_pkg::*;

class RAM_env extends uvm_env;
`uvm_component_utils(RAM_env)

RAM_coverage_c RAM_cov;
RAM_agent RAM_agt;
RAM_Scoreboard RAM_sb;

function new(string name = "RAM_env", uvm_component parent = null);
            super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
            RAM_cov = RAM_coverage_c::type_id::create("RAM_cov",this);
            RAM_agt =  RAM_agent::type_id::create("RAM_agt",this);
            RAM_sb = RAM_Scoreboard::type_id::create("RAM_sb",this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
            RAM_agt.agent_ap.connect(RAM_sb.sb_export);
            RAM_agt.agent_ap.connect(RAM_cov.cov_export);
endfunction
    endclass
endpackage