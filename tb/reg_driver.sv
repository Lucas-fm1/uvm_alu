typedef virtual reg_if reg_vif;

class reg_driver extends uvm_driver #(reg_transaction);
    `uvm_component_utils(reg_driver)

    reg_vif vif;
    reg_transaction rt;

// ------------------------------ Macro --------------------------------//    
    function new(string name = "reg_driver", uvm_component parent = null);
        super.new(name, parent);

    endfunction

// --------------------------- Build Phase -----------------------------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(reg_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

// ---------------------------- Run Phase ------------------------------//
    task run_phase (uvm_phase phase);
        fork
            reset_signals();
            get_and_drive(phase);
        join
    endtask

//          Reset
/**/            virtual task reset_signals();    
/**/                wait (vif.rst === 0);
/**/                forever begin
/**/                    vif.valid_reg  <= '0;
/**/                    @(negedge vif.rst);
/**/                end
/**/            endtask : reset_signals

//          Get and drive
/**/            virtual task get_and_drive(uvm_phase phase);
/**/                wait (vif.rst === 0);
/**/                @(posedge vif.rst);
/**/                forever begin
/**/                    seq_item_port.get_next_item(rt);
/**/                    driver_transfer(rt);
/**/                    seq_item_port.item_done();
/**/                end
/**/            endtask : get_and_drive

//          Driver Transfer
/**/            virtual task driver_transfer(reg_transaction rt);
/**/                @(posedge vif.clk);
/**/                vif.data_in     <= rt.data_in;
/**/                vif.addr        <= rt.addr;
/**/                vif.valid_reg   <= 1;
/**/            endtask : driver_transfer

endclass