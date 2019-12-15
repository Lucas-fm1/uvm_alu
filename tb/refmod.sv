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

//==================================================================
/*  EVENTS:  */  event begin_refmodtask, begin_record, end_record;
//==================================================================


// --------------------------- Construtor ------------------------------//
        function new(string name = "refmod", uvm_component parent);
            super.new(name, parent);
            alu_pin = new("alu_pin", this);
            reg_pin = new("reg_pin", this);
            ref_pout = new("ref_pout", this);
            ref_regs = {16'hC4F3, 16'hB45E, 16'hD1E5, 16'h1DE4};
        endfunction // new

// --------------------------- Build Phase -----------------------------//
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction: build_phase

// ---------------------------- Run Phase ------------------------------//
        virtual task run_phase(uvm_phase phase);
            super.run_phase(phase);
            fork
                refmod_task();
                regs_update();
                record_tr();
            join
        endtask: run_phase

//=========================
//          TASKS:
//=========================

        //  ================== Refmod_task ==================
        task refmod_task();
            forever begin
                @begin_refmodtask;
                ref_tr_out = ref_transaction::type_id::create("ref_tr_out", this);
                -> begin_record;
                ref_tr_out.data_out = my_alu(alu_tr_in.data_in, ref_regs[alu_tr_in.reg_sel], alu_tr_in.instr);
                #10;
                -> end_record;
                ref_pout.write(ref_tr_out);
                wait(alu_tr_in.valid_out);
            end
        endtask : refmod_task


        //  ================== Regs_update ===================
        task regs_update();
            forever begin
                @begin_regsupdate;
                #1 ref_regs[reg_tr_in.addr] = reg_tr_in.data_in;
            end
        endtask


        //  ==================== Write's ====================
        virtual function write_alu (alu_transaction t);
            alu_tr_in = alu_transaction#()::type_id::create("alu_tr_in", this);
            alu_tr_in.copy(t);
            if(alu_tr_in.valid_in)
                -> begin_refmodtask;
        endfunction // write_alu

        virtual function write_reg (reg_transaction t);
            reg_tr_in = reg_transaction#()::type_id::create("reg_tr_in", this);
            reg_tr_in.copy(t);
            if(reg_tr_in.valid_reg)
                -> begin_regsupdate;
        endfunction// write_reg


        //  =================== Record_tr ===================
        virtual task record_tr();
            forever begin
                @begin_record;
                begin_tr(ref_tr_out, "refmod");
                @end_record;
                end_tr(ref_tr_out);
            end
        endtask


endclass: refmod