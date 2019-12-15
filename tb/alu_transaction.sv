class alu_transaction extends uvm_sequence_item;
  //Entradas do DUT
  rand bit [15:0]      A;
  rand bit [1:0] reg_sel;
  rand bit [1:0]   instru;

  //Saídas do DUT
  bit [31:0] data_out;

  //Construtor
  function new(string name = "alu_transaction");
    super.new(name);
  endfunction

  //Macros
  `uvm_object_param_utils_begin(alu_transaction)
  `uvm_field_int(A, UVM_UNSIGNED)
  `uvm_field_int(reg_sel, UVM_UNSIGNED)
  `uvm_field_int(instr, UVM_UNSIGNED)
  `uvm_field_int(data_out, UVM_UNSIGNED)
  `uvm_object_utils_end

  function string convert2string();
    return $sformatf("{A = %d, reg_sel = %h, instru = %d, data_out = %d}",A, reg_sel, instru, data_out);
  endfunction
endclass