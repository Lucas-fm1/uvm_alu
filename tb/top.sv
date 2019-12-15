module top;
  
  import uvm_pkg::*;
  import pkg::*;

  logic clk;
  logic rst;

  initial begin

        clk = 1;
        rst = 1;
    #20 rst = 0;
    #20 rst = 1;

  end

  always #10 clk = !clk;

  alu_if dut__alu_if(.clk(clk), .rst(rst));
  reg_if dut__reg_if(.clk(clk), .rst(rst));

  // -----> Instanciação do DUT: 

  datapath datapath (
      .clk_ula    (clk),
      .clk_reg    (clk),
      .rst        (rst_n),
      .A          (dut_alu_if.data_A),
      .reg_sel    (dut_alu_if.reg_sel),
      .instru     (dut_alu_if.instr),
      .valid_ula  (dut_alu_if.valid_in),
      .data_out   (dut_alu_if.data_out),
      .valid_out  (dut_alu_if.valid_out),
      .data_in    (dut_reg_if.data_in),
      .addr       (dut_reg_if.addr),
      .valid_reg  (dut_reg_if.valid_reg)
  );

  initial begin
    //
    // -----> Fazendo algo que eu não sei
    //
    `ifdef XCELIUM
      $recordvars();
    `endif
    `ifdef VCS
      $vcdpluson;
    `endif
    `ifdef QUESTA
      $wlfdumpvars();
      set_config_int("*", "recording_detail", 1);
    `endif
    //
    // -----> Inicializando interfaces:
    //
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(), "*", "alu_vif", dut_alu_if);
    uvm_config_db#(virtual reg_if)::set(uvm_root::get(), "*", "reg_vif", dut_reg_if);
    //
    // -----> Rodando o teste:
    //
    run_test("simple_test");
  end
endmodule
