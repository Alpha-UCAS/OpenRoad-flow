export DESIGN_NAME = riscv_core
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/ultraembedded/riscv_*
export SDC_FILE      = ./designs/src/ultraembedded/design.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 924.92 799.4
export CORE_AREA   = 10.07 9.8 914.85 789.6

export CLOCK_PERIOD = 5.600
