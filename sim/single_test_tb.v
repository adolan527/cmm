`timescale 1ns / 1ps



module single_test_tb();

reg clk;
reg[31:0] da,db;
wire[79:0] m_axis_dout_tdata;
wire[15:0] a_real, b_real, a_imag, b_imag;
wire[39:0] out_real, out_imag;
wire m_axis_dout_tvalid, s_axis_a_tready, s_axis_b_tready;
reg a_valid, b_valid, m_axis_dout_tready;
reg aresetn, aclken;




//----------- begin Cut here for INSTANTIATION Template ---// INST_TAG
cmpy_0 your_instance_name (
  .aclk(clk),                              // input wire aclk
  .aclken(aclken),                          // input wire aclken
  .aresetn(aresetn),                        // input wire aresetn
  
  .s_axis_a_tvalid(a_valid),        // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready),        // output wire s_axis_a_tready
  .s_axis_a_tdata(da),          // input wire [31 : 0] s_axis_a_tdata
  
  .s_axis_b_tvalid(b_valid),        // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready),        // output wire s_axis_b_tready
  .s_axis_b_tdata(db),          // input wire [31 : 0] s_axis_b_tdata
  
  .m_axis_dout_tvalid(m_axis_dout_tvalid),  // output wire m_axis_dout_tvalid
  .m_axis_dout_tready(m_axis_dout_tready),  // input wire m_axis_dout_tready
  .m_axis_dout_tdata(m_axis_dout_tdata)    // output wire [79 : 0] m_axis_dout_tdata
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

assign a_real = da[15:0];
assign b_real = db[15:0];
assign a_imag = da[31:16];
assign b_imag = db[31:16];
assign out_real = m_axis_dout_tdata[39:0];
assign out_imag = m_axis_dout_tdata[79:40];


always #5 clk = ~clk;

integer j;
task iterate;
begin
	for(j = 0; j < 100; j = j + 1)begin
		#10
		da[15:0] = j;
		db[15:0] = j + 1;
		da[31:16] = 0; db[31:16] = 0;
		if(j == 50) begin
			aclken = 0; #50
			aclken = 1;
		end
	end
end
endtask




initial begin
    clk = 0; aclken = 1; aresetn = 0; a_valid = 0; b_valid = 0;
	m_axis_dout_tready = 1;
    da = 32'd0;
    db = 32'd0;
    #20;

    // Provide data first, then assert valid signals
	aresetn = 1;
    da = 32'h00000000;
    db = 32'h00000000;
    #20;
    a_valid = 1;
    b_valid = 1;
    #10;
    
	da = 32'h00020001; //1 + 2j
	db = 32'hFFFC0003; //3 + -4j
	//Multiplication result: 11 + (2)j
    #10;

	da = 32'hFF380064; //100 + -200j
	db = 32'h0190012C; //300 + 400j
	//Multiplication result: -110000 + (-20000)j
    #10;

	da = 32'hFFFBFFFB; //-5 + -5j
	db = 32'hFFFBFFFB; //-5 + -5j
	//Multiplication result: 0 + (50)j
    #10;
	iterate();

    a_valid = 0;
    b_valid = 0;
end

endmodule
	
	


