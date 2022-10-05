transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {fsm.vo}

vlog -vlog01compat -work work +incdir+E:/E-yantra/Task\ 1/fsm/simulation/modelsim {E:/E-yantra/Task 1/fsm/simulation/modelsim/fsm_tb.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  fsm_tb

add wave *
view structure
view signals
run 4000 ps
