# Bartlett datapath sans FFT

Notes
- p_theta can be computed using less multiplication through the method described in bartlett optimization/bartlett.m.
This makes the p_theta calculation rxx .*  CONSTANT. It is notable that this constant will have 0 imaginary component along the diagonals.
rxx is a 4x4 matrix with real diagonals as well, meaning that the diagonal values can be computed without any complex multiplication.
The same complex multipliers used to calculate rxx could be reused in this calculation.

## File Structure

	
	master/
	├── src/
	│   ├── bartlett.v
	│   ├── common.v	
	│   ├── complex_mult.v	
	│   ├── complex_mult_1_mult.v	
	│   ├── matrix_adder.v	
	│   ├── mult.v	
	│   ├── p_theta.v	
	│   ├── rxx.v	
	│   ├── scalar_divide.v	
	│   └── top.v
	├── sim/ # Varies for each module
	│     ├── single_test_tb.v
	│     └── MODULE_NAME /
	│         ├── MODULE_NAME_tb.v
	│         ├── oracle.m
	│         ├── sim.bat
	│         └── TESTNAME/
	│             ├── INPUT_DATA
	│             ├── oracle.m
	│             └── OUTPUT_DATA
    └── bartlett optimization 
	    ├── bartlett.m
	    ├── bartlett.csv
	    └── bartlett.xlsx
		
### src
| File | Description |
| -------- | ------- |
| [bartlett.v](https://github.com/adolan527/cmm/blob/main/bartlett.v) | Top-level module instantiating rxx and p_theta. AXI interface to FFT. |
| [common.v](https://github.com/adolan527/cmm/blob/main/common.v) | Commonly used modules. (complex adder, shift register, etc. |
| [complex_mult.v](https://github.com/adolan527/cmm/blob/main/complex_mult.v) | 256x4 complex matrix multiplied by its conjugate transpose. Similar structure to mult.v. |
| [complex_mult_1_mult.v](https://github.com/adolan527/cmm/blob/main/complex_mult_1_mult.v) | Complex multiplication used in p_theta. Only 1 complex mult IP core. |
| [matrix_adder.v](https://github.com/adolan527/cmm/blob/main/matrix_adder.v) | Performs element-wise matrix addition. Implemented and tested, but found to be unneccessary. |
| [mult.v](https://github.com/adolan527/cmm/blob/main/mult.v) | 256x4 matrix multiplied by its transpose. |
| [p_theta.v](https://github.com/adolan527/cmm/blob/main/p_theta.v) | Outputs P(theta), with the inputs being rxx and theta. Controller will likely give theta value. |
| [rxx.v](https://github.com/adolan527/cmm/blob/main/rxx.v) | Outputs rxx from IFFT output. Contains complex_mult and scalar_divide. |
| [scalar_divide.v](https://github.com/adolan527/cmm/blob/main/scalar_divide.v) | Used in rxx to divide by a constant scalar value. |
| [top.v](https://github.com/adolan527/cmm/blob/main/top.v) | Instantiation of all major modules to allow for easy inspection with elaborated design. |





## The following information only applies to cmm tests. Generally applicable but details may vary.

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


