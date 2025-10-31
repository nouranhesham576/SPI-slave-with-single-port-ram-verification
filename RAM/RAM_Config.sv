package RAM_config_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
    
class RAM_config extends uvm_object;
`uvm_object_utils(RAM_config)
uvm_active_passive_enum is_active;
virtual RAM_interface RAM_if;

function new(string name = "RAM_config");
                super.new(name);
endfunction
    endclass
endpackage