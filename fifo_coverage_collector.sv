/* File Description: UVM COVERAGE should contain::
                        - Receives sequence items from the monitor 
                        - Samples the data fields for the functional coverage */

package fifo_coverage_collector_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_sequence_item_pkg::*;
    import shared_pkg::*;

    class fifo_coverage extends uvm_component;
        /* Add the UVM component to the UVM factory */
        `uvm_component_utils(fifo_coverage)
        uvm_analysis_export   #(fifo_sequence_item) cov_export;
        uvm_tlm_analysis_fifo #(fifo_sequence_item) cov_fifo;
        fifo_sequence_item seq_item_cov;

/* -------------------- Transaction Covergroup ------------------- */
        covergroup FIFO_cg;
            WRITE_cp : coverpoint seq_item_cov.wr_en {
                bins wr_en_0 = {0};
                bins wr_en_1 = {1};
            }

            READ_cp : coverpoint seq_item_cov.rd_en {
                bins rd_en_0 = {0};
                bins rd_en_1 = {1};
            }

            WRITE_ACK_cp : coverpoint seq_item_cov.wr_ack {
                bins wr_ack_0 = {0};
                bins wr_ack_1 = {1};
            }

            UNDERFLOW_cp : coverpoint seq_item_cov.underflow {
                bins underflow_0 = {0};
                bins underflow_1 = {1};
            }

            FULL_cp : coverpoint seq_item_cov.full {
                bins full_0 = {0};
                bins full_1 = {1};
            }

            EMPTY_cp : coverpoint seq_item_cov.empty{
                bins empty_0 = {0};
                bins empty_1 = {1};
            }

            ALMOSTFULL_cp : coverpoint seq_item_cov.almostfull{
                bins almostfull_0 = {0};
                bins almostfull_1 = {1};
            }

            ALMOSTEMPTY_cp : coverpoint seq_item_cov.almostempty{
                bins almostempty_0 = {0};
                bins almostempty_1 = {1};
            }

            OVERFLOW_cp : coverpoint seq_item_cov.overflow{
                bins overflow_0 = {0};
                bins overflow_1 = {1};
                option.weight = 0;
            }

            /* CROSS COVERAGE for each WR_EN, RD_EN, each output */
            WRITE_ACK_cross  : cross WRITE_cp,READ_cp,WRITE_ACK_cp;
            UNDERFLOW_cross  : cross WRITE_cp,READ_cp,UNDERFLOW_cp;
            FULL_cross       : cross WRITE_cp,READ_cp,FULL_cp;
            EMPTY_cross      : cross WRITE_cp,READ_cp,EMPTY_cp;
            ALMOSTFULL_cross : cross WRITE_cp,READ_cp,ALMOSTFULL_cp;
            ALMOSTEMPTY_cross: cross WRITE_cp,READ_cp,ALMOSTEMPTY_cp;
            OVERFLOW_CROSS   : cross WRITE_cp,READ_cp,OVERFLOW_cp;
        endgroup

        function new(string name = "fifo_coverage", uvm_component parent = null);
            super.new(name, parent);
            FIFO_cg = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                FIFO_cg.sample();
            end
        endtask
    endclass
endpackage