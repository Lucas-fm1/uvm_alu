class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	typedef uvm_in_order_class_comparator #(ref_transaciton) comp_type;

	refmod rfm;
	comp_type comp;

	uvm_analysis_port #(alu_transaction) alu_mon_port;
	uvm_analysis_port #(reg_transaction) reg_mon_port;
	uvm_analysis_port #(ref_transaction) ref_mon_port;
	uvm_analysis_port #(ref_transaction) alu_ref_port;
	uvm_analysis_port #(ref_transaction) rfm_ref_port;

// --------------------------- Construtor ------------------------------//
	function new(string name = "scoreboard", uvm_component parent);
		super.new(name, parent);
		alu_mon_port = new("alu_mon_port", this);
		reg_mon_port = new("reg_mon_port", this);
		ref_mon_port = new("ref_mon_port", this);
		alu_ref_port = new("alu_ref_port", this);
		rfm_ref_port = new("rfm_ref_port", this);
	endfunction

// --------------------------- Build Phase -----------------------------//
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rfm = refmod::type_id::create("rfm", this);
		comp = comp_type::type_id::create("comp", this);
	endfunction

// -------------------------- Connect Phase ------------------------------//
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		alu_mon_port.connect(rfm.alu_pin); 			// alu_mon -> rfm
		reg_mon_port.connect(rfm.reg_pin); 			// reg_mon -> rfm
		ref_mon_port.connect(rfm.ref_pout); 		// alu_ref -> rfm
		alu_ref_port.connect(comp.before_export); 	// alu_mon -> comp
		rfm.ref_pout.connect(comp.after_export); 	// rfm -> comp
	endfunction


endclass : scoreboard