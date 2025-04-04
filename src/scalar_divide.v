`timescale 1ns/1ps



module scalar_complex_divider #(ELEMENT_SIZE = 32, SCALAR = 256)(
	input[ELEMENT_SIZE-1:0] a,
	output reg[ELEMENT_SIZE-1:0] quotient
	);
	
	reg[ELEMENT_SIZE/2 - 1 : 0] real_value, imag_value;
	always@(*)begin
		real_value <= $signed(a[ELEMENT_SIZE/2 - 1 : 0]) / SCALAR;
		imag_value <= $signed(a[ELEMENT_SIZE-1:ELEMENT_SIZE/2])/SCALAR;
		quotient <= {imag_value, real_value};
	end
	
endmodule


module scalar_divide #(
	parameter MAT_WIDTH = 4,
	parameter MAT_HEIGHT = 4,
	parameter ELEMENT_SIZE = 32,
	parameter SCALAR = 256
	) (
	input clk, reset_n,
	input [MAT_WIDTH * MAT_HEIGHT * ELEMENT_SIZE - 1:0] s_axis_tdata,
	output reg[MAT_WIDTH * MAT_HEIGHT * ELEMENT_SIZE - 1:0] m_axis_tdata,
	input s_axis_tvalid, s_axis_tlast, s_axis_tuser, m_axis_tready,
	output reg s_axis_tready, m_axis_tvalid, m_axis_tlast, m_axis_tuser
	);
	
	
	wire load_data;
	assign load_data = s_axis_tvalid & s_axis_tready  & reset_n;
	wire[MAT_WIDTH * MAT_HEIGHT * ELEMENT_SIZE - 1:0] result;
	
	always@(posedge clk or negedge reset_n)begin
		if(!reset_n)begin
			m_axis_tdata <= 0;
			m_axis_tlast <= 0;
			s_axis_tready <= 0;
			m_axis_tuser <= 0;
			m_axis_tvalid <= 0;
		end else begin
			m_axis_tlast <= s_axis_tlast;
			s_axis_tready <= m_axis_tready;
			m_axis_tuser <= s_axis_tuser;
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
				scalar_complex_divider #(.ELEMENT_SIZE(ELEMENT_SIZE), .SCALAR(SCALAR)) 
				divider(.a(s_axis_tdata[(i * MAT_WIDTH + j + 1) * ELEMENT_SIZE - 1 : (i * MAT_WIDTH + j) * ELEMENT_SIZE]),
							  .quotient(result[(i * MAT_WIDTH + j + 1) * ELEMENT_SIZE - 1 : (i * MAT_WIDTH + j) * ELEMENT_SIZE])
							  );
			end
		end
	endgenerate
	
endmodule