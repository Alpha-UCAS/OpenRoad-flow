export DESIGN_NAME = rv32_ttoy
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/rv32_ttoy/Top.v
export SDC_FILE      = ./designs/src/rv32_ttoy/design.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 1550.02 1342.6
export CORE_AREA   = 10.07 11.2 1540.14 1332.8

export CLOCK_PERIOD = 10.000
