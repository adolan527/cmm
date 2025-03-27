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


module complex_matrix_adder_parallel #(
	parameter MAT_WIDTH = 4,
	parameter MAT_HEIGHT = 4,
	parameter ELEMENT_SIZE = 16
	) (
	input clk, reset_n,
	input [MAT_WIDTH * MAT_HEIGHT * ELEMENT_SIZE - 1:0] s_axis_a_tdata, s_axis_b_tdata,
	output reg[MAT_WIDTH * MAT_HEIGHT * ELEMENT_SIZE - 1:0] m_axis_tdata,
	input s_axis_a_tvalid, s_axis_b_tvalid, s_axis_a_tlast, s_axis_b_tlast, s_axis_a_tuser, s_axis_b_tuser, m_axis_tready,
	output reg s_axis_a_tready, s_axis_b_tready, m_axis_tvalid, m_axis_tlast,
	output reg [1:0] m_axis_tuser
	);
	
	
	wire load_data;
	assign load_data = s_axis_a_tvalid & s_axis_b_tvalid & s_axis_a_tready & s_axis_b_tready & reset_n;
	wire[MAT_WIDTH * MAT_HEIGHT * ELEMENT_SIZE - 1:0] result;
	
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			m_axis_tdata <= 0;
			m_axis_tlast <= 0;
			s_axis_a_tready <= 0;
			s_axis_b_tready <= 0;
			m_axis_tuser <= 0;
		end else begin
			m_axis_tlast <= s_axis_a_tlast | s_axis_b_tlast;
			s_axis_a_tready <= m_axis_tready;
			s_axis_b_tready <= m_axis_tready;
			m_axis_tuser <= {s_axis_a_tuser,s_axis_b_tuser};
			m_axis_tvalid <= load_data;
			if(load_data)begin
				m_axis_tdata <= result;
			end else begin
				m_axis_tdata <= m_axis_tdata;
			end
		end
		
	end
	
	
	genvar i, j;
	generate
		for(i = 0; i < MAT_HEIGHT; i = i + 1)begin
			for(j = 0; j < MAT_WIDTH; j = j + 1)begin
				complex_adder #(.ELEMENT_SIZE(ELEMENT_SIZE)) adder(.a(s_axis_a_tdata[(i * MAT_WIDTH + j + 1) * ELEMENT_SIZE - 1 : (i * MAT_WIDTH + j) * ELEMENT_SIZE]),
							  .b(s_axis_b_tdata[(i * MAT_WIDTH + j + 1) * ELEMENT_SIZE - 1 : (i * MAT_WIDTH + j) * ELEMENT_SIZE]),
							  .sum(result[(i * MAT_WIDTH + j + 1) * ELEMENT_SIZE - 1 : (i * MAT_WIDTH + j) * ELEMENT_SIZE])
							  );
			end
		end
	endgenerate
	
endmodule
	
		
				