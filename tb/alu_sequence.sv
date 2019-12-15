class alu_sequence extends uvm_sequence #(alu_transaction);
    `uvm_object_utils(alu_sequence)

// ------------------------------ Macro --------------------------------//
    function new(string name="alu_sequence");
        super.new(name);
    endfunction: new

// ------------------------------ Body ---------------------------------//
    task body();
        alu_transaction alu_tr;

        forever begin
            alu_tr = alu_transaction::type_id::create("alu_tr");
            start_item(alu_tr);
            assert(alu_tr.randomize());
            finish_item(alu_tr);
        end
    endtask: body

endclass: alu_sequence