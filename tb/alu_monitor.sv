class alu_monitor extends uvm_monitor;

    // Macro
    `uvm_component_utils(alu_monitor)

    alu_vif  vif;
    event begin_record, end_record;
    alu_transaction alu_tr;

    uvm_analysis_port #(alu_transaction) alu_mon_port;
    uvm_analysis_port #(ref_transaction) ref_mon_port;

// --------------------------- Construtor ------------------------------//
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ref_mon_port = new("ref_mon_port", this);
        alu_mon_port = new("alu_mon_port", this);
    endfunction

// --------------------------- Build Phase -----------------------------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
        tr_alu  = ref_transaction::type_id::create("tr_alu", this);
        tr_ref  = alu_transaction::type_id::create("tr_ref", this);
    endfunction

// ---------------------------- Run Phase ------------------------------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_alu_transaction(phase);
            collect_ref_transaction(phase);
        join
    endtask // run_phase



//      Collect ALU Transactions
/**/         virtual task collect_alu_transaction(uvm_phase phase);
/**/            forever begin
/**/                @(posedge vif.clk);
/**/                if(vif.rst_n) begin
/**/                    begin_tr(alu_tr, "tr_alu");
/**/                    alu_tr.data_in   = vif.A;
/**/                    alu_tr.reg_sel   = vif.reg_sel;
/**/                    alu_tr.instru    = vif.instru;
/**/                    alu_tr.valid_ula = vif.valid_ula;
/**/                    alu_tr.data_out  = vif.data_out;
/**/                    alu_tr.valid_out = vif.valid_out;
/**/                    alu_mon_port.write(alu_tr);
/**/                    @(negedge vif.clk);
/**/                    end_tr(alu_tr);
/**/                end     // if (vif.rst_n)
/**/            end         // forever begin
/**/        endtask         // collect_transaction

//      Collect REF Transactions
/**/            virtual task collect_ref_transaction(uvm_phase phase);
/**/                forever begin
/**/                    @(posedge vif.clk);
/**/                    if(vif.rst_n && vif.valid_out) begin
/**/                        begin_tr(ref_tr, "tr_ref");
/**/                        ref_tr.data_out = vif.data_out;
/**/                        ref_mon_port.write(ref_tr);
/**/                        @(negedge vif.clk);
/**/                        end_tr(ref_tr);
/**/                    end
/**/                end
/**/            endtask // collect_ref_transaction


endclass
