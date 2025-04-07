`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 12:39:59 AM
// Design Name: 
// Module Name: complex_mult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




//inputs: A 4x4 complex matrix, B 1x4 matrix, C 4x1 matrix.
//outputs: B * A * C
//limitations: only N complex mults
`define SIZE 4
// Optimization:
// s^h * r * s == s * s^h .* r
// 1x4 * 4x4 * 4x1 == 4x1 * 1x4 * 4x4


module adder #( // dummy module to make switch to complex adder easier
	parameter WIDTH = 32
	)(
	input[WIDTH-1:0] a, b,
	output[WIDTH-1:0] c
	);
	
	assign c = a + b;
	
endmodule


module matrix_accumulator_no_latency #(
	parameter WIDTH = 32 //element size
	)(
	input clk, reset_n,
	input[WIDTH * `SIZE * `SIZE - 1:0] s_axis_tdata,
	output reg[WIDTH - 1:0] m_axis_tdata,
	//TODO implement functional AXI protocol
	input s_axis_tuser, s_axis_tvalid, s_axis_tlast,
	output s_axis_tready,
	
	input m_axis_tready,
	output m_axis_tuser, m_axis_tvalid, m_axis_tlast
	);
	
	localparam L0W = 16;//Layer 0 width
	localparam L1W = 8; // Layer 1 width
	localparam L2W = 4; // Layer 2 width
	localparam L3W = 2; // Layer 3 width
	localparam L4W = 1; // Layer 4 width
	
	
	wire[WIDTH-1:0] layer1[L1W-1:0];
	wire[WIDTH-1:0] layer2[L2W-1:0];
	wire[WIDTH-1:0] layer3[L3W-1:0];
	wire[WIDTH-1:0] layer4[L4W-1:0];
	
	
	reg[WIDTH-1:0] matrix[`SIZE * `SIZE - 1:0];

	integer i;

	
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n) begin
			m_axis_tdata <= 0;
		end else begin
			m_axis_tdata <= layer4[0];
		end
	end
	
	
	always@(*)begin
		for(i = 0; i < `SIZE * `SIZE; i = i + 1)begin
			matrix[i] = s_axis_tdata[WIDTH * i +: WIDTH];
		end
	end

	genvar j;
	generate
	for(j = 0; j < L0W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_1_adder(
		.a(matrix[j]),
		.b(matrix[j+1]),
		.c(layer1[j/2])
		);
	end
	for(j = 0; j < L1W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_2_adder(
		.a(layer1[j]),
		.b(layer1[j+1]),
		.c(layer2[j/2])
		);
	end
	for(j = 0; j < L2W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_3_adder(
		.a(layer2[j]),
		.b(layer2[j+1]),
		.c(layer3[j/2])
		);
	end
	for(j = 0; j < L3W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_4_adder(
		.a(layer3[j]),
		.b(layer3[j+1]),
		.c(layer4[j/2])
		);
	end
	endgenerate
	
endmodule


module matrix_accumulator #(
	parameter WIDTH = 32 //element size
	)(
	input clk, reset_n,
	input[WIDTH * `SIZE * `SIZE - 1:0] s_axis_tdata,
	output reg[WIDTH - 1:0] m_axis_tdata,
	//TODO implement functional AXI protocol
	input s_axis_tuser, s_axis_tvalid, s_axis_tlast,
	output s_axis_tready,
	
	input m_axis_tready,
	output m_axis_tuser, m_axis_tvalid, m_axis_tlast
	);
	localparam L0W = 16;//Layer 0 width
	localparam L1W = 8; // Layer 1 width
	localparam L2W = 4; // Layer 2 width
	localparam L3W = 2; // Layer 3 width
	localparam L4W = 1; // Layer 4 width
	
	
	reg[WIDTH-1:0] layer1[L1W-1:0];
	reg[WIDTH-1:0] layer2[L2W-1:0];
	reg[WIDTH-1:0] layer3[L3W-1:0];
	reg[WIDTH-1:0] layer4[L4W-1:0];
	
	wire[WIDTH-1:0] next_layer1[L1W-1:0];
	wire[WIDTH-1:0] next_layer2[L2W-1:0];
	wire[WIDTH-1:0] next_layer3[L3W-1:0];
	wire[WIDTH-1:0] next_layer4[L4W-1:0];
	
	reg[WIDTH-1:0] matrix[`SIZE * `SIZE - 1:0];

	integer i;

	
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n) begin
			for(i = 0; i < L0W; i = i + 1)begin
				if(i<L1W) layer1[i] <= 0;
				if(i<L2W) layer2[i] <= 0;
				if(i<L3W) layer3[i] <= 0;
				if(i<L4W) layer4[i] <= 0;
			end
		end else begin
			for(i = 0; i < L0W; i = i + 1)begin
				if(i<L1W) layer1[i] <= next_layer1[i];
				if(i<L2W) layer2[i] <= next_layer2[i];
				if(i<L3W) layer3[i] <= next_layer3[i];
				if(i<L4W) layer4[i] <= next_layer4[i];
			end
		end
	end
	
	
	always@(*)begin
		m_axis_tdata <= layer4[0];
		for(i = 0; i < `SIZE * `SIZE; i = i + 1)begin
			matrix[i] = s_axis_tdata[WIDTH * i +: WIDTH];
		end
	end

	genvar j;
	generate
	for(j = 0; j < L0W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_1_adder(
		.a(matrix[j]),
		.b(matrix[j+1]),
		.c(next_layer1[j/2])
		);
	end
	for(j = 0; j < L1W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_2_adder(
		.a(layer1[j]),
		.b(layer1[j+1]),
		.c(next_layer2[j/2])
		);
	end
	for(j = 0; j < L2W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_3_adder(
		.a(layer2[j]),
		.b(layer2[j+1]),
		.c(next_layer3[j/2])
		);
	end
	for(j = 0; j < L3W; j = j + 2)begin
		adder #(.WIDTH(WIDTH)) layer_4_adder(
		.a(layer3[j]),
		.b(layer3[j+1]),
		.c(next_layer4[j/2])
		);
	end
	endgenerate
	
endmodule


module counter #(
	parameter LIMIT = 16
	)(
	input clk, reset_n, enable, 
	output reg[$clog2(LIMIT)-1:0] count
	);
	
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			count <= 0;
		end else begin
			if(enable) count <= (count + 1) % LIMIT;
			else count <= count;
		end
	end
endmodule

module complex_matrix_mult_1_mult #(
	parameter WIDTH = 32
	)(
	input clk, reset_n,
	input[WIDTH * `SIZE * `SIZE - 1:0] s_axis_r_tdata, //r matrix
	input[WIDTH * `SIZE * `SIZE - 1:0] s_axis_sh_tdata, //s * s^h
	output reg [WIDTH * `SIZE * `SIZE - 1:0] m_axis_matrix_tdata,
	
	input s_axis_r_tvalid, s_axis_sh_tvalid,
	input s_axis_r_tlast, s_axis_sh_tlast, // overwritten
	input s_axis_r_tuser, s_axis_sh_tuser, 
	output s_axis_r_tready, s_axis_sh_tready,
	
	input m_axis_matrix_tready,
	output reg m_axis_matrix_tvalid,
	output m_axis_matrix_tlast,
	output [1:0] m_axis_matrix_tuser
	);
	
	localparam ELEMENTS = 16;
	localparam LATENCY = 8;

	
	reg[WIDTH * `SIZE * `SIZE - 1:0] next_result;
	wire[ELEMENTS - 1:0] count, delay_count;
	reg count_enable, s_axis_tlast;
	wire[WIDTH * 2 - 1:0] m_axis_dout_tdata;
	
	counter #(.LIMIT(ELEMENTS))(
		.clk(clk),
		.reset_n(reset_n),
		.count(count),
		.enable(count_enable)
	);

	
	
	integer i, j;
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			m_axis_matrix_tdata <= 0;
		end else begin
			for(i = 0; i < ELEMENTS; i = i + 1)begin
				if(i==delay_count) m_axis_matrix_tdata[i * WIDTH +: WIDTH] <= m_axis_dout_tdata;
				else m_axis_matrix_tdata[i * WIDTH +: WIDTH] <= m_axis_matrix_tdata[i * WIDTH +: WIDTH];
			end
		end
	end
	
	
	reg[WIDTH - 1:0] s_axis_a_tdata, s_axis_b_tdata;
	
cmpy_1 x_complex_multiplier (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(count_enable),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_r_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_r_tready), // output wire s_axis_a_tready
  .s_axis_a_tdata(s_axis_a_tdata),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(count),            // input wire [3 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(s_axis_sh_tdata),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_sh_tready), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_sh_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser({s_axis_r_tuser,s_axis_sh_tuser}),
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(m_axis_dout_tdata),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_matrix_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser({delay_count,m_axis_matrix_tuser}),    // output wire [5 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_matrix_tlast)   // output wire m_axis_dout_tlast
);

	always@(*)begin
		s_axis_tlast <= count == ELEMENTS-1;
		m_axis_matrix_tvalid <= m_axis_matrix_tlast & m_axis_dout_tvalid;
		s_axis_a_tdata <= s_axis_r_tdata[WIDTH * count +: WIDTH];
		s_axis_b_tdata <= s_axis_sh_tdata[WIDTH * count +: WIDTH];
		count_enable <= s_axis_r_tvalid & s_axis_sh_tvalid & m_axis_matrix_tready & s_axis_r_tready & s_axis_sh_tready;
	end

endmodule



