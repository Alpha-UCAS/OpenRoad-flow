export DESIGN_NAME = picorv32
export PLATFORM    = nangate45

export VERILOG_FILES = ./designs/src/picorv32/picorv32.v
export SDC_FILE      = ./designs/src/picorv32/design.sdc

# These values must be multiples of placement site
# x=0.19 y=1.4
export DIE_AREA    = 0 0 320.15 320.6
export CORE_AREA   = 10.07 11.2 310.27 310.8

export CLOCK_PERIOD = 5.600
