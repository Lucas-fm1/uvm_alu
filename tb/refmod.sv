import "DPI-C" context function int my_sqrt(int x);

`uvm_analysis_imp_decl(_alu)
`uvm_analysis_imp_decl(_reg)

class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    // TRANSAÇÕES
    alu_transaction alu_tr_in;
    reg_transaction reg_tr_in;
    ref_transaction ref_tr_out;
    
    // PORTAS
    uvm_analysis_imp_alu #(alu_transaction, refmod) alu_pin;
    uvm_analysis_imp_reg #(reg_transaction, refmod) reg_pin;
    uvm_analysis_port #(ref_transaction) ref_pout;
    
    event begin_refmodtask, begin_record, end_record;

    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = transaction_out::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            refmod_task();
            record_tr();
        join
    endtask: run_phase

    task refmod_task();
        forever begin
            @begin_refmodtask;
            tr_out = transaction_out::type_id::create("tr_out", this);
            -> begin_record;
            tr_out.result = my_sqrt(tr_in.data);
            #10;
            -> end_record;
            out.write(tr_out);
        end
    endtask : refmod_task

    virtual function write (transaction_in t);
        tr_in = transaction_in#()::type_id::create("tr_in", this);
        tr_in.copy(t);
       -> begin_refmodtask;
    endfunction

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(tr_out, "refmod");
            @(end_record);
            end_tr(tr_out);
        end
    endtask
endclass: refmod