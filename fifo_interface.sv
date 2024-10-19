import shared_pkg::*;

interface fifo_interface(clk);
    /* The input of interface is the CLK only */
    input bit clk;

    /* ------------------------- Parameters --------------------- */

    /* FIFO_WIDTH: DATA in/out and memory word width (default: 16)*/
    parameter FIFO_WIDTH = 16;

    /* FIFO_DEPTH: FIFO depth (default: 8) */
    parameter FIFO_DEPTH = 8;

    /* --------------------------- Inputs ----------------------- */

    /* Write Data: The input data bus used when writing the FIFO. */
    logic [FIFO_WIDTH-1:0] data_in; 

    /* Active low asynchronous reset */
    logic rst_n;

    /* Write Enable: If the FIFO is not full, asserting this signal 
    causes data (on data_in) to be written into the FIFO */
    logic wr_en;

    /* Read Enable: If the FIFO is not empty, asserting this signal 
    causes data (on data_out) to be read from the FIFO */
    logic rd_en;


    /* --------------------------- Outputs ---------------------- */
    
    /* Read Data: The sequential output data bus used when reading 
    from the FIFO. */
    logic [FIFO_WIDTH-1:0] data_out;

    /* Write Acknowledge: This sequential output signal indicates 
    that a write request (wr_en) has succeeded. */
    logic wr_ack;

    /* Underflow: This sequential output signal Indicates that the 
    read request (rd_en) was rejected because the FIFO is empty. 
    Under flowing the FIFO is not destructive to the FIFO. */
    logic underflow;

    /* Full Flag: When asserted, this combinational output signal 
    indicates that the FIFO is full. Write requests are ignored 
    when the FIFO is full, initiating a write when the FIFO is full 
    is not destructive to the contents of the FIFO. */
    logic full;
    /* Empty Flag: When asserted, this combinational output signal 
    indicates that the FIFO is empty. Read requests are ignored when 
    the FIFO is empty, initiating a read while empty is not destructive 
    to the FIFO. */
    logic empty;

    /* Almost Full: When asserted, this combinational output signal 
    indicates that only one more write can be performed before the 
    FIFO is full. */
    logic almostfull;

    /* Almost Empty: When asserted, this output combinational signal 
    indicates that only one more read can be performed before the FIFO 
    goes to empty. */
    logic almostempty; 

    /* Overflow: This sequential output signal indicates that a write 
    request (wr_en) was rejected because the FIFO is full. Overflowing 
    the FIFO is not destructive to the contents of the FIFO. */
    logic overflow;

endinterface //FIFO_Interface(clk)