`timescale 1ns / 1ps

`define COLUMNS 256
`define ROWS 4

`define CHANNELPATH0 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/mult_zero/test_2/channel1.txt"
`define CHANNELPATH1 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/mult_zero/test_2/channel2.txt"
`define CHANNELPATH2 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/mult_zero/test_2/channel3.txt"
`define CHANNELPATH3 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/mult_zero/test_2/channel4.txt"
`define RESULT_PATH  	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/mult_zero/test_2/verilog_result.txt"
`define READABLE_PATH	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/mult_zero/test_2/readable_result.txt"


// Two hacks:
// Bit shift output to double



module cmm_zero_tb();



reg  clk, reset_n, clken, s_axis_tvalid, s_axis_tlast, s_axis_tuser, m_axis_dout_tready;
reg[31:0]  channel_0_base, channel_1_base, channel_2_base, channel_3_base;
wire s_axis_tready, m_axis_dout_tlast, m_axis_dout_tvalid;
wire[1:0] m_axis_dout_tuser;
wire[63:0]  result_matrix_3_3,
			result_matrix_3_2,
			result_matrix_3_1,
			result_matrix_3_0,
			result_matrix_2_3,
			result_matrix_2_2,
			result_matrix_2_1,
			result_matrix_2_0,
			result_matrix_1_3,
			result_matrix_1_2,
			result_matrix_1_1,
			result_matrix_1_0,
			result_matrix_0_3,
			result_matrix_0_2,
			result_matrix_0_1,
			result_matrix_0_0;

complex_matrix_multiplier_zeroed complex_matrix_multiplier_inst(
 .clk(clk),           //input
 .reset_n(reset_n),   //input
 .clken(clken),       //input
 
 .s_axis_tvalid(s_axis_tvalid),   //input
 .s_axis_tlast(s_axis_tlast),     //input
 .s_axis_tuser(s_axis_tuser),     //input
 .s_axis_tready(s_axis_tready),   //output
 
 .m_axis_dout_tuser(m_axis_dout_tuser),      //output
 .m_axis_dout_tlast(m_axis_dout_tlast),      //output
 .m_axis_dout_tvalid(m_axis_dout_tvalid),    //output
 .m_axis_dout_tready(m_axis_dout_tready), 	 //input

 
 .channel_0_base(channel_0_base),   //input
 .channel_1_base(channel_1_base),   //input
 .channel_2_base(channel_2_base),   //input
 .channel_3_base(channel_3_base),   //input
 
 .result_matrix_0_0(result_matrix_0_0),   // output
 .result_matrix_0_1(result_matrix_0_1),   // output
 .result_matrix_0_2(result_matrix_0_2),   // output
 .result_matrix_0_3(result_matrix_0_3),   // output
 .result_matrix_1_0(result_matrix_1_0),   // output
 .result_matrix_1_1(result_matrix_1_1),   // output
 .result_matrix_1_2(result_matrix_1_2),   // output
 .result_matrix_1_3(result_matrix_1_3),   // output
 .result_matrix_2_0(result_matrix_2_0),   // output
 .result_matrix_2_1(result_matrix_2_1),   // output
 .result_matrix_2_2(result_matrix_2_2),   // output
 .result_matrix_2_3(result_matrix_2_3),   // output
 .result_matrix_3_0(result_matrix_3_0),   // output
 .result_matrix_3_1(result_matrix_3_1),   // output
 .result_matrix_3_2(result_matrix_3_2),   // output
 .result_matrix_3_3(result_matrix_3_3)    // output
 );

integer index;
reg[31:0] channel_0[`COLUMNS:0], channel_1[`COLUMNS:0], channel_2[`COLUMNS:0], channel_3[`COLUMNS:0];

task initMemory;
begin
	$readmemh(`CHANNELPATH0,channel_0);
	$readmemh(`CHANNELPATH1,channel_1);
	$readmemh(`CHANNELPATH2,channel_2);
	$readmemh(`CHANNELPATH3,channel_3);
end
endtask


integer i;
task sendMemory;
	for(i = 0; i < `COLUMNS + 1; i = i + 1)begin
		#10 index = index + 1;
	end
endtask


integer resultCount = 0;
integer resultFile;
task saveResults;
begin
	resultFile = $fopen(`RESULT_PATH,"w");
	$fwrite(resultFile, "%h %h %h %h\n", result_matrix_0_0, result_matrix_0_1, result_matrix_0_2, result_matrix_0_3);
	$fwrite(resultFile,"%h %h %h %h\n", result_matrix_1_0, result_matrix_1_1, result_matrix_1_2, result_matrix_1_3);
	$fwrite(resultFile,"%h %h %h %h\n", result_matrix_2_0, result_matrix_2_1, result_matrix_2_2, result_matrix_2_3);
	$fwrite(resultFile,"%h %h %h %h\n", result_matrix_3_0, result_matrix_3_1, result_matrix_3_2, result_matrix_3_3);
	$fclose(resultFile);
	resultFile = $fopen(`READABLE_PATH,"w");
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(result_matrix_0_0[31:0] ), $signed(result_matrix_0_0[63:32]), 
																			$signed(result_matrix_0_1[31:0] ), $signed(result_matrix_0_1[63:32]), 
																			$signed(result_matrix_0_2[31:0] ), $signed(result_matrix_0_2[63:32]), 
																			$signed(result_matrix_0_3[31:0] ), $signed(result_matrix_0_3[63:32]));
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(result_matrix_1_0[31:0] ), $signed(result_matrix_1_0[63:32]), 
																			$signed(result_matrix_1_1[31:0] ), $signed(result_matrix_1_1[63:32]), 
																			$signed(result_matrix_1_2[31:0] ), $signed(result_matrix_1_2[63:32]), 
																			$signed(result_matrix_1_3[31:0] ), $signed(result_matrix_1_3[63:32]));
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(result_matrix_2_0[31:0] ), $signed(result_matrix_2_0[63:32]), 
																			$signed(result_matrix_2_1[31:0] ), $signed(result_matrix_2_1[63:32]), 
																			$signed(result_matrix_2_2[31:0] ), $signed(result_matrix_2_2[63:32]), 
																			$signed(result_matrix_2_3[31:0] ), $signed(result_matrix_2_3[63:32]));
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(result_matrix_3_0[31:0] ), $signed(result_matrix_3_0[63:32]), 
																			$signed(result_matrix_3_1[31:0] ), $signed(result_matrix_3_1[63:32]), 
																			$signed(result_matrix_3_2[31:0] ), $signed(result_matrix_3_2[63:32]), 
																			$signed(result_matrix_3_3[31:0] ), $signed(result_matrix_3_3[63:32]));																			

	$fclose(resultFile);
end
endtask


always #5 clk = ~clk;

always #10 s_axis_tuser = s_axis_tuser + 1;



always@(*)begin

	channel_0_base = channel_0[index]; 
	channel_1_base = channel_1[index]; 
	channel_2_base = channel_2[index]; 
	channel_3_base = channel_3[index]; 
	
	if(index == `COLUMNS - 1) s_axis_tlast = 1;
	if(index == `COLUMNS) begin s_axis_tlast = 0; s_axis_tvalid = 0; end
	if(m_axis_dout_tvalid) saveResults();
	
end



initial begin
clk = 0; clken = 1; reset_n = 0; index = 0; s_axis_tlast = 0; s_axis_tvalid = 0; s_axis_tuser = 0;
#10 m_axis_dout_tready = 1;
#150 reset_n = 1;
#10 initMemory(); 
#10 sendMemory();

end

	


endmodule
	
	


