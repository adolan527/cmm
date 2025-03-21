# Complex Matrix Multiplier

Takes in a 256x4 matrix of 32 bit complex integers, returns the matrix times its conjugate transpose.

## Issues

1. The imaginary parts should be 0, but due to (what I assume is) rounding errors there are some values in there a roughly 
100x smaller than the real values in the non-diagonal indices.  Should the imaginary part be manually zeroed out? This would allow 
for optimizations, potentially reducing the amount of DSP slices used.

5. The real values are roughly 1/2 of the MATLAB values. 
I am unsure of the reason, but a bit shift would fix this and be trivial. 
The next module in the pipeline is Matrix addition, then scalar division by 256, so it might 
be better to not scale it up before addition, then scale down the matrix it is being added to by 1/2, 
and then scalar divide by 128. This would reduce overflow.

12. Additionally, the complex multiplier's minimum size for a float is 32 bit, (32 imag, 32 real). 
Right now, the implementation uses 16 bit 2's complement (16 imag, 16 real). Changing it would be trivial, 
but I forget what data type the IFFT outputs, but if the IFFT outputs float16, then they will have to be converted to 
float32 or int16.



## File Structure

	
	master/
	├── src/
	│   ├── complex_mult.v
	│   ├── mult.v	
	└── sim/
	    ├── single_test_tb.v
	    ├── cmm_tb.v
	    ├── oracle.m
	    ├── sim.bat
	    └── TESTNAME/
	    	├── channel1.txt
	    	├── channel2.txt
	    	├── channel3.txt
	    	├── channel4.txt
	    	├── oracle.m
	    	├── verilog_result.txt
	    	├── readable_result.txt
	    	├── matlab_result.txt
	    	└── matlab_readable_result.txt
	 
	



### src
| File | Description |
| -------- | ------- |
| [mult.v](https://github.com/adolan527/cmm/blob/main/mult.v) | 256x4 matrix multiplied by its transpose. |
| [complex_mult.v](https://github.com/adolan527/cmm/blob/main/complex_mult.v) | 256x4 complex matrix multiplied by its hermitian transpose. Similar structure to mult.v |


### sim

| File | Description |
| -------- | ------- |
| [single_test_tb.v](https://github.com/adolan527/cmm/blob/main/sim/single_test_tb.v) | Testbench used to verify complex multiplier's AXI4 communication. |
| [cmm_tb.v](https://github.com/adolan527/cmm/blob/main/sim/cmm_tb.v) | Testbench that feeds matlab output into Vivado simulation. |
| [oracle.m](https://github.com/adolan527/cmm/blob/main/sim/oracle.m) | Matlab script that generates channel data for testbench, and produces the correct output of the matrix multiplication. |
| [sim.bat](https://github.com/adolan527/cmm/blob/main/sim/sim.bat) | Creates directory and runs matlab script |

#### TESTNAME

| File | Description |
| -------- | ------- |
| [channel1.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/channel1.txt) | Channel/row 1 of matrix |
| [channel2.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/channel2.txt) | Channel/row 2 of matrix |
| [channel3.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/channel3.txt) | Channel/row 3 of matrix |
| [channel4.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/channel4.txt) | Channel/row 4 of matrix |
| [oracle.m](https://github.com/adolan527/cmm/blob/main/sim/eight/oracle.m) | Copied into dir to allow for editing of parameters and easier scripting |
| [verilog_result.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/verilog_result.txt) | Resulting matrix from Verilog Simulation in hex format |
| [readable_result.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/readable_result.txt) | Resulting matrix from Verilog Simulation in cartesian format |
| [matlab_result.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/matlab_result.txt) | Resulting matrix from MATLAB in hex format |
| [matlab_readable_result.txt](https://github.com/adolan527/cmm/blob/main/sim/eight/matlab_readable_result.txt) | Resulting matrix from MATLAB in cartesian format |

