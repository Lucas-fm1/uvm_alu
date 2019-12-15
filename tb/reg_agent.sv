typedef uvm_sequencer #(reg_transaction) reg_sequencer;

class reg_agent extends uvm_agent;

    // Macro
    `uvm_component_utils(reg_agent)
    
    alu_sequencer   sqr;
    alu_driver      drv;
    alu_monitor     mon;

    uvm_analysis_port #(reg_transaction) reg_agt_port;

    

// --------------------------- Construtor ------------------------------//
    function new(string name = "reg_agent", uvm_component parent = null);
        super.new(name, parent);
        reg_agt_port = new("reg_agt_port", this);
    endfunction

// --------------------------- Build Phase -----------------------------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        reg_sqr = reg_sequencer::type_id::create("reg_sqr", this);
        reg_drv = reg_driver::type_id::create("reg_drv", this);
        reg_mon = reg_monitor::type_id::create("reg_mon", this);
    endfunction

// -------------------------- Connect Phase ------------------------------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        reg_mon.reg_port.connect(reg_agt_port);
        reg_drv.seq_item_port.connect(reg_sqr.seq_item_export);
        
    endfunction


endclass: reg_agent