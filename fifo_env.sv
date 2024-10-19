/* File Description : UVM ENVIRONMENT should contain
                        - Builds and connects the agents, and analysis components */

package fifo_env_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_agent_pkg::*;
    import fifo_scoreboard_pkg::*;
    import fifo_coverage_collector_pkg::*;
    import fifo_sequence_item_pkg::*;

    class fifo_env extends uvm_env;
        /* Add the UVM component to the UVM factory */
        `uvm_component_utils(fifo_env)

        /* Create the components inside the environment */
        fifo_agent agt;
        fifo_scoreboard sb;
        fifo_coverage cov;
        
        /* Create the required analysis ports */
        uvm_analysis_port #(fifo_sequence_item) agt_ap;

        /* Environment Constructor */
        function new(string name = "fifo_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        /* Build the environment function */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            /* Build the components inside the environment */
            agt = fifo_agent::type_id::create("agt",this);
            sb  = fifo_scoreboard::type_id::create("sb",this);
            cov = fifo_coverage::type_id::create("cov",this);
            
            /* Build the connection between components */
            agt_ap = new("agt_ap",this);
        endfunction
        
        /* Connect the components of the environment */
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);
            agt.agt_ap.connect(cov.cov_export);
        endfunction
        
    endclass

endpackage