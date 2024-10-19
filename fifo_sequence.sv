/* File Description : UVM Sequence should contain::
                        - Core stimulus of any verification plan
                        - Made up of several Sequence items
                        - Main stimulus is written within body() task */


package fifo_sequence_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_sequence_item_pkg::*;
    import shared_pkg::*;
    
    /* ----------------- RESET Sequence Class  ----------- */
    class fifo_reset_sequence extends uvm_sequence #(fifo_sequence_item);
        /* Add the UVM object to the UVM factory */
        `uvm_object_utils(fifo_reset_sequence)

        /* Create the sequence item */
        fifo_sequence_item fifo_seq_item;

        /* Sequence Constructor */
        function new(string name = "fifo_reset_sequence");
            super.new(name);
        endfunction

        /* Main body() task */
        task body();
            /* Create the sequence item in the factory */
            fifo_seq_item = fifo_sequence_item::type_id::create("fifo_seq_item");

            start_item(fifo_seq_item);
                /* Edittable area in the sequence body() task */
                fifo_seq_item.rst_n     = 0;
                fifo_seq_item.wr_en     = 0;
                fifo_seq_item.rd_en     = 0;
            finish_item(fifo_seq_item);
        endtask
    endclass

    /* ----------------- Write Only Sequence Class  ----------- */
    class fifo_writeOnly_sequence extends uvm_sequence #(fifo_sequence_item);
        /* Add the UVM object to the UVM factory */
        `uvm_object_utils(fifo_writeOnly_sequence)

        /* Create the sequence item */
        fifo_sequence_item fifo_seq_item;

        /* Sequence Constructor */
        function new(string name = "fifo_writeOnly_sequence");
            super.new(name);
        endfunction

        /* Main body() task */
        task body();
                /* Edittable area in the sequence body() task */
                repeat(1000) begin
                    /* Create the sequence item in the factory */
                    fifo_seq_item = fifo_sequence_item::type_id::create("fifo_seq_item");

                    fifo_seq_item.reset_c.constraint_mode(1);
                    fifo_seq_item.WR_EN_c.constraint_mode(0);
                    fifo_seq_item.RD_EN_c.constraint_mode(0);
                    fifo_seq_item.WR_ONLY.constraint_mode(1);
                    fifo_seq_item.RD_ONLY.constraint_mode(0);

                    start_item(fifo_seq_item);
                        assert(fifo_seq_item.randomize());
                    finish_item(fifo_seq_item);
                end

        endtask
    endclass

    /* ----------------- Read Only Sequence Class  ----------- */
    class fifo_readOnly_sequence extends uvm_sequence #(fifo_sequence_item);
        /* Add the UVM object to the UVM factory */
        `uvm_object_utils(fifo_readOnly_sequence)

        /* Create the sequence item */
        fifo_sequence_item fifo_seq_item;

        /* Sequence Constructor */
        function new(string name = "fifo_readOnly_sequence");
            super.new(name);
        endfunction

        /* Main body() task */
        task body();
                /* Edittable area in the sequence body() task */
                repeat(1000) begin
                    /* Create the sequence item in the factory */
                    fifo_seq_item = fifo_sequence_item::type_id::create("fifo_seq_item");

                    fifo_seq_item.reset_c.constraint_mode(1);
                    fifo_seq_item.WR_EN_c.constraint_mode(0);
                    fifo_seq_item.RD_EN_c.constraint_mode(0);
                    fifo_seq_item.WR_ONLY.constraint_mode(0);
                    fifo_seq_item.RD_ONLY.constraint_mode(1);

                    start_item(fifo_seq_item);
                        assert(fifo_seq_item.randomize());
                    finish_item(fifo_seq_item);
                end

        endtask
    endclass

    /* ----------------- Read Write Sequence Class  ----------- */
    class fifo_readWrite_sequence extends uvm_sequence #(fifo_sequence_item);
        /* Add the UVM object to the UVM factory */
        `uvm_object_utils(fifo_readWrite_sequence)

        /* Create the sequence item */
        fifo_sequence_item fifo_seq_item;

        /* Sequence Constructor */
        function new(string name = "fifo_readWrite_sequence");
            super.new(name);
        endfunction

        /* Main body() task */
        task body();
                /* Edittable area in the sequence body() task */
                repeat(15000) begin
                    /* Create the sequence item in the factory */
                    fifo_seq_item = fifo_sequence_item::type_id::create("fifo_seq_item");

                    fifo_seq_item.reset_c.constraint_mode(1);
                    fifo_seq_item.WR_EN_c.constraint_mode(1);
                    fifo_seq_item.RD_EN_c.constraint_mode(1);
                    fifo_seq_item.WR_ONLY.constraint_mode(0);
                    fifo_seq_item.RD_ONLY.constraint_mode(0);

                    start_item(fifo_seq_item);
                        assert(fifo_seq_item.randomize());
                    finish_item(fifo_seq_item);
                end

        endtask
    endclass
endpackage  