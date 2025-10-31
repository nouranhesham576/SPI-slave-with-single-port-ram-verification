package SPI_test_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import SPI_env_pkg::*;
import SPI_config_pkg::*;
import  SPI_sequence_pkg::*;

class SPI_test extends uvm_test;
`uvm_component_utils(SPI_test)
SPI_env env;
SPI_config SPI_config_obj;
SPI_main_sequence main_seq;
SPI_reset_sequence reset_seq;
virtual SPI_interface SPI_vif ; 

function new(string name = "SPI_test" , uvm_component parent = null);
 super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env= SPI_env::type_id::create("env",this);
SPI_config_obj = SPI_config::type_id::create("SPI_config_obj");
main_seq = SPI_main_sequence::type_id::create("main_seq");
reset_seq = SPI_reset_sequence::type_id::create("reset_seq");
if(!uvm_config_db#(virtual SPI_interface):: get(this,"","Config_key", SPI_config_obj.SPI_vif ))begin
`uvm_fatal("build_phase","unable to get virtual interface")
end
uvm_config_db#(SPI_config)::set(this, "*", "Config_key", SPI_config_obj);
SPI_config_obj.is_active = UVM_ACTIVE;
endfunction

task run_phase(uvm_phase phase);
super.run_phase (phase);
phase.raise_objection(this);

`uvm_info("run_phase","reset asserted.",UVM_LOW)
reset_seq.start(env.agt.sqr);
`uvm_info("run_phase","reset deasserted.",UVM_LOW)

`uvm_info("run_phase","stimulus generation started",UVM_LOW)
main_seq.start(env.agt.sqr);
`uvm_info("run_phase","stimulus generation ended",UVM_LOW)
#5;
phase.drop_objection(this);
endtask

endclass
endpackage