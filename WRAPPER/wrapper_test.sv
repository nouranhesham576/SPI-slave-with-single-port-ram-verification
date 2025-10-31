package SPI_Wrapper_test_pkg;
  import uvm_pkg::*;
  import SPI_Wrapper_env_pkg::*;
  import SPI_Wrapper_config_pkg::*;
  import SPI_Wrapper_sequence_pkg::*;
  import SPI_env_pkg::*;
  import SPI_config_pkg::*;
  import RAM_env::*;
  import RAM_config_pkg::*;

  `include "uvm_macros.svh"

  class SPI_Wrapper_test extends uvm_test;
    `uvm_component_utils(SPI_Wrapper_test)

    SPI_Wrapper_env               wrapper_env;        // Active wrapper environment 
    SPI_env                       spi_environment;    // Passive SPI environment  
    RAM_env                       ram_environment;    // Passive RAM environment  

    SPI_Wrapper_config            wrapper_config_obj_test;
    SPI_config                    spi_config_obj_test;
    RAM_config                    ram_config_obj_test;

    virtual SPI_Wrapper_interface wrapper_vif;
    virtual SPI_interface         spi_test_vif;
    virtual RAM_interface         ram_test_vif;

    wrapper_reset_sequence        reset_seq;
    wrapper_write_only_sequence   write_seq;
    wrapper_read_only_sequence    read_seq;
    wrapper_write_read_sequence   write_read_seq;

    function new(string name = "SPI_Wrapper_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create all three environments
      wrapper_env = SPI_Wrapper_env::type_id::create("wrapper_env", this);
      spi_environment = SPI_env::type_id::create("spi_environment", this);
      ram_environment = RAM_env::type_id::create("ram_environment", this);

      // Create config objects
      wrapper_config_obj_test = SPI_Wrapper_config::type_id::create("wrapper_config_obj_test");
      spi_config_obj_test = SPI_config::type_id::create("spi_config_obj_test");
      ram_config_obj_test = RAM_config::type_id::create("ram_config_obj_test");

      // Create sequences
      reset_seq = wrapper_reset_sequence::type_id::create("reset_seq");
      write_seq = wrapper_write_only_sequence::type_id::create("write_seq");
      read_seq = wrapper_read_only_sequence::type_id::create("read_seq");
      write_read_seq = wrapper_write_read_sequence::type_id::create("write_read_seq");

      // Configure Wrapper (ACTIVE)
      if (!uvm_config_db#(virtual SPI_Wrapper_interface)::get(this, "", "Config_key", wrapper_vif))
        `uvm_fatal("build_phase", "Wrapper interface not found in config_db")
      wrapper_config_obj_test.wrapper_vif = wrapper_vif;
      uvm_config_db#(SPI_Wrapper_config)::set(this, "*", "Config_key", wrapper_config_obj_test);
      wrapper_config_obj_test.is_active = UVM_ACTIVE;

      // Configure SPI (PASSIVE)
      if (!uvm_config_db#(virtual SPI_interface)::get(this, "", "Config_key", spi_test_vif))
        `uvm_fatal("build_phase", "SPI interface not found")
      spi_config_obj_test.SPI_vif = spi_test_vif;
      uvm_config_db#(SPI_config)::set(this, "*", "Config_key", spi_config_obj_test);
      spi_config_obj_test.is_active = UVM_PASSIVE;

      // Configure RAM (PASSIVE)
      if (!uvm_config_db#(virtual RAM_interface)::get(this, "", "Config_key", ram_test_vif))
        `uvm_fatal("build_phase", "RAM interface not found")
      ram_config_obj_test.RAM_if = ram_test_vif;
      uvm_config_db#(RAM_config)::set(this, "*", "Config_key", ram_config_obj_test);
      ram_config_obj_test.is_active = UVM_PASSIVE;

    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      `uvm_info("WRAPPER_TEST", "Starting SPI Wrapper Test", UVM_LOW)

      reset_seq.start(wrapper_env.wrapper_agt.sqr);
      write_seq.start(wrapper_env.wrapper_agt.sqr);
      read_seq.start(wrapper_env.wrapper_agt.sqr);
      write_read_seq.start(wrapper_env.wrapper_agt.sqr);

      `uvm_info("WRAPPER_TEST", "Test Completed", UVM_LOW)
      #100;
      phase.drop_objection(this);
    endtask
  endclass
endpackage
