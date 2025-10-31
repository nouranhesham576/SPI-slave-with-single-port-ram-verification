package SPI_Wrapper_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_Wrapper_config extends uvm_object;
`uvm_object_utils(SPI_Wrapper_config)
    
virtual SPI_Wrapper_interface wrapper_vif;
uvm_active_passive_enum is_active;
    
function new(string name = "SPI_Wrapper_config");
        super.new(name);
endfunction
endclass
endpackage