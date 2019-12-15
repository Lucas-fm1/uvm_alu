class env extends uvm_env;
    `uvm_component_utils(env)

    alu_agent    alu_agt;
    reg_agent    reg_agt;
    scoreboard   sb;
    coverage     cov;
    
// --------------------------- Construtor ------------------------------//
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

// --------------------------- Build Phase -----------------------------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        alu_agt = alu_agent::type_id::create ("alu_agt", this);
        reg_agt = reg_agent::type_id::create("reg_agt", this);
        sb      = scoreboard::type_id::create("sb", this);
        cov     = coverage::type_id::create("cov", this);
    endfunction

// -------------------------- Connect Phase ------------------------------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        alu_agt.alu_agt_port.connect(cov.alu_port); // alu_agt -> coverage
        alu_agt.alu_agt_port.connect(sb.alu_mon_port); // alu_agt -> refmod
        alu_agt.ref_agt_port.connect(sb.alu_ref_port); // alu_agt -> comp
        //   reg_agt.reg_agt_port.connect(cov.cov_port); // reg_agt -> coverage      
        reg_agt.reg_agt_port.connect(sb.reg_mon_port); // reg_agt -> refmod
    endfunction
endclass