package RAM_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_env::*;
    import RAM_config_pkg::*;
    import RAM_main_seq_pkg::*;
    import RAM_rst_seq_pkg::*;
    import RAM_agent_pkg::*;
    import RAM_rd_seq_pkg::*;
    import RAM_rd_wr_seq_pkg::*;
    import RAM_wr_seq_pkg::*;
    

    class RAM_test extends uvm_test;
        `uvm_component_utils(RAM_test)
        RAM_env env; 
        RAM_config RAM_cfg;
        RAM_main_seq_c RAM_main_seq;
        RAM_rst_seq_c RAM_rst_seq;
        virtual RAM_interface RAM_if;
        //---------->new
        RAM_rd_seq_c  RAM_rd_seq;
        RAM_rd_wr_seq_c RAM_rd_wr_seq;
        RAM_wr_seq_c  RAM_wr_seq;

        function new(string name = "RAM_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            env=RAM_env::type_id::create("env", this);
            RAM_cfg=RAM_config::type_id::create("RAM_cfg");
            RAM_main_seq=RAM_main_seq_c::type_id::create("RAM_main_seq");
            RAM_rst_seq=RAM_rst_seq_c::type_id::create("RAM_rst_seq");

RAM_rd_seq    = RAM_rd_seq_c::type_id::create("RAM_rd_seq");
RAM_rd_wr_seq = RAM_rd_wr_seq_c::type_id::create("RAM_rd_wr_seq");
RAM_wr_seq    = RAM_wr_seq_c::type_id::create("RAM_wr_seq");

    if(!uvm_config_db #(virtual RAM_interface)::get(this, "", "RAM_if", RAM_cfg.RAM_if))
            `uvm_fatal("build_phase","unable to get config object from the env in test pkg")
            uvm_config_db #(RAM_config)::set(this,"*", "Config_key", RAM_cfg);
            RAM_cfg.is_active=UVM_ACTIVE;
        endfunction 

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase", "welcome", UVM_MEDIUM)
            RAM_rst_seq.start(env.RAM_agt.RAM_seq);
            RAM_main_seq.start(env.RAM_agt.RAM_seq);
            phase.drop_objection(this);

        endtask
    endclass 
endpackage