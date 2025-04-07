`timescale 1ns/1ps

`define MATRIX_SIZE 4


module rxx #(
	parameter NUM_SIZE = 32 //bits per complex number.EX: NUM_SIZE = 32. num = {imag_16,real_16}
	) (
	input clk, reset_n, clken,
	
	// 4x256 matrix input channel
	input[`MATRIX_SIZE * NUM_SIZE - 1 : 0] s_axis_tdata, //MSB->LSB{channel_3, channel_2, channel_1, channel_0}
	input s_axis_tvalid, s_axis_tlast, s_axis_tuser,
	output s_axis_tready,
	
	// 4 x 4 matrix output channel
	output[`MATRIX_SIZE * `MATRIX_SIZE * NUM_SIZE - 1:0]  m_axis_tdata, //MSB->LSB{r44, r43, r42... r00}
	output m_axis_tvalid, m_axis_tuser, m_axis_tlast,
	input m_axis_tready	
	);
	

// mult -> addition -> scalar divide
// complex_matrix_multiplier_zeroed -> scalar_divide_const

	
wire mid_tlast, mid_tvalid, mid_tuser;
wire[`MATRIX_SIZE * `MATRIX_SIZE * NUM_SIZE - 1: 0] mid_tdata; 
	
	
	
	
complex_matrix_multiplier_zeroed #(
	.SIZE(NUM_SIZE)
	)
complex_matrix_multiplier_zeroed_inst(
	.clk(clk),
	.reset_n(reset_n),
	.clken(clken),
	
	.channel_0_base(s_axis_tdata[0 * NUM_SIZE +: NUM_SIZE]),
	.channel_1_base(s_axis_tdata[1 * NUM_SIZE +: NUM_SIZE]),
	.channel_2_base(s_axis_tdata[2 * NUM_SIZE +: NUM_SIZE]),
	.channel_3_base(s_axis_tdata[3 * NUM_SIZE +: NUM_SIZE]),
	
	.s_axis_tvalid(s_axis_tvalid),
	.s_axis_tlast(s_axis_tlast),
	.s_axis_tuser(s_axis_tuser),
	.s_axis_tready(s_axis_tready),
	
	.m_axis_dout_tready(mid_tready),
	.m_axis_dout_tlast(mid_tlast),
	.m_axis_dout_tuser(mid_tuser),
	.m_axis_dout_tvalid(mid_tvalid),
	
	.result_matrix_0_0(mid_tdata[0 * NUM_SIZE * `MATRIX_SIZE + 0 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_0_1(mid_tdata[0 * NUM_SIZE * `MATRIX_SIZE + 1 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_0_2(mid_tdata[0 * NUM_SIZE * `MATRIX_SIZE + 2 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_0_3(mid_tdata[0 * NUM_SIZE * `MATRIX_SIZE + 3 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_1_0(mid_tdata[1 * NUM_SIZE * `MATRIX_SIZE + 0 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_1_1(mid_tdata[1 * NUM_SIZE * `MATRIX_SIZE + 1 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_1_2(mid_tdata[1 * NUM_SIZE * `MATRIX_SIZE + 2 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_1_3(mid_tdata[1 * NUM_SIZE * `MATRIX_SIZE + 3 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_2_0(mid_tdata[2 * NUM_SIZE * `MATRIX_SIZE + 0 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_2_1(mid_tdata[2 * NUM_SIZE * `MATRIX_SIZE + 1 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_2_2(mid_tdata[2 * NUM_SIZE * `MATRIX_SIZE + 2 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_2_3(mid_tdata[2 * NUM_SIZE * `MATRIX_SIZE + 3 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_3_0(mid_tdata[3 * NUM_SIZE * `MATRIX_SIZE + 0 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_3_1(mid_tdata[3 * NUM_SIZE * `MATRIX_SIZE + 1 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_3_2(mid_tdata[3 * NUM_SIZE * `MATRIX_SIZE + 2 * NUM_SIZE +: NUM_SIZE]),
    .result_matrix_3_3(mid_tdata[3 * NUM_SIZE * `MATRIX_SIZE + 3 * NUM_SIZE +: NUM_SIZE])
);

	
	
	
scalar_divide_const #(
	.MAT_HEIGHT(`MATRIX_SIZE),
	.MAT_WIDTH(`MATRIX_SIZE),
	.ELEMENT_SIZE(NUM_SIZE * 2),
	.SCALAR(128) // T = 256, however, complex matrix multipler outputs values halved currently.
	)
scalar_divide_const_inst(
	.clk(clk),
	.reset_n(reset_n),
	
	.s_axis_tdata(mid_tdata),
	.s_axis_tvalid(mid_tvalid),
	.s_axis_tlast(mid_tlast),
	.s_axis_tuser(mid_tuser),
	.s_axis_tready(mid_tready),
	
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tlast(m_axis_tlast),
	.m_axis_tuser(m_axis_tuser),
	.m_axis_tready(m_axis_tready)
);



endmodule

	