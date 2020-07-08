export DESIGN_NAME = chiwen
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/chiwen/Top.v
export SDC_FILE      = ./designs/src/chiwen/design.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 2200.01 2199.4
export CORE_AREA   = 10.07 11.2 2189.94 2189.6

export CLOCK_PERIOD = 10.000
