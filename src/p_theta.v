`timescale 1ns/1ps


`define MATRIX_SIZE 4
`define THETA_COUNT 19




module p_theta #(
	parameter NUM_SIZE = 32 //bits per complex number.EX: NUM_SIZE = 32. num = {imag_16,real_16}
	) (
	input clk, reset_n,
	
	// 4x4 matrix input channel
	input[`MATRIX_SIZE * `MATRIX_SIZE * NUM_SIZE - 1 : 0] s_axis_r_tdata, //MSB->LSB{channel_3, channel_2, channel_1, channel_0}
	input s_axis_r_tvalid, s_axis_r_tlast, s_axis_r_tuser, //tlast is overwritten
	output s_axis_r_tready,
	
	// theta input channel
	input[$clog2(`THETA_COUNT): 0] s_axis_theta_tdata, // theta_store[s_axis_theta_tdata] 
	input s_axis_theta_tvalid, s_axis_theta_tlast, s_axis_theta_tuser, //tlast is overwritten
	output s_axis_theta_tready,
	
	// 1x1 weight
	output[2 * NUM_SIZE - 1:0]  m_axis_tdata, 
	output m_axis_tvalid, m_axis_tuser, m_axis_tlast,
	input m_axis_tready	
	);
	
	reg[$clog2(`THETA_COUNT): 0] theta_buffer;
	reg[`MATRIX_SIZE * `MATRIX_SIZE * NUM_SIZE - 1 : 0] r_buffer;
	
	reg s_axis_r_tvalid_buf, s_axis_r_tlast_buf, s_axis_r_tuser_buf;
	reg s_axis_theta_tvalid_buf, s_axis_theta_tlast_buf, s_axis_theta_tuser_buf;
	
	always@(posedge clk or negedge reset_n)begin
		if(~reset_n) begin
			theta_buffer <= 0;
			r_buffer <= 0;
			s_axis_r_tvalid_buf <= 0;
			s_axis_r_tlast_buf <= 0;
			s_axis_r_tuser_buf <= 0;
			s_axis_theta_tvalid_buf <= 0;
			s_axis_theta_tlast_buf <= 0;
			s_axis_theta_tuser_buf <= 0;
		end
		else begin
			if(s_axis_theta_tready & s_axis_theta_tvalid) theta_buffer <= s_axis_theta_tdata;
			else theta_buffer <= theta_buffer;
			
			if(s_axis_r_tready & s_axis_r_tvalid) r_buffer <= s_axis_r_tdata;
			else r_buffer <= r_buffer;
			
			s_axis_r_tvalid_buf <= s_axis_r_tvalid;
			s_axis_r_tlast_buf <= s_axis_r_tlast;
			s_axis_r_tuser_buf <= s_axis_r_tuser;
			s_axis_theta_tvalid_buf <= s_axis_theta_tvalid;
			s_axis_theta_tlast_buf <= s_axis_theta_tlast;
			s_axis_theta_tuser_buf <= s_axis_theta_tuser;
			
		end
	end
	
	reg[`MATRIX_SIZE * `MATRIX_SIZE * NUM_SIZE - 1 : 0] s_sh_theta_matrix[`THETA_COUNT-1:0];
	wire[`MATRIX_SIZE * `MATRIX_SIZE * NUM_SIZE - 1 : 0] matrix_tdata;
	

complex_matrix_mult_1_mult #(
	.WIDTH(NUM_SIZE)
	) (
	.clk(clk),
	.reset_n(reset_n),
	
	.s_axis_r_tdata(r_buffer),
	.s_axis_r_tvalid(s_axis_r_tvalid_buf),
	.s_axis_r_tlast(s_axis_r_tlast_buf),
	.s_axis_r_tuser(s_axis_r_tuser_buf),
	.s_axis_r_tready(s_axis_r_tready),
	
	.s_axis_sh_tdata(s_sh_theta_matrix[theta_buffer]),
	.s_axis_sh_tvalid(s_axis_theta_tvalid_buf),
	.s_axis_sh_tlast(s_axis_theta_tlast_buf),
	.s_axis_sh_tuser(s_axis_theta_tuser_buf),
	.s_axis_sh_tready(s_axis_theta_tready),

	
	.m_axis_matrix_tdata(matrix_tdata),
	.m_axis_matrix_tvalid(matrix_tvalid),
	.m_axis_matrix_tlast(matrix_tlast),
	.m_axis_matrix_tuser(matrix_tuser),
	.m_axis_matrix_tready(matrix_tready)
	);
	
matrix_accumulator_no_latency #(
	.WIDTH(NUM_SIZE)
	) (
	.clk(clk),
	.reset_n(reset_n),
	
	.s_axis_tdata(matrix_tdata),
	.s_axis_tvalid(matrix_tvalid),
	.s_axis_tlast(matrix_tlast),
	.s_axis_tuser(matrix_tuser),
	.s_axis_tready(matrix_tready),
	
	
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tlast(m_axis_tlast),
	.m_axis_tuser(m_axis_tuser),
	.m_axis_tready(m_axis_tready)
	);

endmodule
