package SPI_env_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import SPI_agent_pkg::*;
import SPI_coverage_pkg::*;
import SPI_scoreboard_pkg::*;

class SPI_env extends uvm_env;
`uvm_component_utils(SPI_env);
SPI_agent agt;
SPI_scoreboard sb;
SPI_coverage cov;

function new(string name = "SPI_env" , uvm_component parent = null);
 super.new(name, parent);
endfunction 

function void build_phase(uvm_phase phase);
super.build_phase(phase);
agt = SPI_agent::type_id::create("agt",this);
sb = SPI_scoreboard::type_id::create("sb",this);
cov = SPI_coverage::type_id::create("cov",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
agt.agent_analport.connect(sb.sb_export);
agt.agent_analport.connect(cov.cov_export);
endfunction

endclass
endpackage