/* File Description : UVM Sequence Item should contain::
                        - Data Fields to communicate with the DUT
                        - Random stimulus is generated
                        - Functions can be added to compare/copy/display
                          different sequence item fields */


package fifo_sequence_item_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import shared_pkg::*;
    /* ------------------------- Parameters --------------------- */
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    class fifo_sequence_item extends uvm_sequence_item;
        /* Add the UVM object to the UVM factory */
        `uvm_object_utils(fifo_sequence_item)

        /* The randomized inputs and their outputs */
        /* --------------------------- Inputs ----------------------- */
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;

        /* --------------------------- Outputs ---------------------- */
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow ;

        /* --------------------- Transaction Integers ---------------- */
        integer RD_EN_ON_DIST = 30;
        integer WR_EN_ON_DIST = 70;

        /* ============================================================ */
        
        /* ------------------------- Constraints ---------------------- */
        
        /* Constraint for rst_n to be deasserted */
        constraint reset_c {
            rst_n dist { 0 := 2, 1:=98};
        }
        
        /*  Constraint the write enable to be high / low according to 
        distribution of the value WR_EN_ON_DIST */
        constraint WR_EN_c {
            wr_en dist { 1 := WR_EN_ON_DIST ,
                         0 := 100 - WR_EN_ON_DIST};
        }

        /*  Constraint the write enable to be high / low according to 
        distribution of the value RD_EN_ON_DIST */
        constraint RD_EN_c {
            rd_en dist { 1 := RD_EN_ON_DIST ,
                         0 := 100 - RD_EN_ON_DIST};
        }

        /* Constraint the write only to enable write and disable read */
        constraint WR_ONLY {
            wr_en == 1'b1 && rd_en == 1'b0;
        }

        /* Constraint the write only to enable write and disable read */
        constraint RD_ONLY {
            rd_en == 1'b1 && wr_en == 1'b0;
        }

        /* Sequence Item Constructor */
        function new(string name = "fifo_sequence_item");
            super.new(name);
        endfunction

        /* Return the data passed to DUT and GM */
        function string convert2string();
             return $sformatf("%s reset = %0b, data_in = %0b, wr_en = %0b, rd_en = %0b, data_out = %0d",// data_out_GM = %0d, 
                    super.convert2string(), rst_n, data_in, wr_en, rd_en, data_out);//, data_out_GM);
        endfunction

        function string convert2string_stimulus();
             return $sformatf("%s reset = %0b, data_in = %0b, wr_en = %0b, rd_en = %0b", 
                    super.convert2string(), rst_n, data_in, wr_en, rd_en);
        endfunction

    endclass
endpackage