typedef virtual alu_if alu_vif;

class alu_driver extends uvm_driver #(alu_transaction);

    // Macro
    `uvm_component_utils(alu_driver)
    
    alu_vif vif;
    event begin_record, end_record;
    alu_transaction alu_tr;

// --------------------------- Construtor ------------------------------//
    function new(string name = "alu_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

// --------------------------- Build Phase -----------------------------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(alu_vif)::get(this, "", "vif", vif)) begin
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


// 			Reset
/**/			virtual task reset_signals();    
/**/			    wait (vif.rst === 0);
/**/			    forever begin
/**/			        vif.valid_ula  <= '0;
/**/			        @(negedge vif.rst);
/**/			    end
/**/			endtask : reset_signals
			

// 			Get and drive
/**/			virtual task get_and_drive(uvm_phase phase);
/**/			    wait (vif.rst === 0);
/**/			    @(posedge vif.rst);
/**/			    forever begin
/**/			        seq_item_port.get_next_item(alu_tr);
/**/			        driver_transfer(alu_tr);
/**/ 					if(vif.valid_in) wait(vif.valid_out);
/**/			        seq_item_port.item_done();
/**/			    end
/**/			endtask : get_and_drive
			

// 			Driver Transfer
/**/			virtual task driver_transfer(alu_transaction alu_tr);
/**/			    @(posedge vif.clk);
/**/
/**/					alu_if.valid_ula <= 1;
/**/					alu_if.A 		<= alu_tr.A;
/**/					alu_if.reg_sel	<= alu_tr.reg_sel;
/**/					alu_if.instru	<= alu_tr.instru;
/**/
/**/			endtask : driver_transfer

endclass