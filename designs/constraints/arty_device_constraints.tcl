# -----------------------------------------------------------------------------
# arty_device_constraints.tcl
#
# 6/19/2024 D. W. Hawkins (dwh@caltech.edu)
#
# Digilent Arty device constraints file.
#
# -----------------------------------------------------------------------------
# References
# ----------
#
# [1] Xilinx, "UG470: 7 Series FPGAs Configuration User Guide",
#     version 1.11, September, 2016.
#
# [2] Digilent, "Arty schematic", rev C.1, 2015.
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Apply Device Constraints
# -----------------------------------------------------------------------------
#
# For designs that do not need to customize the device constraints, pass
# an empty dictionary, eg.,
#
# tcl> set device_constraints [dict create]
# tcl> apply_device_constraints $device_constraints
#
proc apply_device_constraints {device_constraints} {

	# -------------------------------------------------------------------------
	# Configuration Voltage
	# -------------------------------------------------------------------------
	#
	# Suppress Implementation Warning Message
	#
	# Configuration bank voltage select (CFGBVS) (see p13 [1])
	#  * GND  = 1.5/1.8V
	#  * VCCO = 2.5/3.3V
	# The Arty board has CFGBVS tied to VCCO = 3.3V (see p6 [2])
	#
	set_property CFGBVS         VCCO [current_design]
	set_property CONFIG_VOLTAGE 3.3  [current_design]

	# -------------------------------------------------------------------------
	# Configuration mode
	# -------------------------------------------------------------------------
	#
	# The configuration mode options for the Arty device can be listed using:
	#
	# list_property_value CONFIG_MODE [current_design]
	# SPIx1 SPIx2 SPIx4 M_SERIAL S_SERIAL BPI8 BPI16 S_SELECTMAP S_SELECTMAP16
	# S_SELECTMAP32 B_SCAN M_SELECTMAP M_SELECTMAP16

	# Single Quad SPI mode (4-bit configuration from one QSPI flash)
#	set_property CONFIG_MODE SPIx4 [current_design]

	# -------------------------------------------------------------------------
	# Bitstream compression
	# -------------------------------------------------------------------------
	#
	# Turn on compression
	set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

	# -------------------------------------------------------------------------
	# JTAG USERCODE
	# -------------------------------------------------------------------------
	#
	# Default USERID
	set userid 0xDEADBEEF

	# User-provided override
	if {[dict exists $device_constraints USERID]} {
		set userid [dict get $device_constraints USERID]
	}

	# Set the JTAG USER ID
	set_property BITSTREAM.CONFIG.USERID $userid [current_design]

	return
}
