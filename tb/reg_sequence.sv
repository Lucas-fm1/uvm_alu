class reg_sequence extends uvm_sequence #(reg_transaction);
   `uvm_object_utils(reg_sequence)

// ------------------------------ Macro --------------------------------//
    function new(string name="reg_sequence");
        super.new(name);
    endfunction: new

// ------------------------------ Body ---------------------------------//
    task body();
        reg_transaction reg_tr;

        forever begin
            reg_tr = transaction_in::type_id::create("reg_tr");
            start_item(reg_tr);
            assert(reg_tr.randomize());
            finish_item(reg_tr);
        end
    endtask: body

endclass: reg_sequence