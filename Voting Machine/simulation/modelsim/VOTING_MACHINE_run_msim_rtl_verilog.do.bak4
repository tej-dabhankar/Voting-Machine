transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/19.1/quartus_project/Voting\ Machine {C:/intelFPGA_lite/19.1/quartus_project/Voting Machine/VOTING_MACHINE.v}

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/19.1/quartus_project/Voting\ Machine {C:/intelFPGA_lite/19.1/quartus_project/Voting Machine/Tb_Voting_Machine.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  Tb_Voting_Machine

add wave *
view structure
view signals
run -all
