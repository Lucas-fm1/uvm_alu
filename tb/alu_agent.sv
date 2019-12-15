typedef uvm_sequencer#(alu_transaction) alu_sequencer;

class alu_agent extends uvm_agent;

    // Macro
    `uvm_component_utils(alu_agent)
    
    alu_sequencer   alu_sqr;
    alu_driver      alu_drv;
    alu_monitor     alu_mon;

    uvm_analysis_port #(alu_transaction) alu_agt_port;
    uvm_analysis_port #(ref_transaction) ref_agt_port;



// --------------------------- Construtor ------------------------------//
    function new(string name = "alu_agent", uvm_component parent = null);
        super.new(name, parent);
        alu_agt_port = new("alu_agt_port", this);
        ref_agt_port = new("ref_agt_port", this);
    endfunction

// --------------------------- Build Phase -----------------------------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        alu_sqr = alu_sequencer::type_id::create("alu_sqr", this);
        alu_drv = alu_driver::type_id::create("alu_driver", this);
        alu_mon = alu_monitor::type_id::create("alu_mon", this);
    endfunction

// -------------------------- Connect Phase ------------------------------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        alu_mon.alu_mon_port.connect(alu_agt_port); // mon -> refmod/coverage
        alu_mon.ref_mon_port.connect(ref_agt_port); // mon -> comparator
        alu_drv.seq_item_port.connect(alu_sqr.seq_item_export); // sqr -> drv
    endfunction



endclass: alu_agent