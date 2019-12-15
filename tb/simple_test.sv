class simple_test extends uvm_test;
  `uvm_component_utils(simple_test)

  env           env;
  alu_sequence  alu_seq;
  reg_sequence  alu_seq;

// --------------------------- Construtor ------------------------------//
      function new(string name, uvm_component parent = null);
        super.new(name, parent);
      endfunction

// --------------------------- Build Phase -----------------------------//
      virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env     = environment::type_id::create("env", this);
        alu_seq = alu_sequence::type_id::create("alu_seq", this);
        reg_seq = reg_sequence::type_id::create("reg_seq", this);
      endfunction

// ---------------------------- Run Phase ------------------------------//
      task run_phase(uvm_phase phase);
        alu_seq.start(env.alu_agt.alu_sqr);
        reg_seq.start(env.reg_agt.reg_sqr);
      endtask


endclass
