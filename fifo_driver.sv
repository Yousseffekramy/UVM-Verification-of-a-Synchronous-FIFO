/* File Description: UVM DRIVER should contain::
                        - Pulls the next sequence item from sequencer
                        - Drives the sequence item in the run_phase task using
                          virtual interface */

package fifo_driver_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    // import fifo_config_pkg::*;
    import fifo_sequencer_pkg::*;
    import fifo_sequence_item_pkg::*;

    class fifo_driver extends uvm_driver #(fifo_sequence_item);
        /* Add the UVM component to the UVM factory */
        `uvm_component_utils(fifo_driver)

        virtual fifo_interface drv_vif;
        // fifo_config_obj fifo_config_obj_driver;
        fifo_sequence_item stim_seq_item;

        function new(string name = "fifo_driver",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void  build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction
        
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            /* Connect the randomized sequence item to the virtual if */
            forever begin
                stim_seq_item = fifo_sequence_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);

                /* Connect the driver with the stimulus sequence item */
                drv_vif.rst_n       = stim_seq_item.rst_n    ;
                drv_vif.data_in     = stim_seq_item.data_in  ;
                drv_vif.wr_en       = stim_seq_item.wr_en    ;
                drv_vif.rd_en       = stim_seq_item.rd_en    ;

                @(negedge drv_vif.clk); 

                seq_item_port.item_done();

                `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH);
            end
        endtask //run_phase
    endclass
    
endpackage