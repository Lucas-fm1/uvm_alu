class reg_transaction extends uvm_sequence_item;
  //Entradas do DUT
  rand bit [15:0] data_in;
  rand bit [1:0]     addr;

  //Construtor
  function new(string name = "reg_transaction");
    super.new(name);
  endfunction

  //Macros
  `uvm_object_param_utils_begin(reg_transaction)
  `uvm_field_int(data_in, UVM_UNSIGNED)
  `uvm_field_int(addr, UVM_UNSIGNED)
  `uvm_object_utils_end

  function string convert2string();
    return $sformatf("{data_in = %d , addr = %h}", data_in, addr);
  endfunction
endclass