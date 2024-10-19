/* File Description : UVM AGENT should contain::
                        - Builds and Connects the sequencer,driver and monitor
                        - Sets the configuration for the agent connecting the 
                          interfaces */

package fifo_agent_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_sequencer_pkg::*;
    import fifo_sequence_item_pkg::*;
    import fifo_driver_pkg::*;
    import fifo_monitor_pkg::*;
    import fifo_config_pkg::*;

    class fifo_agent extends uvm_agent;
        /* Add the UVM object to the UVM factory */
        `uvm_component_utils(fifo_agent)

        /* Create the components and objects in agent */
        fifo_sequencer agt_sqr;
        fifo_driver agt_drv;
        fifo_monitor agt_mon;
        fifo_config_obj fifo_config_obj_agt;

        uvm_analysis_port #(fifo_sequence_item) agt_ap;

        /* Agent Constructor */
        function new(string name = "fifo_agent",uvm_component parent= null);
            super.new(name, parent);
        endfunction

        /* Build the components and objects */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            /* Get the config object from the database */
            if(! uvm_config_db #(fifo_config_obj)::get(this,"","FIFO_VIF_CONFIG",fifo_config_obj_agt))begin
                `uvm_fatal("FIFO_AGENT","FIFO_VIF_CONFIG not found in uvm")
            end
            /* Create the sequence,drver and monitor */
            agt_sqr = fifo_sequencer::type_id::create("agt_sqr",this);
            agt_drv = fifo_driver::type_id::create("agt_drv",this);
            agt_mon = fifo_monitor::type_id::create("agt_mon",this);
            /* Create the connection */
            agt_ap = new("agt_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt_drv.drv_vif = fifo_config_obj_agt.fifo_config_vif;
            agt_mon.mon_vif = fifo_config_obj_agt.fifo_config_vif;
            /* Connect the driver to the sequencer */
            agt_drv.seq_item_port.connect(agt_sqr.seq_item_export);
            /* Connect the monitor analysis port with agent */
            agt_mon.mon_ap.connect(agt_ap);
        endfunction
    endclass
endpackage