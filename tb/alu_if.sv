interface alu_if
	(
		input logic clk,
		input logic rst
	);

	logic [15:0]        A;
	logic [1:0]   reg_sel;
	logic [1:0]    instru;
	logic [31:0] data_out;
	logic       valid_ula;
	logic       valid_out;

endinterface 