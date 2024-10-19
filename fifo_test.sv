/* File Description : UVM Test file should  contain ::
                        - Builds the UVM environment 
                        - Retrieve the virtual interface from Config database
                        - Sets the config object to config db
                        - Starts the sequence to the sequencer
                        - Factory overrides for minimal code modifications */

package fifo_test_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_config_pkg::*;
    import fifo_env_pkg::*;
    import fifo_sequence_pkg::*;

    class fifo_test extends uvm_test;
        /* Add the UVM component to the UVM factory */
        `uvm_component_utils(fifo_test)

        fifo_env env;
        fifo_config_obj fifo_config_obj_test;

        fifo_reset_sequence fifo_reset_seq;
        fifo_writeOnly_sequence fifo_writeOnly_seq;
        fifo_readOnly_sequence fifo_readOnly_seq;
        fifo_readWrite_sequence fifo_readWrite_seq;

        /* Declare a virtual interface and handle of the environment */
        virtual fifo_interface fifo_vif;
        
        /* TEST constructor function */
        function new(string name = "fifo_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        /* Build Phase function */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            /* Build the environment component */
            env = fifo_env::type_id::create("env",this);

            /* Build the configuration object */
            fifo_config_obj_test = fifo_config_obj::type_id::create("fifo_config_obj_test",this);

            /* Build the different test sequences */
            fifo_reset_seq       = fifo_reset_sequence::type_id::create("fifo_reset_sequence",this);
            fifo_writeOnly_seq   = fifo_writeOnly_sequence::type_id::create("fifo_writeOnly_sequence",this);
            fifo_readOnly_seq    = fifo_readOnly_sequence::type_id::create("fifo_readOnly_sequence",this);
            fifo_readWrite_seq   = fifo_readWrite_sequence::type_id::create("fifo_readWrite_sequence",this);

            /* Retrieve the virtual interface from the configuration database 
               (uvm_config_db) and pass the value of the virtual interface to 
                fifo_test_vif */
            if(!uvm_config_db #(virtual fifo_interface)::get(this,"" ,"FIFO_VIF",fifo_config_obj_test.fifo_config_vif))
                `uvm_fatal("build_phase","TEST- ERROR in the virtual interface in fifo_config_vif")

            /* Set the virtual interface fifo_test_vif in the configuration database to all 
               the components under the test class so that any component can retrieve 
               it. */
            uvm_config_db #(fifo_config_obj)::set(this,"*","FIFO_VIF_CONFIG",fifo_config_obj_test);
        endfunction

        task  run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            /* RESET sequence */
            `uvm_info("run_phase", "RESET asserted", UVM_LOW)
            fifo_reset_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "RESET deasserted", UVM_LOW)

            /* Write Only sequence */
            `uvm_info("run_phase", "WR Only sequence started", UVM_LOW)
            fifo_writeOnly_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "WR Only sequence ended  ", UVM_LOW)

            /* Read Only sequence */
            `uvm_info("run_phase", "RD Only sequence started", UVM_LOW)
            fifo_readOnly_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "RD Only sequence ended  ", UVM_LOW)

            /* Read Write sequence */
            `uvm_info("run_phase", "WR RD sequence started", UVM_LOW)
            fifo_readWrite_seq.start(env.agt.agt_sqr);
            `uvm_info("run_phase", "WR RD sequence ended  ", UVM_LOW)

            phase.drop_objection(this);
        endtask

    endclass
    
endpackage