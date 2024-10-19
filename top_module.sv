/* File Description : Top Module should contain ::
                        - Root of the hierarchy
                        - Instantiates the DUT, interface & assertions
                        - Connects the interface to the DUT
                        - Clock Generation
                        - Pass the interface to configuration database
                        - Run test */ 
                        
/* ---------------- Import UVM packages -------------- */
import uvm_pkg::*;
`include "uvm_macros.svh"

/* -------------- Import Hierarchy packages ---------- */
import fifo_test_pkg::*;

module top();
    bit clk;

    /* --------------- Clock Generation --------------- */
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    /* ------------ Hierarchy Instantiation ----------- */
    /* Instantiate the interface */
    fifo_interface fifo_if(clk);

    /* Instantiate the DUT module */
    fifo_dut DUT (
        .clk(clk), 
        .data_in(fifo_if.data_in), 
        .wr_en(fifo_if.wr_en), 
        .rd_en(fifo_if.rd_en), 
        .rst_n(fifo_if.rst_n), 
        .full(fifo_if.full), 
        .empty(fifo_if.empty), 
        .almostempty(fifo_if.almostempty), 
        .almostfull(fifo_if.almostfull), 
        .wr_ack(fifo_if.wr_ack), 
        .overflow(fifo_if.overflow), 
        .underflow(fifo_if.underflow), 
        .data_out(fifo_if.data_out)
    );
    
    /* Bind the SVA assertions to DUT */
    bind fifo_dut fifo_SVA FIFO_DUT_SVA(
                                        .clk(clk), 
                                        .rst_n(DUT.rst_n), 
                                        .data_in(DUT.data_in), 
                                        .wr_en(DUT.wr_en), 
                                        .rd_en(DUT.rd_en), 
                                        .data_out(DUT.data_out),
                                        .wr_ack(DUT.wr_ack), 
                                        .overflow(DUT.overflow), 
                                        .underflow(DUT.underflow), 
                                        .full(DUT.full), 
                                        .empty(DUT.empty), 
                                        .almostfull(DUT.almostfull), 
                                        .almostempty(DUT.almostempty),
                                        .count(DUT.count)
                                   );
                                   
    /* --------------- Run the FIFO test -------------- */
    initial begin
        /* Pass the Configuration object to interface */
        uvm_config_db #(virtual fifo_interface)::set(null,"uvm_test_top","FIFO_VIF",fifo_if);
        
        /* Run the test (Replace what is in " ") */
        run_test("fifo_test");
    end
endmodule