/* File Description: UVM SCOREBOARD should contain::
                        - Receives sequence items from the monitor 
                        - Runs the inputs to reference model
                        - Compare DUT output with expected output */

package fifo_scoreboard_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_sequence_item_pkg::*;

    class fifo_scoreboard extends uvm_scoreboard;
        /* Add the UVM component to the UVM factory */
        `uvm_component_utils(fifo_scoreboard)

        uvm_analysis_export #(fifo_sequence_item) sb_export;
        uvm_tlm_analysis_fifo #(fifo_sequence_item) sb_fifo;
        fifo_sequence_item seq_item_sb;

        /* reference outputs signals */
        bit[FIFO_WIDTH-1:0] GM_model[$];
        logic [FIFO_WIDTH-1:0] data_out_GM;
        logic wr_ack_GM, overflow_GM, full_GM, empty_GM, almostfull_GM, almostempty_GM, underflow_GM;

        int error_count = 0;
        int correct_count = 0;
        int count_sb = 0;
        /* -------------------------------- */
        
        /* SCOREBOARD constructor */
        function new(string name = "fifo_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        
        /* Build the scoreboard connections */
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        /* Connect the scoreboard with others */
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        /* Run the checkers in the scoreboard */
        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                /* get sequence item */
                sb_fifo.get(seq_item_sb);
                /* run the reference model */
                reference_model(seq_item_sb);
                
                if (seq_item_sb.data_out != data_out_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.wr_ack != wr_ack_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.overflow != overflow_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.underflow != underflow_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.full != full_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.empty != empty_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.almostfull != almostfull_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end else if (seq_item_sb.almostempty != almostempty_GM) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transaction received by the DUT: %s",
                    seq_item_sb.convert2string()));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Correct output: %s", seq_item_sb.convert2string()), UVM_LOW);
                    correct_count++;
                end
            end
        endtask

        /* Function Description: 
                Reference_model behaves as the required of the Design 
                to check its functionality */
        task reference_model(input fifo_sequence_item fifo_seq_ref);
            fork
                /* First Thread: Write Operation Logic */
                begin  

                    if (!fifo_seq_ref.rst_n) begin
                        wr_ack_GM = 0;
                        overflow_GM = 0;
                        count_sb = 0;
                        GM_model.delete();	
                    end
                    else if (fifo_seq_ref.wr_en && count_sb < FIFO_DEPTH) begin  
                            GM_model.push_back(fifo_seq_ref.data_in) ;
                            wr_ack_GM = 1;
                            overflow_GM = 0; 
                        end
                        else begin 
                            wr_ack_GM = 0; 
                            if ((count_sb == FIFO_DEPTH) && fifo_seq_ref.wr_en)
                                overflow_GM = 1;
                            else
                                overflow_GM = 0;
                        end

                end  

                /* Second Thread: Read Operation Logic */
                begin   

                    if(!fifo_seq_ref.rst_n) begin
                        underflow_GM = 0;
                    end
                    else if ( fifo_seq_ref.rd_en && count_sb != 0 ) begin   
                            data_out_GM = GM_model.pop_front();
                            underflow_GM = 0;  
                        end
                        else begin
                            if((count_sb == 0)&& fifo_seq_ref.rd_en)
                                underflow_GM = 1 ;
                            else
                                underflow_GM = 0 ;
                        end                

                end  

                /* Update the count according to the other flags */     
                begin
                    if(!fifo_seq_ref.rst_n) begin
                        count_sb = 0;
                    end
                    else if	( ({fifo_seq_ref.wr_en, fifo_seq_ref.rd_en} == 2'b10) && count_sb != FIFO_DEPTH) 
                        count_sb = count_sb + 1;
                    else if ( ({fifo_seq_ref.wr_en, fifo_seq_ref.rd_en} == 2'b01) && count_sb != 0)
                        count_sb = count_sb - 1;
                    else if ( ({fifo_seq_ref.wr_en, fifo_seq_ref.rd_en} == 2'b11) && count_sb == FIFO_DEPTH)
                        count_sb = count_sb - 1;
                    else if ( ({fifo_seq_ref.wr_en, fifo_seq_ref.rd_en} == 2'b11) && count_sb == 0)
                        count_sb = count_sb + 1;
                    
                end

            join /* End of Fork Join */


            /* Update the flags */
            full_GM        = (count_sb == FIFO_DEPTH)? 1 : 0;     
            empty_GM       = (count_sb == 0)? 1 : 0;
            almostfull_GM  = (count_sb == FIFO_DEPTH-1)? 1 : 0;         
            almostempty_GM = (count_sb == 1)? 1 : 0;

        endtask

        /* Report the resulted outputs */
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful counts: %0d", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("Total failed counts: %0d", error_count), UVM_MEDIUM);
        endfunction
        
    endclass
endpackage