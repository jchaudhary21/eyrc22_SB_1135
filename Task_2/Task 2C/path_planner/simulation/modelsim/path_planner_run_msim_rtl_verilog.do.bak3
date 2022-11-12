transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/E-yantra/Task\ 2/path_planner {E:/E-yantra/Task 2/path_planner/path_planner.v}

vlog -vlog01compat -work work +incdir+E:/E-yantra/Task\ 2/path_planner/simulation/modelsim {E:/E-yantra/Task 2/path_planner/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 12000 ps
