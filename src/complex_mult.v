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






module complex_matrix_multiplier(
	input clk, reset_n, clken,
	input s_axis_tvalid, s_axis_tlast, s_axis_tuser,
	input m_axis_dout_tready,
	output reg m_axis_dout_tvalid, s_axis_tready, m_axis_dout_tlast, 
	output reg [1:0] m_axis_dout_tuser,
	
	input[31:0] channel_0_base,
	input[31:0] channel_1_base,
	input[31:0] channel_2_base,
	input[31:0] channel_3_base,
	
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
	
	wire[63:0] next_result_matrix_0_0;
	wire[63:0] next_result_matrix_0_1;
	wire[63:0] next_result_matrix_0_2;
	wire[63:0] next_result_matrix_0_3;
	wire[63:0] next_result_matrix_1_0;
	wire[63:0] next_result_matrix_1_1;
	wire[63:0] next_result_matrix_1_2;
	wire[63:0] next_result_matrix_1_3;
	wire[63:0] next_result_matrix_2_0;
	wire[63:0] next_result_matrix_2_1;
	wire[63:0] next_result_matrix_2_2;
	wire[63:0] next_result_matrix_2_3;
	wire[63:0] next_result_matrix_3_0;
	wire[63:0] next_result_matrix_3_1;
	wire[63:0] next_result_matrix_3_2;
	wire[63:0] next_result_matrix_3_3;
	
	wire m_axis_dout_tvalid_0_0;
	wire m_axis_dout_tvalid_0_1;
	wire m_axis_dout_tvalid_0_2;
	wire m_axis_dout_tvalid_0_3;
	wire m_axis_dout_tvalid_1_0;
	wire m_axis_dout_tvalid_1_1;
	wire m_axis_dout_tvalid_1_2;
	wire m_axis_dout_tvalid_1_3;
	wire m_axis_dout_tvalid_2_0;
	wire m_axis_dout_tvalid_2_1;
	wire m_axis_dout_tvalid_2_2;
	wire m_axis_dout_tvalid_2_3;
	wire m_axis_dout_tvalid_3_0;
	wire m_axis_dout_tvalid_3_1;
	wire m_axis_dout_tvalid_3_2;
	wire m_axis_dout_tvalid_3_3;
	
	wire[1:0] m_axis_dout_tuser_0_0;
	wire[1:0] m_axis_dout_tuser_0_1;
	wire[1:0] m_axis_dout_tuser_0_2;
	wire[1:0] m_axis_dout_tuser_0_3;
	wire[1:0] m_axis_dout_tuser_1_0;
	wire[1:0] m_axis_dout_tuser_1_1;
	wire[1:0] m_axis_dout_tuser_1_2;
	wire[1:0] m_axis_dout_tuser_1_3;
	wire[1:0] m_axis_dout_tuser_2_0;
	wire[1:0] m_axis_dout_tuser_2_1;
	wire[1:0] m_axis_dout_tuser_2_2;
	wire[1:0] m_axis_dout_tuser_2_3;
	wire[1:0] m_axis_dout_tuser_3_0;
	wire[1:0] m_axis_dout_tuser_3_1;
	wire[1:0] m_axis_dout_tuser_3_2;
	wire[1:0] m_axis_dout_tuser_3_3;
	
	
	assign s_axis_a_tvalid = s_axis_tvalid & s_axis_tready; //The entire system pauses if one cmpy is not ready
	assign s_axis_b_tvalid = s_axis_tvalid & s_axis_tready; //The entire system pauses if one cmpy is not ready
	
	
	
/*	
	assign s_axis_a_tready =s_axis_a_tready_0_0 &
							s_axis_a_tready_0_1 &
							s_axis_a_tready_0_2 &
							s_axis_a_tready_0_3 &
							s_axis_a_tready_1_0 &
							s_axis_a_tready_1_1 &
							s_axis_a_tready_1_2 &
							s_axis_a_tready_1_3 &
							s_axis_a_tready_2_0 &
							s_axis_a_tready_2_1 &
							s_axis_a_tready_2_2 &
							s_axis_a_tready_2_3 &
							s_axis_a_tready_3_0 &
							s_axis_a_tready_3_1 &
							s_axis_a_tready_3_2 &
							s_axis_a_tready_3_3;
								
	assign s_axis_b_tready =s_axis_b_tready_0_0 &
							s_axis_b_tready_0_1 &
							s_axis_b_tready_0_2 &
							s_axis_b_tready_0_3 &
							s_axis_b_tready_1_0 &
							s_axis_b_tready_1_1 &
							s_axis_b_tready_1_2 &
							s_axis_b_tready_1_3 &
							s_axis_b_tready_2_0 &
							s_axis_b_tready_2_1 &
							s_axis_b_tready_2_2 &
							s_axis_b_tready_2_3 &
							s_axis_b_tready_3_0 &
							s_axis_b_tready_3_1 &
							s_axis_b_tready_3_2 &
							s_axis_b_tready_3_3;
							
	assign s_axis_tready = s_axis_a_tready & s_axis_b_tready; // Ready when all mults are ready

	*/
	
	always@(*) s_axis_tready = s_axis_a_tready_0_0 & s_axis_b_tready_0_0; //Assume all have the same ready.
	
	
	wire[31:0] channel_0_conj, channel_1_conj, channel_2_conj, channel_3_conj;
	assign channel_0_conj = {~channel_0_base[31:16] + 1, channel_0_base[15:0]};
	assign channel_1_conj = {~channel_1_base[31:16] + 1, channel_1_base[15:0]};
	assign channel_2_conj = {~channel_2_base[31:16] + 1, channel_2_base[15:0]};
	assign channel_3_conj = {~channel_3_base[31:16] + 1, channel_3_base[15:0]};

	
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
			m_axis_dout_tvalid <= 0;
			m_axis_dout_tuser  <= 0;
			m_axis_dout_tlast  <= 0;
		end
		else begin
	
			result_matrix_0_0 <= m_axis_dout_tvalid_0_0 ? {(result_matrix_0_0[63:32] + next_result_matrix_0_0[63:32]),(result_matrix_0_0[31:0] + next_result_matrix_0_0[31:0])}: {result_matrix_0_0};
			result_matrix_0_1 <= m_axis_dout_tvalid_0_1 ? {(result_matrix_0_1[63:32] + next_result_matrix_0_1[63:32]),(result_matrix_0_1[31:0] + next_result_matrix_0_1[31:0])}: {result_matrix_0_1};
			result_matrix_0_2 <= m_axis_dout_tvalid_0_2 ? {(result_matrix_0_2[63:32] + next_result_matrix_0_2[63:32]),(result_matrix_0_2[31:0] + next_result_matrix_0_2[31:0])}: {result_matrix_0_2};
			result_matrix_0_3 <= m_axis_dout_tvalid_0_3 ? {(result_matrix_0_3[63:32] + next_result_matrix_0_3[63:32]),(result_matrix_0_3[31:0] + next_result_matrix_0_3[31:0])}: {result_matrix_0_3};
			result_matrix_1_0 <= m_axis_dout_tvalid_1_0 ? {(result_matrix_1_0[63:32] + next_result_matrix_1_0[63:32]),(result_matrix_1_0[31:0] + next_result_matrix_1_0[31:0])}: {result_matrix_1_0};
			result_matrix_1_1 <= m_axis_dout_tvalid_1_1 ? {(result_matrix_1_1[63:32] + next_result_matrix_1_1[63:32]),(result_matrix_1_1[31:0] + next_result_matrix_1_1[31:0])}: {result_matrix_1_1};
			result_matrix_1_2 <= m_axis_dout_tvalid_1_2 ? {(result_matrix_1_2[63:32] + next_result_matrix_1_2[63:32]),(result_matrix_1_2[31:0] + next_result_matrix_1_2[31:0])}: {result_matrix_1_2};
			result_matrix_1_3 <= m_axis_dout_tvalid_1_3 ? {(result_matrix_1_3[63:32] + next_result_matrix_1_3[63:32]),(result_matrix_1_3[31:0] + next_result_matrix_1_3[31:0])}: {result_matrix_1_3};
			result_matrix_2_0 <= m_axis_dout_tvalid_2_0 ? {(result_matrix_2_0[63:32] + next_result_matrix_2_0[63:32]),(result_matrix_2_0[31:0] + next_result_matrix_2_0[31:0])}: {result_matrix_2_0};
			result_matrix_2_1 <= m_axis_dout_tvalid_2_1 ? {(result_matrix_2_1[63:32] + next_result_matrix_2_1[63:32]),(result_matrix_2_1[31:0] + next_result_matrix_2_1[31:0])}: {result_matrix_2_1};
			result_matrix_2_2 <= m_axis_dout_tvalid_2_2 ? {(result_matrix_2_2[63:32] + next_result_matrix_2_2[63:32]),(result_matrix_2_2[31:0] + next_result_matrix_2_2[31:0])}: {result_matrix_2_2};
			result_matrix_2_3 <= m_axis_dout_tvalid_2_3 ? {(result_matrix_2_3[63:32] + next_result_matrix_2_3[63:32]),(result_matrix_2_3[31:0] + next_result_matrix_2_3[31:0])}: {result_matrix_2_3};
			result_matrix_3_0 <= m_axis_dout_tvalid_3_0 ? {(result_matrix_3_0[63:32] + next_result_matrix_3_0[63:32]),(result_matrix_3_0[31:0] + next_result_matrix_3_0[31:0])}: {result_matrix_3_0};
			result_matrix_3_1 <= m_axis_dout_tvalid_3_1 ? {(result_matrix_3_1[63:32] + next_result_matrix_3_1[63:32]),(result_matrix_3_1[31:0] + next_result_matrix_3_1[31:0])}: {result_matrix_3_1};
			result_matrix_3_2 <= m_axis_dout_tvalid_3_2 ? {(result_matrix_3_2[63:32] + next_result_matrix_3_2[63:32]),(result_matrix_3_2[31:0] + next_result_matrix_3_2[31:0])}: {result_matrix_3_2};
			result_matrix_3_3 <= m_axis_dout_tvalid_3_3 ? {(result_matrix_3_3[63:32] + next_result_matrix_3_3[63:32]),(result_matrix_3_3[31:0] + next_result_matrix_3_3[31:0])}: {result_matrix_3_3};
			
			
			m_axis_dout_tvalid <= m_axis_dout_tvalid_0_0 & m_axis_dout_tlast_0_0;
			m_axis_dout_tuser  <= m_axis_dout_tuser_0_0;
			m_axis_dout_tlast  <= m_axis_dout_tlast_0_0;
		end
	end


cmpy_0 x_complex_multiplier_0_0 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_0_0), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_0_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_0_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_0_0), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_0_0),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_0_0),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_0_0),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_0_0)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_0_1 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_0_1), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_0_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_1_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_0_1), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_0_1),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_0_1),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_0_1),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_0_1)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_0_2 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_0_2), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_0_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_2_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_0_2), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_0_2),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_0_2),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_0_2),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_0_2)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_0_3 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_0_3), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_0_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_3_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_0_3), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_0_3),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_0_3),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_0_3),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_0_3)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_1_0 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_1_0), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_1_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_0_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_1_0), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_1_0),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_1_0),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_1_0),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_1_0)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_1_1 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_1_1), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_1_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_1_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_1_1), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_1_1),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_1_1),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_1_1),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_1_1)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_1_2 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_1_2), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_1_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_2_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_1_2), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_1_2),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_1_2),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_1_2),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_1_2)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_1_3 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_1_3), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_1_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_3_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_1_3), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_1_3),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_1_3),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_1_3),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_1_3)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_2_0 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_2_0), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_2_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_0_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_2_0), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_2_0),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_2_0),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_2_0),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_2_0)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_2_1 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_2_1), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_2_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_1_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_2_1), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_2_1),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_2_1),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_2_1),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_2_1)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_2_2 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_2_2), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_2_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_2_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_2_2), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_2_2),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_2_2),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_2_2),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_2_2)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_2_3 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_2_3), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_2_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_3_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_2_3), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_2_3),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_2_3),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_2_3),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_2_3)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_3_0 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_3_0), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_3_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_0_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_3_0), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_3_0),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_3_0),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_3_0),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_3_0)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_3_1 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_3_1), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_3_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_1_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_3_1), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_3_1),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_3_1),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_3_1),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_3_1)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_3_2 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_3_2), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_3_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_2_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_3_2), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_3_2),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_3_2),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_3_2),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_3_2)   // output wire m_axis_dout_tlast
);
cmpy_0 x_complex_multiplier_3_3 (
  .aclk(clk),                              // input wire aclk
  .aresetn(reset_n),                       // input wire aresetn
  .aclken(clken),                           // input wire aclken

  .s_axis_a_tvalid(s_axis_a_tvalid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready_3_3), // output wire s_axis_a_tready
  .s_axis_a_tdata(channel_3_base),        // input wire [31 : 0] s_axis_a_tdata

  .s_axis_a_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_a_tuser
  .s_axis_a_tlast(s_axis_tlast),            // input wire s_axis_a_tlast

  .s_axis_b_tdata(channel_3_conj),        // input wire [31 : 0] s_axis_b_tdata
  .s_axis_b_tready(s_axis_b_tready_3_3), // output wire s_axis_b_tready
  .s_axis_b_tvalid(s_axis_b_tvalid),        // input wire s_axis_b_tvalid

  .s_axis_b_tuser(s_axis_tuser),            // input wire [0 : 0] s_axis_b_tuser
  .s_axis_b_tlast(s_axis_tlast),            // input wire s_axis_b_tlast

  .m_axis_dout_tvalid(m_axis_dout_tvalid_3_3),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(next_result_matrix_3_3),    // output wire [63 : 0] m_axis_dout_tdata

  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tuser(m_axis_dout_tuser_3_3),    // output wire [1 : 0] m_axis_dout_tuser
  .m_axis_dout_tlast(m_axis_dout_tlast_3_3)   // output wire m_axis_dout_tlast
);




endmodule
