# Demo

## Build risc-v tool chain

```bash
# Download and initialize the Rocket Chip repository
$ git clone https://github.com/riscv/riscv-tools.git
$ cd riscv-tools

# Install necessary packages (Ubuntu)
$ sudo apt-get install autoconf automake autotools-dev \
curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev \
gawk build-essential bison flex texinfo gperf libtool \
patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev

# Build the RISC-V Toolchain (Newlib version for use without an OS)
$ export RISCV=/path/to/install/riscv/toolchain
# Add everything that will be built to our path for easy access)
$ export PATH=$PATH:$RISCV/bin
$ git submodule update --init --recursive
# Edit build.common file
# with JOBS = No of Cores / Threads your machine supports
# the default is risc-v 64-bit 
$./build.sh

# Test the RISC-V Toolchain by compiling a simple program
# and then running it with Spike (ISA simulator)
# using the provided proxy kernel (pk)
$ echo -e '#include <stdio.h>\n int main(void) \
{ printf("Hello world!\\n"); return 0; }' > hello.c
$ riscv64-unknown-elf-gcc -o hello hello.c
spike pk hello
```

## Install iverlog and gtkwave to simulate

```bash
$ sudo apt-get install iverilog gtkwave
```

## Build the software

```bash
$ cd software
$ make 
```

## Begin CPU simulation

```bash
$ cd testbench
$ make
# the following is iverilog simulator running  STDOUT print log in the Terminal
iverilog -o rv32_toy ../rv32_toy/*.v testbench.v
vvp -n rv32_toy +vcd 3>&1 1>&2 2>&3 | ./tracer.py | /opt/riscv/bin/spike-dasm  > output.log
VCD info: dumpfile rv32_toy.vcd opened for output.
hello world
lui..OK
auipc..OK
j..OK
jal..OK
jalr..OK
beq..OK
bne..OK
blt..OK
bge..OK
bltu..OK
bgeu..OK
lb..OK
lh..OK
lw..OK
lbu..OK
lhu..OK
sb..OK
sh..OK
sw..OK
addi..OK
slti..OK
xori..OK
ori..OK
andi..OK
slli..OK
srli..OK
srai..OK
add..OK
sub..OK
sll..OK
slt..OK
xor..OK
srl..OK
sra..OK
or..OK
and..OK
simple..OK
 1st prime is 2.
 2nd prime is 3.
 3rd prime is 5.
 4th prime is 7.
 5th prime is 11.
 6th prime is 13.
 7th prime is 17.
 8th prime is 19.
 9th prime is 23.
10th prime is 29.
11th prime is 31.
12th prime is 37.
13th prime is 41.
14th prime is 43.
15th prime is 47.
16th prime is 53.
17th prime is 59.
18th prime is 61.
19th prime is 67.
20th prime is 71.
21st prime is 73.
22nd prime is 79.
23rd prime is 83.
24th prime is 89.
25th prime is 97.
26th prime is 101.
27th prime is 103.
28th prime is 107.
29th prime is 109.
30th prime is 113.
31st prime is 127.
checksum: 1772A48F OK
Cycle counter .......... 43187
Instruction counter .... 50097
CPI: .86
DONE 
# use gtkwave to view waveform file rv32_toy.vcd
$ make vcd
```

Simulation will automatically generate a trace log file `output.log`.