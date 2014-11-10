onerror {quit -f}
vlib work
vlog -work work progetto.vo
vlog -work work progetto.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.HCSR04_interface_vlg_vec_tst
vcd file -direction progetto.msim.vcd
vcd add -internal HCSR04_interface_vlg_vec_tst/*
vcd add -internal HCSR04_interface_vlg_vec_tst/i1/*
add wave /*
run -all
