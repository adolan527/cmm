`timescale 1ns/1ps

`define MATRIX_A_PATH 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/adder/test2/matrix_a.txt"
`define MATRIX_B_PATH 	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/adder/test2/matrix_b.txt"
`define RESULT_PATH  	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/adder/test2/verilog_result.txt"
`define READABLE_PATH	"C:/Users/Aweso/Verilog/Aquapack/cmm/sim/adder/test2/readable_result.txt"



module complex_matrix_adder_tb();

localparam rows = 4;
localparam cols = 4;
localparam element_size = 32;
localparam half_size = 16; //hard-coded element_size/2.

reg clk, reset_n;
wire[rows * cols * element_size - 1:0] dina, dinb, dout;
reg[element_size-1:0] dina_mem[rows * cols-1 : 0], dinb_mem[rows * cols -1 : 0];
reg s_axis_a_tvalid, s_axis_b_tvalid, m_axis_tready;
	
complex_matrix_adder_parallel #(
	.MAT_WIDTH(cols), .MAT_HEIGHT(rows),.ELEMENT_SIZE(element_size))
	
dut(
	.clk(clk),.reset_n(reset_n), //in
	.s_axis_a_tdata(dina), //in
	.s_axis_b_tdata(dinb), //in
	.m_axis_tdata(dout), //out
	.s_axis_a_tvalid(s_axis_a_tvalid), //in
	.s_axis_b_tvalid(s_axis_b_tvalid), //in
	.s_axis_a_tlast(m_axis_a_tlast), //in
	.s_axis_b_tlast(s_axis_b_tlast), //in
	.s_axis_a_tuser(s_axis_a_tuser), //in
	.s_axis_b_tuser(s_axis_b_tuser), //in
	.m_axis_tready(m_axis_tready), //out
	.s_axis_a_tready(s_axis_a_tready), //out
	.s_axis_b_tready(s_axis_b_tready), //out
	.m_axis_tvalid(m_axis_tvalid), //out
	.m_axis_tlast(m_axis_tlast), //out
	.m_axis_tuser(m_axis_tuser)//out
);



always #5 clk = ~clk;

task init();
begin
	$readmemh(`MATRIX_A_PATH,dina_mem);
	$readmemh(`MATRIX_B_PATH,dinb_mem);
end
endtask

integer resultCount = 0;
integer resultFile;

task saveResults;
    integer i, j;
    integer idx;  // A new variable to store the calculated index
begin
    resultFile = $fopen(`READABLE_PATH, "w");
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(dout[(0) * element_size + half_size - 1 : 0 * element_size]), $signed(dout[(0 + 1) * element_size - 1 :half_size +  (0) * element_size]),
																			$signed(dout[(1) * element_size + half_size - 1 : 1 * element_size]), $signed(dout[(1 + 1) * element_size - 1 :half_size +  (1) * element_size]),
																			$signed(dout[(2) * element_size + half_size - 1 : 2 * element_size]), $signed(dout[(2 + 1) * element_size - 1 :half_size +  (2) * element_size]),
																			$signed(dout[(3) * element_size + half_size - 1 : 3 * element_size]), $signed(dout[(3 + 1) * element_size - 1 :half_size +  (3) * element_size]));
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(dout[(4) * element_size + half_size - 1 : 4 * element_size]), $signed(dout[(4 + 1) * element_size - 1 :half_size +  (4) * element_size]),
																			$signed(dout[(5) * element_size + half_size - 1 : 5 * element_size]), $signed(dout[(5 + 1) * element_size - 1 :half_size +  (5) * element_size]),
																			$signed(dout[(6) * element_size + half_size - 1 : 6 * element_size]), $signed(dout[(6 + 1) * element_size - 1 :half_size +  (6) * element_size]),
																			$signed(dout[(7) * element_size + half_size - 1 : 7 * element_size]), $signed(dout[(7 + 1) * element_size - 1 :half_size +  (7) * element_size]));
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(dout[(8) * element_size + half_size - 1 : 8 * element_size]), $signed(dout[(8 + 1) * element_size - 1 :half_size +  (8) * element_size]),
																			$signed(dout[(9) * element_size + half_size - 1 : 9 * element_size]), $signed(dout[(9 + 1) * element_size - 1 :half_size +  (9) * element_size]),
																			$signed(dout[(10) * element_size + half_size - 1 : 10 * element_size]), $signed(dout[(10 + 1) * element_size - 1 : half_size + (10) * element_size]),
																			$signed(dout[(11) * element_size + half_size - 1 : 11 * element_size]), $signed(dout[(11 + 1) * element_size - 1 : half_size + (11) * element_size]));
	$fwrite(resultFile, "%d + j%d \t %d + j%d \t %d + j%d \t %d + j%d \n", 	$signed(dout[(12) * element_size + half_size - 1 : 12 * element_size]), $signed(dout[(12 + 1) * element_size - 1 : half_size + (12) * element_size]),
																			$signed(dout[(13) * element_size + half_size - 1 : 13 * element_size]), $signed(dout[(13 + 1) * element_size - 1 : half_size + (13) * element_size]),
																			$signed(dout[(14) * element_size + half_size - 1 : 14 * element_size]), $signed(dout[(14 + 1) * element_size - 1 : half_size + (14) * element_size]),
																			$signed(dout[(15) * element_size + half_size - 1 : 15 * element_size]), $signed(dout[(15 + 1) * element_size - 1 : half_size + (15) * element_size]));																			

    $fclose(resultFile); 

    resultFile = $fopen(`RESULT_PATH, "w");
    for (i = 0; i < rows; i = i + 1) begin
        for (j = 0; j < cols; j = j + 1) begin
            // Calculate the index
            idx = (i * cols + j) * element_size;
			//$display(i,j,idx);
            $fwrite(resultFile, "%h\n", dout[idx +: element_size]);
        end
    end
    $fclose(resultFile);
end
endtask



genvar k, l;
generate
    for(k = 0; k < rows; k = k + 1) begin
        for(l = 0; l < cols; l = l + 1) begin
            // Use direct indexing instead of range-based part-select
            assign dina[(k * cols + l + 1) * element_size - 1 : (k * cols + l) * element_size] = 
                dina_mem[k * cols + l][element_size-1:0];
			assign dinb[(k * cols + l + 1) * element_size - 1 : (k * cols + l) * element_size] = 
                dinb_mem[k * cols + l][element_size-1:0];
        end
    end
endgenerate

initial begin
	
	#10 clk = 0; reset_n = 0;
	#10 reset_n = 1; init();
	#20 s_axis_a_tvalid = 1; s_axis_b_tvalid = 1; m_axis_tready = 1;
	#20 s_axis_a_tvalid = 0;
	#10 saveResults();
end

endmodule