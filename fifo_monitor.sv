/* File Description : UVM MONITOR should contain::
                        - Capture Signal Information from DUT ports
                        - Translate it to sequence items
                        - Send sequence items to analysis components */

package fifo_monitor_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_sequence_item_pkg::*;
    import fifo_driver_pkg::*;
    
    class fifo_monitor extends uvm_monitor;
        /* Add the UVM component to the UVM factory */
        `uvm_component_utils(fifo_monitor)

        virtual fifo_interface mon_vif;
        fifo_sequence_item rsp_seq_item;
        uvm_analysis_port #(fifo_sequence_item) mon_ap;

        /* MONITOR Constructor */
        function new(string name = "fifo_monitor",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = fifo_sequence_item::type_id::create("rsp_seq_item");
                
                @(negedge mon_vif.clk);
                /* Connect inputs */
                rsp_seq_item.rst_n       = mon_vif.rst_n;
                rsp_seq_item.data_in     = mon_vif.data_in;
                rsp_seq_item.wr_en       = mon_vif.wr_en;
                rsp_seq_item.rd_en       = mon_vif.rd_en;

                /* Connect outputs */
                rsp_seq_item.data_out       = mon_vif.data_out;
                rsp_seq_item.wr_ack         = mon_vif.wr_ack;
                rsp_seq_item.underflow      = mon_vif.underflow;
                rsp_seq_item.overflow       = mon_vif.overflow;
                rsp_seq_item.full           = mon_vif.full;
                rsp_seq_item.empty          = mon_vif.empty;
                rsp_seq_item.almostfull     = mon_vif.almostfull;
                rsp_seq_item.almostempty    = mon_vif.almostempty;


                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
            end
        endtask

    endclass
    
endpackage