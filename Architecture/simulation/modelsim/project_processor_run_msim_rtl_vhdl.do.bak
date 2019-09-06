transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/datapath.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/processor_regs.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/reg.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/alu.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/tristate.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/control_circuit.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/next_state.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/data_source.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/ram.vhd}
vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/program_counter.vhd}

vcom -93 -work work {C:/Users/Zac/Documents/dev/repo/processor_v12/project_processor_optimised_FPGA_ready_restored/testbench_project.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  testbench_project

add wave *
view structure
view signals
run 15000 ns
