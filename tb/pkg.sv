package pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "./alu_transaction.sv"
  `include "./reg_transaction.sv"
  `include "./ref_transaction.sv"

  `include "./alu_sequence.sv"
  `include "./reg_sequence.sv"

  `include "./alu_driver.sv"
  `include "./reg_driver.sv"

  `include "./alu_monitor.sv"
  `include "./reg_monitor.sv"

  `include "./alu_agent.sv"
  `include "./reg_agent.sv"
  
  `include "./refmod.sv"

  `include "./coverage.sv"
  `include "./scoreboard.sv"
  `include "./environment.sv"
  `include "./simple_test.sv"

endpackage
