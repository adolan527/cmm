onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+cmpy_1  -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L xbip_pipe_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_18 -L cmpy_v6_0_21 -L xil_defaultlib -L secureip -O5 xil_defaultlib.cmpy_1

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {cmpy_1.udo}

run 1000ns

endsim

quit -force
