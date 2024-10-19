/* File Description : This file should has the assertions using 
                      SystemVerilog and the assertion coverage details */
                      
module fifo_SVA #(parameter FIFO_WIDTH = 16, FIFO_DEPTH = 8)
    (
        input logic clk, 
        input logic rst_n, 
        input logic [FIFO_WIDTH-1:0] data_in, 
        input logic wr_en, 
        input logic rd_en, 
        input logic [FIFO_WIDTH-1:0] data_out,
        input logic wr_ack, 
        input logic overflow, 
        input logic underflow, 
        input logic full, 
        input logic empty, 
        input logic almostfull, 
        input logic almostempty,
        input logic [$clog2(FIFO_DEPTH):0] count
    );

  /* ------------------------- Overflow ---------------------------- */
    property Overflow_Condition;
        @(posedge clk) disable iff(!rst_n) (((full) && (wr_en)) |-> ##1 (overflow == 1));
    endproperty

    Overflow_Condition_label: assert property(Overflow_Condition) 
        else $error("full = %0d, wr_en = %0d, overflow = %0d", full, wr_en, overflow);

    cover property(Overflow_Condition);

    /* ------------------------- Underflow ---------------------------- */
    property Underflow_Condition;
        @(posedge clk) disable iff(!rst_n) (((empty) && (rd_en)) |-> ##1 (underflow == 1));
    endproperty

    Underflow_Condition_label: assert property(Underflow_Condition) 
        else $error("empty = %0d, rd_en = %0d, underflow = %0d", empty, rd_en, underflow);

    cover property(Underflow_Condition);

    /* --------------------------- Full ------------------------------- */
    property Full_Condition;
        @(posedge clk) disable iff(!rst_n) (((count == FIFO_DEPTH)) |-> (full == 1));
    endproperty

    Full_Condition_label: assert property(Full_Condition) 
        else $error("count = %0d, full = %0d", count, full);

    cover property(Full_Condition);

    /* ------------------------- Almost Full --------------------------- */
    property AlmostFull_Condition;
        @(posedge clk) disable iff(!rst_n) (((count == FIFO_DEPTH-1)) |-> (almostfull == 1));
    endproperty

    AlmostFull_Condition_label: assert property(AlmostFull_Condition) 
        else $error("count = %0d, almostfull = %0d", count, almostfull);

    cover property(AlmostFull_Condition);

    /* -------------------------- Empty ------------------------------- */
    property Empty_Condition;
        @(posedge clk) disable iff(!rst_n) (((count == 0)) |-> (empty == 1));
    endproperty

    Empty_Condition_label: assert property(Empty_Condition) 
        else $error("count = %0d, empty = %0d", count, empty);

    cover property(Empty_Condition);

    /* ----------------------- AlmostEmpty ---------------------------- */
    property AlmostEmpty_Condition;
        @(posedge clk) disable iff(!rst_n) (((count == 1)) |-> (almostempty == 1));
    endproperty

    AlmostEmpty_Condition_label: assert property(AlmostEmpty_Condition) 
        else $error("count = %0d, almostempty = %0d", count, almostempty);

    cover property(AlmostEmpty_Condition);

    /* ------------------------ Wr_ack flag --------------------------- */
    property WR_ack_Condition;
        @(posedge clk) disable iff(!rst_n) (((wr_en && count < FIFO_DEPTH)) |-> ##1 (wr_ack == 1));
    endproperty

    WR_ack_Condition_label: assert property(WR_ack_Condition) 
        else $error("count = %0d, wr_en = %0d, wr_ack = %0d", count, wr_en, wr_ack);

    cover property(WR_ack_Condition);


endmodule
