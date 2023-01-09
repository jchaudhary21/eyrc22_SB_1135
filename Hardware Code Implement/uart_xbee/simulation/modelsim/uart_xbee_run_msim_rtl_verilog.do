transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/E-yantra/Task\ 2/uart_xbee {E:/E-yantra/Task 2/uart_xbee/uart_xbee.v}

vlog -vlog01compat -work work +incdir+E:/E-yantra/Task\ 2/uart_xbee/simulation/modelsim/rtl_work {E:/E-yantra/Task 2/uart_xbee/simulation/modelsim/rtl_work/test_bench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test_bench

add wave *
view structure
view signals
run -all
