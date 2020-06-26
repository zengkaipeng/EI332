onerror {quit -f}
vlib work
vlog -work work sc_computer.vo
vlog -work work sc_computer.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.sc_computer_vlg_vec_tst
vcd file -direction sc_computer.msim.vcd
vcd add -internal sc_computer_vlg_vec_tst/*
vcd add -internal sc_computer_vlg_vec_tst/i1/*
add wave /*
run -all
