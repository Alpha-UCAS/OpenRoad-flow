export DESIGN_NAME = chiwen
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/chiwen/Top.v
export SDC_FILE      = ./designs/src/chiwen/design.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 3100.04 2683.2
export CORE_AREA   = 10.07 11.2 3080.28 2665.6

export CLOCK_PERIOD = 10.000
