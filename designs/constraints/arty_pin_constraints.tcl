# -----------------------------------------------------------------------------
# arty_pin_constraints.tcl
#
# 6/19/2024 D. W. Hawkins (dwh@caltech.edu)
#
# Digilent Arty pin constraints file.
#
# This script defines 'master' constraints procedures. Projects can modify
# the constraints for project-specific needs  eg.  change a pin I/O standard
# from the default setting.
#
# The constraints are based on those in the Digilent Arty_Master.xdc file;
#
# https://github.com/Digilent/Arty/blob/master/Resources/XDC/Arty_Master.xdc
#
# Some pin names were changed.
#
# -----------------------------------------------------------------------------
# Notes
# ------
#
# 1. Vivado 'unmanaged' constraints file
#
#    This file is a Vivado 'unmanaged' constraints file. It will not be
#    modified by Vivado and supports all Tcl constructs. XDC files support
#    very limited Tcl syntax, eg., no conditional logic.
#
# 2. Multi-bit bus indexing
#
#    Multi-bit bus pin assignments are defined using paranthesis  rather
#    than square brackets  so that the dictionary script procedures work
#    in any Tcl interpreter (not just Vivado). The paranthesis are converted
#    to square brackets before calls to Vivado set_property.
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Pins Constraints Dictionary
# -----------------------------------------------------------------------------
#
# These are the default constraints.
#
# A synthesis script reads the default constraints and applies project-specific
# changes  for example:
#  * Rename pins (eg. Arduino interface names to match the module)
#  * Modify pin constraints (eg.  change the I/O standard  or add
#    drive strength and slew rate for output signals).
#
proc get_pin_constraints {} {

	# -------------------------------------------------------------------------
	# Reset
	# -------------------------------------------------------------------------
	#
	# Asynchronous active-low reset
	dict set pin ext_reset_n {PACKAGE_PIN C2  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# 100MHz clock
	# -------------------------------------------------------------------------
	#
	dict set pin clk_100mhz {PACKAGE_PIN E3  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# Switches
	# -------------------------------------------------------------------------
	#
	# Inputs
	dict set pin sw(0)  {PACKAGE_PIN A8   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin sw(1)  {PACKAGE_PIN C11  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin sw(2)  {PACKAGE_PIN C10  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin sw(3)  {PACKAGE_PIN A10  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# Push Buttons
	# -------------------------------------------------------------------------
	#
	# Inputs
	dict set pin pb(0) {PACKAGE_PIN D9  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pb(1) {PACKAGE_PIN C9  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pb(2) {PACKAGE_PIN B9  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pb(3) {PACKAGE_PIN B8  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# Green LEDs
	# -------------------------------------------------------------------------
	#
	# Outputs
	dict set pin led_g(0) {PACKAGE_PIN H5   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_g(1) {PACKAGE_PIN J5   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_g(2) {PACKAGE_PIN T9   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_g(3) {PACKAGE_PIN T10  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# RGB LEDs
	# -------------------------------------------------------------------------
	#
	# Four RGB LEDs with 3-bits per LED
	dict set pin led_rgb(0)  {PACKAGE_PIN G6  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(1)  {PACKAGE_PIN F6  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(2)  {PACKAGE_PIN E1  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	dict set pin led_rgb(3)  {PACKAGE_PIN G3  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(4)  {PACKAGE_PIN J4  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(5)  {PACKAGE_PIN G4  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	dict set pin led_rgb(6)  {PACKAGE_PIN J3  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(7)  {PACKAGE_PIN J2  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(8)  {PACKAGE_PIN H4  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	dict set pin led_rgb(9)  {PACKAGE_PIN K1  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(10) {PACKAGE_PIN H6  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin led_rgb(11) {PACKAGE_PIN K2  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# -----------------------------------------------------------------------------
	# UART Interface
	# -----------------------------------------------------------------------------
	#
	# FPGA-side UART receiver (input)
	dict set pin uart_rxd {PACKAGE_PIN A9  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# FPGAside UART transmitter (output)
	dict set pin uart_txd {PACKAGE_PIN D10  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# -----------------------------------------------------------------------------
	# Ethernet Interface
	# -----------------------------------------------------------------------------
	#
	dict set pin eth_col     {PACKAGE_PIN D17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_crs     {PACKAGE_PIN G14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_mdc     {PACKAGE_PIN F16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_mdio    {PACKAGE_PIN K13  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_ref_clk {PACKAGE_PIN G18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rst_n   {PACKAGE_PIN C16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rx_clk  {PACKAGE_PIN F15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rx_dv   {PACKAGE_PIN G16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rxd(0)  {PACKAGE_PIN D18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rxd(1)  {PACKAGE_PIN E17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rxd(2)  {PACKAGE_PIN E18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rxd(3)  {PACKAGE_PIN G17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_rx_err  {PACKAGE_PIN C17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_tx_clk  {PACKAGE_PIN H16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_tx_en   {PACKAGE_PIN H15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_txd(0)  {PACKAGE_PIN H14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_txd(1)  {PACKAGE_PIN J14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_txd(2)  {PACKAGE_PIN J13  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin eth_txd(3)  {PACKAGE_PIN H17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# QSPI Flash
	# -------------------------------------------------------------------------
	#
	# The QSPI clock signal uses the CCLK (E9) configuration pin. The
	# E9 pin must be accessed by instantiating the STARTUPE2 primitive.
	# The Arty board also connects pin L16 to the clock signal.
	#
	dict set pin qspi_cs_n  {PACKAGE_PIN L13  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin qspi_sck   {PACKAGE_PIN L16  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin qspi_dq(0) {PACKAGE_PIN K17  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin qspi_dq(1) {PACKAGE_PIN K18  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin qspi_dq(2) {PACKAGE_PIN L14  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin qspi_dq(3) {PACKAGE_PIN M14  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# Pmods
	# -------------------------------------------------------------------------
	#
	# Pmod Header JA (200-ohm series resistors)
	# * No SRCC/MRCC pins
	dict set pin pmod_a(0) {PACKAGE_PIN G13  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_a(1) {PACKAGE_PIN B11  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_a(2) {PACKAGE_PIN A11  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_a(3) {PACKAGE_PIN D12  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_a(4) {PACKAGE_PIN D13  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_a(5) {PACKAGE_PIN B18  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_a(6) {PACKAGE_PIN A18  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_a(7) {PACKAGE_PIN K16  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# Pmod Header JB (0-ohm series resistors)
	# * JB1_P/N = SRCC
	# * JB2_P/N = MRCC
	dict set pin pmod_b(0) {PACKAGE_PIN E15  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_b(1) {PACKAGE_PIN E16  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_b(2) {PACKAGE_PIN D15  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_b(3) {PACKAGE_PIN C15  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_b(4) {PACKAGE_PIN J17  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_b(5) {PACKAGE_PIN J18  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_b(6) {PACKAGE_PIN K15  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_b(7) {PACKAGE_PIN J15  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# Pmod Header JC (0-ohm series resistors)
	# * No SRCC/MRCC pins
	dict set pin pmod_c(0) {PACKAGE_PIN U12  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_c(1) {PACKAGE_PIN V12  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_c(2) {PACKAGE_PIN V10  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_c(3) {PACKAGE_PIN V11  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_c(4) {PACKAGE_PIN U14  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_c(5) {PACKAGE_PIN V14  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_c(6) {PACKAGE_PIN T13  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_c(7) {PACKAGE_PIN U13  IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# Pmod Header JD (200-ohm series resistors)
	# * JD1 = SRCC N-input (not useful for a single-ended clock input)
	# * JD2/3 = MRCC_P/N
	# * JD4/5 = MRCC_P/N
	# * JD7/8 = SRCC_P/N
	dict set pin pmod_d(0) {PACKAGE_PIN D4   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_d(1) {PACKAGE_PIN D3   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_d(2) {PACKAGE_PIN F4   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_d(3) {PACKAGE_PIN F3   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_d(4) {PACKAGE_PIN E2   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_d(5) {PACKAGE_PIN D2   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_d(6) {PACKAGE_PIN H2   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}
	dict set pin pmod_d(7) {PACKAGE_PIN G2   IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 8  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# Arduino/ChipKit Interface
	# -------------------------------------------------------------------------
	#
	# Single Ended Analog Inputs
	# * The ck_an_p pins can be used as single ended analog inputs with
	#   voltages from 0-3.3V (Chipkit Analog pins A0-A5).
	#   These signals should only be connected to the XADC core. When
	#   using these pins as digital I/O, use pins ck_io[14-19].
	#
	dict set pin ck_an_n(0)  {PACKAGE_PIN C5   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_p(0)  {PACKAGE_PIN C6   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_n(1)  {PACKAGE_PIN A5   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_p(1)  {PACKAGE_PIN A6   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_n(2)  {PACKAGE_PIN B4   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_p(2)  {PACKAGE_PIN C4   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_n(3)  {PACKAGE_PIN A1   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_p(3)  {PACKAGE_PIN B1   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_n(4)  {PACKAGE_PIN B2   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_p(4)  {PACKAGE_PIN B3   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_n(5)  {PACKAGE_PIN C14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_an_p(5)  {PACKAGE_PIN D14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# ChipKit Digital I/O Low
	dict set pin ck_io(0)    {PACKAGE_PIN V15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(1)    {PACKAGE_PIN U16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(2)    {PACKAGE_PIN P14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(3)    {PACKAGE_PIN T11  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(4)    {PACKAGE_PIN R12  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(5)    {PACKAGE_PIN T14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(6)    {PACKAGE_PIN T15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(7)    {PACKAGE_PIN T16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(8)    {PACKAGE_PIN N15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(9)    {PACKAGE_PIN M16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(10)   {PACKAGE_PIN V17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(11)   {PACKAGE_PIN U18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(12)   {PACKAGE_PIN R17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(13)   {PACKAGE_PIN P17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# ChipKit Digital I/O On Outer Analog Header
	# * These pins should be used when using the analog header signals
	#   A0-A5 as digital I/O (Chipkit digital pins 14-19)
	dict set pin ck_io(14)   {PACKAGE_PIN F5   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(15)   {PACKAGE_PIN D8   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(16)   {PACKAGE_PIN C7   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(17)   {PACKAGE_PIN E7   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(18)   {PACKAGE_PIN D7   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(19)   {PACKAGE_PIN D5   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# ChipKit Digital I/O On Inner Analog Header
	# * These pins will need to be connected to the XADC core when used
	#   as differential analog inputs (Chipkit analog pins A6-A11)
	dict set pin ck_io(20)   {PACKAGE_PIN B7   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(21)   {PACKAGE_PIN B6   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(22)   {PACKAGE_PIN E6   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(23)   {PACKAGE_PIN E5   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(24)   {PACKAGE_PIN A4   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(25)   {PACKAGE_PIN A3   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# ChipKit Digital I/O High
	dict set pin ck_io(26)   {PACKAGE_PIN U11  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(27)   {PACKAGE_PIN V16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(28)   {PACKAGE_PIN M13  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(29)   {PACKAGE_PIN R10  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(30)   {PACKAGE_PIN R11  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(31)   {PACKAGE_PIN R13  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(32)   {PACKAGE_PIN R15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(33)   {PACKAGE_PIN P15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(34)   {PACKAGE_PIN R16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(35)   {PACKAGE_PIN N16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(36)   {PACKAGE_PIN N14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(37)   {PACKAGE_PIN U17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(38)   {PACKAGE_PIN T18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(39)   {PACKAGE_PIN R18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(40)   {PACKAGE_PIN P18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_io(41)   {PACKAGE_PIN N17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# ChipKit SPI
	dict set pin ck_sck      {PACKAGE_PIN F1   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_sel_n    {PACKAGE_PIN C1   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_miso     {PACKAGE_PIN G1   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_mosi     {PACKAGE_PIN H1   IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# ChipKit I2C
	# * the board has two pull-up resistors that can be controlled via xx_pup
	dict set pin ck_scl      {PACKAGE_PIN L18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_sda      {PACKAGE_PIN M18  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_scl_pup  {PACKAGE_PIN A14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin ck_sda_pup  {PACKAGE_PIN A13  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# Misc. ChipKit signals
	dict set pin ck_ioa      {PACKAGE_PIN M17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# -------------------------------------------------------------------------
	# Power Measurement
	# -------------------------------------------------------------------------
	#
	dict set pin pwr_vsns_vu_n   {PACKAGE_PIN B17  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pwr_vsns_vu_p   {PACKAGE_PIN B16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pwr_vsns_5v0_n  {PACKAGE_PIN B12  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pwr_vsns_5v0_p  {PACKAGE_PIN C12  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pwr_isns_5v0_n  {PACKAGE_PIN F14  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pwr_isns_5v0_p  {PACKAGE_PIN F13  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pwr_isns_0v95_n {PACKAGE_PIN A16  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}
	dict set pin pwr_isns_0v95_p {PACKAGE_PIN A15  IOSTANDARD LVCMOS33  OFFCHIP_TERM NONE}

	# Return dictionary
	return $pin
}

# -----------------------------------------------------------------------------
# Apply Pin Constraints
# -----------------------------------------------------------------------------
#
# This procedure takes two arguments:
#
# * 'ports' is a list of top-level pin names  eg.
#
#   tcl> set ports [lsort [concat [get_ports *]]]
#
# * 'pin_constraints' is the constraints dictionary
#
#   tcl> set pin_constraints [get_pin_constraints]
#
#   The dictionary content can be manipulated to rename pins  or to modify
#   constraint values (or to add new constraints).
#
proc apply_pin_constraints {ports pin_constraints {unused Pullup}} {

	# Unused pins
	# * unused = Pullup, Pulldown, or Pullnone
	set_property BITSTREAM.CONFIG.UNUSEDPIN $unused [current_design]

	# Loop over the top-level ports list
	foreach port $ports {

		# Convert port name (with square brackets) to pin name
		# * Replace square brackets with paranthesis
		set pin [string map {\[ ( \] )} $port]

		# Check that the pin name exists in the dictionary
		# * Top-level port names must match the dictionary names
		if {![dict exists $pin_constraints $pin]} {
			error "Error: Invalid top-level port name $port!"
		}

		# Apply the pin constraints
		set constraints [dict get $pin_constraints $pin]
		dict for {key val} $constraints {

			# Print the package pin
			if {[string equal $key "PACKAGE_PIN"] == 1} {
				puts "pin_constraints.tcl: $port $val"
			}

			# Execute the Vivado constraint
			set_property $key $val $port
#			puts "$key $val $port"
		}
	}
	return
}
