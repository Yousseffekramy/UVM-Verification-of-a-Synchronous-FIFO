/* File Description: Configuration Object refers to an object 
                     that holds configuration settings and 
                     parameters for UVM components */

package fifo_config_pkg;
    /* ---------------- Import UVM packages -------------- */
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    class fifo_config_obj extends uvm_object;
        /* Add the UVM object to the UVM factory */
        `uvm_object_utils(fifo_config_obj)
        
        /* Create a virtual interface for configuration object */
        virtual fifo_interface fifo_config_vif;

        /* Configuration Object Constructor */
        function new(string name = "fifo_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage