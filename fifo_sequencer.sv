/* File Description: UVM SEQUENCER should contain::
                        - Generates transactions as class objects
                        - Sends it to the driver for execution */

package fifo_sequencer_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    /* -------------- Import Hierarchy packages ---------- */
    import fifo_sequence_item_pkg::*;

    class fifo_sequencer extends uvm_sequencer #(fifo_sequence_item);
        /* Add the UVM component to the UVM factory */
        `uvm_component_utils(fifo_sequencer)

        /* SEQUENCER constructor */
        function new(string name = "fifo_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage