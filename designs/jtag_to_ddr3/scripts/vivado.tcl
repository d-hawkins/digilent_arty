# -----------------------------------------------------------------------------
# vivado.tcl
#
# 6/19/2024 D. W. Hawkins (dwh@caltech.edu)
#
# Digilent Arty (Xilinx Artix-7) Vivado synthesis script.
#
# Script execution;
#
# 1. Start Vivado
#
# 2. Change directory to the project folder
#
# 3. Source the synthesis script, eg.,
#
#    tcl> source -notrace scripts/vivado.tcl
#
# The script will create the build/vivado/ directory, create a project,
# and setup the source and constraints.
#
# The user can then synthesize the design, generate the bit-file,
# and then configure the board. For example, once the Vivado GUI
# for the project opens, click "Generate Bitstream" and when that
# completes, use the hardware manager to detect the board, and
# program it.
#
# -----------------------------------------------------------------------------
# Notes
# -----
#
# 1. Synthesis Tcl script
#
#    This synthesis script was created based on the output from
#    File->Write Project Tcl after manually creating a project.
#    The generated script was rearranged and redundant default
#    settings were eliminated.
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Project name
# -----------------------------------------------------------------------------
#
# The project name must match the project folder name (the script checks)
set project(name) jtag_to_ddr3

# The board name
# * the Vivado project is named after the board, so that all Vivado
#   generated folders have the form build/vivado/arty.xxx
set project(board) arty

# -----------------------------------------------------------------------------
# Tool check
# -----------------------------------------------------------------------------
#
# Check the tool is Vivado
set toolname [file rootname [file tail [info nameofexecutable]]]
if {![string equal $toolname "vivado"]} {
	error "Error: unexpected tool name '$toolname'!"
}

# Vivado version
set toolversion [lindex [split [version -short] .] 0]
if {![string length $toolversion]} {
	error "Error: tool version could not be detected!"
}

# -----------------------------------------------------------------------------
# Location check
# -----------------------------------------------------------------------------
#
# Check the current directory is the project folder
set path [pwd]
set folders [file split $path]
set length [llength $folders]
set dirname [lindex $folders [expr {$length-1}]]
if {[string equal $project(name) $dirname] != 1} {
	puts "Error: please run this script from the $project(name)/ folder!"
	return
}

# -----------------------------------------------------------------------------
# Source locations
# -----------------------------------------------------------------------------
#
# The synthesis script is called from a project folder;
#  * <board_name>/designs/<project>/
#
# The following paths are defined relative to the github basename
# (which is typically <board_name>, but could be renamed).
#
set path    [file split [pwd]]
set len     [llength $path]
set designs [file join {*}[lrange $path 0 [expr {$len - 2}]]]

# Project source
set src     $designs/$project(name)/src
set scripts $designs/$project(name)/scripts

# -----------------------------------------------------------------------------
# Vivado project
# -----------------------------------------------------------------------------
#
# Project settings
set project(path) build/vivado
set project(part) xc7a35ticsg324-1L

# Stop if the work folder already exists
if {[file exists $project(path)]} {
	puts "WARNING: The project work directory '$project(path)' already exists!"
	return
}

# Close any open project
catch {close_project}

# Create project
# * project commands; create_project, get_projects, current_project
create_project $project(board) $project(path) -part $project(part) -force

# Set project properties
# * to see the project properties, write out a Tcl file and
#   check the option to "Write all properties"
set obj [get_projects $project(board)]
set_property default_lib        work           $obj
set_property part               $project(part) $obj
set_property simulator_language Mixed          $obj
set_property target_language    Verilog        $obj
set_property source_mgmt_mode   None           $obj

# -----------------------------------------------------------------------------
# Synthesis HDL
# -----------------------------------------------------------------------------
#
# Create the 'sources_1' fileset (if it does not exist)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# HDL source list
set filenames {}

# Top-level design
lappend filenames $src/mmcm_100mhz_to_200mhz.sv
lappend filenames $src/arty.sv

# Add the HDL source to the source fileset
set obj [get_filesets sources_1]
add_files -norecurse -fileset $obj $filenames

# Set the top-level file
set_property top arty $obj

# -----------------------------------------------------------------------------
# Synthesis Constraints
# -----------------------------------------------------------------------------
#
if {[string equal [get_filesets -quiet constrs_1] ""]} {
	create_fileset -constrset constrs_1
}

# Pin constraints
set     filenames {}
#
# 'Unmanaged' Tcl constraints script
lappend filenames $scripts/constraints.tcl
#
# Project-specific XDC constraints
# - none needed for this project
#
# Vivado ILA instance
# - none needed for this project

# Add the constraint file to the constraints fileset
set obj [get_filesets constrs_1]
add_files -norecurse -fileset $obj $filenames

# The pin constraints are only used during implementation
foreach filename $filenames {

	# Remove XDC and unmanaged Tcl files from synthesis
	set_property USED_IN_SYNTHESIS  false [get_files $filename]

	# Remove unmanaged Tcl files from simulation
	set ext [file extension $filename]
	if {[string equal $ext .tcl]} {
		set_property USED_IN_SIMULATION false [get_files $filename]
	}
}

# -----------------------------------------------------------------------------
# Block Design
# -----------------------------------------------------------------------------
#
# Block design script
source $scripts/system_bd.tcl

# Block design name (used in the top-level HDL file)
set bd_name system

# Create a new block design
create_bd_design $bd_name
current_bd_design $bd_name

# Add the AXI components to the block design
check_block_design_ip
create_block_design ""

# Generate simulation files
generate_target simulation [get_files ${bd_name}.bd]

# Generate simulation files list
report_compile_order -used_in simulation \
	-of_objects [get_files ${bd_name}.bd] \
	-file $project(path)/${bd_name}_sim_files.txt

# For simulation-only debug, end the script here
if {0} {
	puts " ***************************************"
	puts " *** All done! Ready for simulation! ***"
	puts " ***************************************"
	return
}

# -----------------------------------------------------------------------------
# Synthesis Run
# -----------------------------------------------------------------------------
#
# Flow string
set flow "Vivado Synthesis $toolversion"

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
	create_run -name synth_1 -part $project(part) -flow $flow \
		-strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
	set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
	set_property flow $flow [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property part $project(part) $obj

# set the current synth run
current_run -synthesis $obj

# -----------------------------------------------------------------------------
# Implementation Run
# -----------------------------------------------------------------------------
#
# Flow string
set flow "Vivado Implementation $toolversion"

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
	create_run -name impl_1 -part $project(part) -flow $flow \
		-strategy "Vivado Implementation Defaults" \
		-constrset constrs_1 -parent_run synth_1
} else {
	set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
	set_property flow $flow [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property part $project(part) $obj

# set the current impl run
current_run -implementation $obj

# -----------------------------------------------------------------------------
# Generate the bitstream
# -----------------------------------------------------------------------------
#
launch_runs impl_1 -to_step write_bitstream -jobs 4

