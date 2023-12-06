rm -rf obj_dir
rm _f instrmem.vcd

verilator -Wall --cc --trace instrmem.sv --exe instrmem_tb.cpp

make -j -C obj_dir/ -f Vinstrmem.mk Vinstrmem

obj_dir/Vinstrmem