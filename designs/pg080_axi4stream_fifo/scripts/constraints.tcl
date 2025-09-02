# -----------------------------------------------------------------------------
# constraints.tcl
#
# 9/1/2025 D. W. Hawkins (dwh@caltech.edu)
#
# Digilent Arty constraints.
#
# -----------------------------------------------------------------------------

# Messages are written to build/vivado/arty.runs/impl_1/runme.log
puts "constraints.tcl: [string repeat = 80]"
puts "constraints.tcl: Running the constraints file!"

# ACTIVE_STEP = init_design
if {[info exists ACTIVE_STEP]} {
	puts "constraints.tcl: ACTIVE_STEP = $ACTIVE_STEP"
}

# -----------------------------------------------------------------------------
# Constraints Procedures
# -----------------------------------------------------------------------------
#
# The unmanaged constraint is marked for use in "Implementation".
#  * puts [file normalize [info script]]
#    ends with build/vivado/arty.runs/impl_1/arty.tcl
#  * puts [pwd]
#    ends with build/vivado/arty.runs/impl_1/
#
# Extract the path to the project directory
set path [file split [pwd]]
set len  [llength $path]
set top  [file join {*}[lrange $path 0 [expr {$len - 5}]]]

# Constraints procedures directory (common scripts)
set constraints [file normalize $top/../constraints]

# Read the device constraints procedures
set filename $constraints/arty_device_constraints.tcl
if {![file exists $filename]} {
	error "Error: Arty device constraints script not found!"
}
source $filename

# Read the pin constraints procedures
set filename $constraints/arty_pin_constraints.tcl
if {![file exists $filename]} {
	error "Error: Arty pin constraints script not found!"
}
source $filename

# Read the timing constraints procedures
set filename $constraints/arty_timing_constraints.tcl
if {![file exists $filename]} {
	error "Error: Arty timing constraints script not found!"
}
source $filename

# -----------------------------------------------------------------------------
# Project-specific Constraints
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Device Constraints
# -----------------------------------------------------------------------------
#
# Apply default device constraints
set device_constraints [dict create]
apply_device_constraints $device_constraints

# -----------------------------------------------------------------------------
# Pin Constraints
# -----------------------------------------------------------------------------
#
# Ports used in the design
set ports [lsort [concat [get_ports *]]]

# Default pin constraints (no modifications required)
set pin_constraints [get_pin_constraints]

# Apply pin constraints
apply_pin_constraints $ports $pin_constraints

# -----------------------------------------------------------------------------
# Timing Constraints
# -----------------------------------------------------------------------------
#
# Apply clock constraints (no customization)
set clock_constraints [dict create]
apply_clock_constraints $clock_constraints

# Apply false paths
apply_false_paths

