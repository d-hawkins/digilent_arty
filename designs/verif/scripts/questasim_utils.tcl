# -----------------------------------------------------------------------------
# questasim_utils.tcl
#
# 9/1/2025 D. W. Hawkins (dwh@caltech.edu)
#
# Vivado Simulation utility procedures.
#
# Example usage:
#
# source -notrace sim_utils.tcl
# set rpt_name  [vivado_sim_report_write $vwork system.bd]
# set sim_table [vivado_sim_report_read $rpt_name]
# set sim_dict  [vivado_sim_table_to_dict $sim_table]
# set sim_libs  [vivado_sim_libraries $sim_dict]
# set sim_files [vivado_sim_files $sim_dict work]
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Vivado-only procedure
# -----------------------------------------------------------------------------
#
# Write the simulation files report
# * Use report_compile_order to generate a table of simulation file properties
proc vivado_sim_report_write {vwork bdname} {
	# Simulation report file
	set report_name "$vwork/sim_files.txt"

	# Generate the text file containing the files
	report_compile_order -quiet \
		-used_in simulation \
		-of_objects [get_files $bdname] \
		-file $report_name

	return $report_name
}

# -----------------------------------------------------------------------------
# Tcl procedures
# -----------------------------------------------------------------------------
#
# Read the simulation files report
proc vivado_sim_report_read {report_name} {
	# Open, read, and close the report
	set fd [open $report_name r]
	if {$fd < 0} {
		error "File open failed!"
	}
	set sim_table [split [read $fd] "\n"]
	close $fd
	return $sim_table
}

# Convert the table of file properties into a dictionary of dictionary
# - outer dictionary is (index, dictionary)
# - inner dictionary is the key-value pairs for a file
#
proc vivado_sim_table_to_dict {sim_table} {

	# Report column headings excluding the index
	# (converted to single strings)
	set keys [list     \
		File_Name      \
		Used_In        \
		File_Type      \
		Library        \
		Ngc_Wrapper    \
		Full_Path_Name \
	]

	# Loop over lines in the report file
	# (skipping the three header lines)
	set n 3
	catch {unset sim_dict}
	while {1} {
		set line [lindex $sim_table $n]
		incr n

		# End-of-file (or blank line)
		set len [string length $line]
		if {$len == 0} {
			break
		}

		# Convert 'Synth & Sim' to a single word
		set line [string map {"Synth & Sim" "Synth_Sim"} $line]

		# Skip .elf files
		# * The 'Ngc Wrapper' column is missing for .elf files
		set ext [file extension [lindex $line 1]]
		if {[string equal $ext .elf]} {
			continue
		}

		# Convert to a values list
		set vals [split [concat {*}$line]]
		set len [llength $vals]
		if {$len != 7} {
			error "Row parse error! Line: $line\n"
		}

		# Extract the index (and then delete it)
		set index [lindex $vals 0]
		set vals [lreplace $vals 0 0]

		# Convert the values to a dictionary
		foreach k $keys v $vals {
			dict set d $k $v
		}

		# Add to the top-level dictionary
		dict set sim_dict $index $d
	}
	return $sim_dict
}

# Print the simulation files dictionary
proc vivado_sim_dict_print {sim_dict} {
	dict for {index d} $sim_dict {
		puts -nonewline "index = $index : "
		dict for {k v} $d {
			puts -nonewline " $k = $v, "
		}
		puts " "
	}
	return
}

# Find the unique simulation libraries
proc vivado_sim_libraries {sim_dict} {
	set libs {}
	dict for {index d} $sim_dict {
		set val [dict get $d Library]
		if {[lsearch $libs $val] == -1} {
			lappend libs $val
		}
	}
	return $libs
}

# Find the simulation files in the specified library
proc vivado_sim_files {sim_dict libname} {
	set files {}
	dict for {index d} $sim_dict {
		set fpn [dict get $d Full_Path_Name]
		set lib [dict get $d Library]
		if {[string equal $libname $lib]} {
			lappend files $fpn
		}
	}
	return $files
}
