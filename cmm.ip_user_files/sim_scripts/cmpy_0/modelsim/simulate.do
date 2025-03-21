onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc "  -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L xbip_pipe_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_18 -L cmpy_v6_0_21 -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.cmpy_0

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {cmpy_0.udo}

run 1000ns

quit -force
