# pipe processor output through the spike-dasm program to turn 
# raw instruction bits into pretty, readable diassembly
disasm_exe := 2>
which_disasm := $(shell which spike-dasm)
ifneq ($(which_disasm),)
	disasm_exe := 3>&1 1>&2 2>&3 | ./tracer.py | $(which_disasm) $(DISASM_EXTENSION) > output.log
endif

all:
	iverilog -o rv32_toy ../rv32_toy/*.v testbench.v
	vvp -n rv32_toy +vcd $(disasm_exe)
vcd:
	gtkwave rv32_toy.vcd
clean:
	rm rv32_toy rv32_toy.vcd

# for Ubuntu 
# sudo apt install iverilog gtkwave
