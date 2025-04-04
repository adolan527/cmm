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

module complex_matrix_mult_4_mult #(
	parameter WIDTH = 32
	)(
	input clk, reset_n,
	input[WIDTH * `SIZE * `SIZE - 1:0] s_axis_r_tdata, //r matrix
	input[WIDTH * `SIZE * `SIZE - 1:0] s_axis_sh_tdata, //s * s^h
	output reg [WIDTH * `SIZE * `SIZE - 1:0] m_axis_debug_tdata,
	output[WIDTH-1:0] m_axis_sum_tdata
	//TODO implement functional AXI protocol
	input s_axis_r_tvalid, s_axis_sh_tvalid,
	input s_axis_r_tlast, s_axis_sh_tlast, 
	input s_axis_r_tuser, s_axis_sh_tuser, 
	output s_axis_r_tready, s_axis_sh_tready,
	//TODO implement functional AXI protocol
	input m_axis_sum_tready,
	output  m_axis_sum_tvalid, m_axis_sum_tuser, m_axis_sum_tlast
	);
	
	reg[WIDTH * `SIZE * `SIZE - 1:0] next_result;
	//reg[WIDTH-1:0] next_sum;
	
	matrix_accumulator #(.WIDTH(WIDTH)) accumulator(
		.s_axis_tdata(m_axis_debug_tdata),
		.m_axis_tdata(m_axis_sum_tdata),
		.clk(clk),
		.reset_n(reset_n)
	);
	
	
	integer i, j;
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			m_axis_debug_tdata <= 0;
		end else begin
			m_axis_debug_tdata <= next_result;
		end
	end

	always@(*)begin
		for(i = 0; i < `SIZE; i = i + 1)begin
			for(j = 0; j < `SIZE; j = j + 1)begin
				next_result[WIDTH * (i * `SIZE + j) +: WIDTH] = 
				m_axis_debug_tdata[WIDTH * (i * `SIZE + j) +: WIDTH] + 
				s_axis_r_tdata[WIDTH * (i * `SIZE + j) +: WIDTH] * 
				s_axis_sh_tdata[WIDTH * (i * `SIZE + j) +: WIDTH];
			end
		end
		
	end

endmodule
