export DESIGN_NAME = Icache
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/Icache/Icache.v
export SDC_FILE      = ./designs/src/Icache/design.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 1550.02 1342.6
export CORE_AREA   = 10.07 11.2 1540.14 1332.8

export CLOCK_PERIOD = 10.000
