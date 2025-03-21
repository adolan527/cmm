`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 07:35:45 PM
// Design Name: 
// Module Name: mult
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


module multiplier(
	input clk, reset_n,
	input[31:0] channel_0_base,
	input[31:0] channel_1_base,
	input[31:0] channel_2_base,
	input[31:0] channel_3_base,
	input[31:0] channel_0_conj,
	input[31:0] channel_1_conj,
	input[31:0] channel_2_conj,
	input[31:0] channel_3_conj,
	output reg[63:0] result_matrix_0_0,
	output reg[63:0] result_matrix_0_1,
	output reg[63:0] result_matrix_0_2,
	output reg[63:0] result_matrix_0_3,
	output reg[63:0] result_matrix_1_0,
	output reg[63:0] result_matrix_1_1,
	output reg[63:0] result_matrix_1_2,
	output reg[63:0] result_matrix_1_3,
	output reg[63:0] result_matrix_2_0,
	output reg[63:0] result_matrix_2_1,
	output reg[63:0] result_matrix_2_2,
	output reg[63:0] result_matrix_2_3,
	output reg[63:0] result_matrix_3_0,
	output reg[63:0] result_matrix_3_1,
	output reg[63:0] result_matrix_3_2,
	output reg[63:0] result_matrix_3_3
	);
	
	reg[63:0] next_result_matrix_0_0;
	reg[63:0] next_result_matrix_0_1;
	reg[63:0] next_result_matrix_0_2;
	reg[63:0] next_result_matrix_0_3;
	reg[63:0] next_result_matrix_1_0;
	reg[63:0] next_result_matrix_1_1;
	reg[63:0] next_result_matrix_1_2;
	reg[63:0] next_result_matrix_1_3;
	reg[63:0] next_result_matrix_2_0;
	reg[63:0] next_result_matrix_2_1;
	reg[63:0] next_result_matrix_2_2;
	reg[63:0] next_result_matrix_2_3;
	reg[63:0] next_result_matrix_3_0;
	reg[63:0] next_result_matrix_3_1;
	reg[63:0] next_result_matrix_3_2;
	reg[63:0] next_result_matrix_3_3;
	
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			result_matrix_0_0 <= 64'b0;
			result_matrix_0_1 <= 64'b0;
			result_matrix_0_2 <= 64'b0;
			result_matrix_0_3 <= 64'b0;
			result_matrix_1_0 <= 64'b0;
			result_matrix_1_1 <= 64'b0;
			result_matrix_1_2 <= 64'b0;
			result_matrix_1_3 <= 64'b0;
			result_matrix_2_0 <= 64'b0;
			result_matrix_2_1 <= 64'b0;
			result_matrix_2_2 <= 64'b0;
			result_matrix_2_3 <= 64'b0;
			result_matrix_3_0 <= 64'b0;
			result_matrix_3_1 <= 64'b0;
			result_matrix_3_2 <= 64'b0;
			result_matrix_3_3 <= 64'b0;
		end
		else begin
			result_matrix_0_0 <= result_matrix_0_0 + next_result_matrix_0_0;
			result_matrix_0_1 <= result_matrix_0_1 + next_result_matrix_0_1;
			result_matrix_0_2 <= result_matrix_0_2 + next_result_matrix_0_2;
			result_matrix_0_3 <= result_matrix_0_3 + next_result_matrix_0_3;
			result_matrix_1_0 <= result_matrix_1_0 + next_result_matrix_1_0;
			result_matrix_1_1 <= result_matrix_1_1 + next_result_matrix_1_1;
			result_matrix_1_2 <= result_matrix_1_2 + next_result_matrix_1_2;
			result_matrix_1_3 <= result_matrix_1_3 + next_result_matrix_1_3;
			result_matrix_2_0 <= result_matrix_2_0 + next_result_matrix_2_0;
			result_matrix_2_1 <= result_matrix_2_1 + next_result_matrix_2_1;
			result_matrix_2_2 <= result_matrix_2_2 + next_result_matrix_2_2;
			result_matrix_2_3 <= result_matrix_2_3 + next_result_matrix_2_3;
			result_matrix_3_0 <= result_matrix_3_0 + next_result_matrix_3_0;
			result_matrix_3_1 <= result_matrix_3_1 + next_result_matrix_3_1;
			result_matrix_3_2 <= result_matrix_3_2 + next_result_matrix_3_2;
			result_matrix_3_3 <= result_matrix_3_3 + next_result_matrix_3_3;
		end
	end
	
	always@(*)begin
		next_result_matrix_0_0 <= channel_0_base * channel_0_conj;
		next_result_matrix_0_1 <= channel_0_base * channel_1_conj;
		next_result_matrix_0_2 <= channel_0_base * channel_2_conj;
		next_result_matrix_0_3 <= channel_0_base * channel_3_conj;
		next_result_matrix_1_0 <= channel_1_base * channel_0_conj;
		next_result_matrix_1_1 <= channel_1_base * channel_1_conj;
		next_result_matrix_1_2 <= channel_1_base * channel_2_conj;
		next_result_matrix_1_3 <= channel_1_base * channel_3_conj;
		next_result_matrix_2_0 <= channel_2_base * channel_0_conj;
		next_result_matrix_2_1 <= channel_2_base * channel_1_conj;
		next_result_matrix_2_2 <= channel_2_base * channel_2_conj;
		next_result_matrix_2_3 <= channel_2_base * channel_3_conj;
		next_result_matrix_3_0 <= channel_3_base * channel_0_conj;
		next_result_matrix_3_1 <= channel_3_base * channel_1_conj;
		next_result_matrix_3_2 <= channel_3_base * channel_2_conj;
		next_result_matrix_3_3 <= channel_3_base * channel_3_conj;
	end
	
endmodule
			
	
