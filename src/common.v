`timescale 1ns/1ps








module complex_adder #(ELEMENT_SIZE = 16)(
	input[ELEMENT_SIZE-1:0] a, b,
	output reg[ELEMENT_SIZE-1:0] sum
	);
	
	always@(*)begin
		sum = {
		a[ELEMENT_SIZE-1:ELEMENT_SIZE/2] + b[ELEMENT_SIZE-1:ELEMENT_SIZE/2],
		a[ELEMENT_SIZE/2 - 1:0] + b[ELEMENT_SIZE/2 - 1:0]};
	end
	
endmodule

module shift_register #(
	parameter SIZE = 32,
	parameter STAGES = 3
	)(
	input clk, reset_n, enable,
	input[SIZE-1:0] din,
	output reg[SIZE-1:0] dout
	);
	
	reg[SIZE-1:0] buffer[STAGES-1:0];
	
	integer i;
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			for(i = 0; i < STAGES; i = i + 1)begin
				buffer[i] <= 0;
			end
		end else begin
			for(i = 0; i < STAGES; i = i + 1)begin
				if(enable)begin
					if(i == 0) buffer[i] <= din;
					else buffer[i] <= buffer[i-1];
				end else buffer[i] <= buffer[i];
			end
		end
	end
	
	always@(*)begin
		dout <= buffer[STAGES-1];
	end
	
endmodule