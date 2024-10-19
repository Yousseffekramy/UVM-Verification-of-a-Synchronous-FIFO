module fifo_dut(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
output reg [FIFO_WIDTH-1:0] data_out;
output reg wr_ack, overflow, underflow;
output full, empty, almostfull, almostempty;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr 			 <= 0;
		overflow         <= 0; /* added */
		wr_ack 	         <= 0;
	end
	else if ( wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack 	 <= 1;
		wr_ptr   <= wr_ptr + 1;
		overflow <= 0; /* added */
	end
	else begin 
		wr_ack <= 0; 
		if (full && wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr    <= 0;
		underflow <= 0; /* added */
	end
	else if (rd_en && count != 0) begin
		data_out  <= mem[rd_ptr];
		rd_ptr    <= rd_ptr + 1;
		underflow <= 0;	/* added */
	end
	else begin
		/* Sequential Raise for underflow */
		if (empty && rd_en) begin
			underflow <= 1;
		end else begin
			underflow <= 0;	
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if (({wr_en, rd_en} == 2'b11) && full)      // priority for write operation
			count <= count - 1;
		else if (({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) &&empty)      // priority for read operation
			count <= count + 1;
	end
end

assign full  = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;

/* assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; Should be sequential */

/* almost full is raised when fifo_if.count = FIFO_DEPTH -1 not -2 */
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 

assign almostempty = (count == 1)? 1 : 0;

endmodule