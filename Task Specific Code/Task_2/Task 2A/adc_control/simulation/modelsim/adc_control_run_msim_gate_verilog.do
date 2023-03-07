transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {adc_control.vo}

vlog -vlog01compat -work work +incdir+E:/E-yantra/Task\ 2/adc_control/simulation/modelsim {E:/E-yantra/Task 2/adc_control/simulation/modelsim/adc_tb.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  adc_tb

add wave *
view structure
view signals
run 20000 ns
