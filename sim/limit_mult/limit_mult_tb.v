`timescale 1ns / 1ps

`define SIZE 4


`define R_MAT_PATH	 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/limit_mult/test_1/r_mat.txt"
`define SH_MAT_PATH 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/limit_mult/test_1/sh_mat.txt"
`define RESULT_PATH  	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/limit_mult/test_1/verilog_result.txt"
`define READABLE_PATH	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/limit_mult/test_1/readable_result.txt"


// Two hacks:
// Bit shift output to double
// Manually set imaginary values to zero.


module limit_mult_tb();

localparam WIDTH = 32;


reg  clk, reset_n;
reg[WIDTH * `SIZE * `SIZE - 1:0]  s_axis_r_tdata, s_axis_sh_tdata;
reg[WIDTH - 1:0] s_axis_d_tdata;
wire[WIDTH * `SIZE * `SIZE - 1:0] m_axis_tdata;



integer i, j, index;
complex_matrix_mult_4_mult #(.WIDTH(WIDTH))
dut(
.clk(clk),
.reset_n(reset_n),
.s_axis_r_tdata(s_axis_r_tdata),
.s_axis_d_tdata(s_axis_d_tdata),
.s_axis_sh_tdata(s_axis_sh_tdata),
.m_axis_tdata(m_axis_tdata),
.m_axis_sum_tdata(m_axis_sum_tdata)
);	

reg[WIDTH-1:0] send_r, send_sh, send_d;


task send;
	integer k;
	for(k = 0; k < `COLUMNS + 1; k = k + 1)begin
		#10 index = index + 1;
	end
endtask

task print;
begin
    for (i = 0; i < `SIZE; i = i + 1) begin
      $display("Row %0d: ", i);
      for (j = 0; j < `SIZE; j = j + 1) begin
        $display("  Element [%0d][%0d]: %h", i, j, m_axis_tdata[WIDTH * (i * `SIZE + j) +: WIDTH]);
      end
    end
end
endtask



always@(*)begin
	send_r = s_axis_r_tdata[WIDTH * (index) +: WIDTH];
	//send_d = s_axis_d_tdata[WIDTH * (index) +: WIDTH];
	send_sh = s_axis_sh_tdata[WIDTH * (index) +: WIDTH];
end


always #5 clk = ~clk;

initial begin
for(i = 0; i < `SIZE; i = i + 1)begin
	for(j = 0; j < `SIZE; j = j + 1)begin
		s_axis_r_tdata[WIDTH * (i * `SIZE + j) +: WIDTH] = {i+j};
		s_axis_sh_tdata[WIDTH * (i * `SIZE + j) +: WIDTH] = {i+j};
	end 
end
 clk = 0; reset_n = 0; s_axis_d_tdata = 1;
#10 reset_n = 1; print();
#10 print();
#10 print();
#150 reset_n = 0;

end

	


endmodule
	
	


