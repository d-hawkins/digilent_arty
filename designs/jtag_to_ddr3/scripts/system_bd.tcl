# -----------------------------------------------------------------------------
# system_bd.tcl
#
# 9/13/2024 D. W. Hawkins (dwh@caltech.edu)
#
# Script to re-create the 'system' block design.
#
# -----------------------------------------------------------------------------
# Notes
# -----
#
# 1. IP versions
#
#    Each version of Vivado only supports a single IP version. If Vivado
#    updates an IP version, then this script will need to be changed.
#    Minor version changes can be accommodated by changing the IP version
#    check logic. Major version changes may require conditional logic around
#    the IP configuration or connections.
#
#    Use 'get_ipdefs -help' to learn how to query the Vivado IP database.
#
#    If IP versions need to be checked, the version can be extracted from
#    the VNLV string using Tcl split, or the IP can be queried, eg.,
#
#    tcl> set obj [get_ipdefs -all xilinx.com:ip:jtag_axi*]
#    xilinx.com:ip:jtag_axi:1.2
#    tcl> get_property VERSION $obj
#    1.2
#
#    The get_property response could be used in conditional logic.
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Check the Block Design IP
# -----------------------------------------------------------------------------
#
proc check_block_design_ip_is_ok {} {

	# IP used in the design
	set ip_list {}
	#
	# IP versions supported by Vivado 2024.1
	set ip_list [list \
		xilinx.com:ip:jtag_axi:1.2       \
		xilinx.com:ip:axi_vip:1.1        \
		xilinx.com:ip:smartconnect:1.0   \
		xilinx.com:ip:mig_7series:4.2    \
		xilinx.com:ip:proc_sys_reset:5.0 \
	]

	# Check the IP Catalog
	set ip_missing {}
	foreach ip_vlnv $ip_list {
		set ip_obj [get_ipdefs -all -quiet $ip_vlnv]
		if {$ip_obj eq ""} {
			lappend ip_missing $ip_vlnv
		}
	}
	if {[llength $ip_missing]} {
		# Error message
		set msg    "The following IPs were not found in the IP Catalog:\n"
		append msg "  $ip_missing\n"
		append msg "Please add the IP repositories to the project."
		# Generate the error message on the console and in the logs
		puts "Error: $msg"
		catch {common::send_msg_id "design.tcl" "ERROR" $msg}

		# IP checks fail
		return 0
	}

	# IP checks pass
	return 1
}


# -----------------------------------------------------------------------------
# Create the MIG project file
# -----------------------------------------------------------------------------
#
proc write_arty_mig { str_mig_prj_filepath } {

   file mkdir [ file dirname "$str_mig_prj_filepath" ]
   set mig_prj_file [open $str_mig_prj_filepath  w+]

   puts $mig_prj_file {?<?xml version="1.0" encoding="UTF-8" standalone="no" ?>}
   puts $mig_prj_file {<Project NoOfControllers="1">}
   puts $mig_prj_file {  }
   puts $mig_prj_file {<!-- IMPORTANT: This is an internal file that has been generated by the MIG software. Any direct editing or changes made to this file may result in unpredictable behavior or data corruption. It is strongly advised that users do not edit the contents of this file. Re-run the MIG GUI with the required settings if any of the options provided below need to be altered. -->}
   puts $mig_prj_file {  <ModuleName>system_mig_7series_0_1</ModuleName>}
   puts $mig_prj_file {  <dci_inouts_inputs>1</dci_inouts_inputs>}
   puts $mig_prj_file {  <dci_inputs>1</dci_inputs>}
   puts $mig_prj_file {  <Debug_En>OFF</Debug_En>}
   puts $mig_prj_file {  <DataDepth_En>1024</DataDepth_En>}
   puts $mig_prj_file {  <LowPower_En>ON</LowPower_En>}
   puts $mig_prj_file {  <XADC_En>Enabled</XADC_En>}
   puts $mig_prj_file {  <TargetFPGA>xc7a35ti-csg324/-1L</TargetFPGA>}
   puts $mig_prj_file {  <Version>4.2</Version>}
   puts $mig_prj_file {  <SystemClock>No Buffer</SystemClock>}
   puts $mig_prj_file {  <ReferenceClock>No Buffer</ReferenceClock>}
   puts $mig_prj_file {  <SysResetPolarity>ACTIVE HIGH</SysResetPolarity>}
   puts $mig_prj_file {  <BankSelectionFlag>FALSE</BankSelectionFlag>}
   puts $mig_prj_file {  <InternalVref>1</InternalVref>}
   puts $mig_prj_file {  <dci_hr_inouts_inputs>50 Ohms</dci_hr_inouts_inputs>}
   puts $mig_prj_file {  <dci_cascade>0</dci_cascade>}
   puts $mig_prj_file {  <Controller number="0">}
   puts $mig_prj_file {    <MemoryDevice>DDR3_SDRAM/Components/MT41K128M16XX-15E</MemoryDevice>}
   puts $mig_prj_file {    <TimePeriod>3077</TimePeriod>}
   puts $mig_prj_file {    <VccAuxIO>1.8V</VccAuxIO>}
   puts $mig_prj_file {    <PHYRatio>4:1</PHYRatio>}
   puts $mig_prj_file {    <InputClkFreq>99.997</InputClkFreq>}
   puts $mig_prj_file {    <UIExtraClocks>1</UIExtraClocks>}
   puts $mig_prj_file {    <MMCM_VCO>649</MMCM_VCO>}
   puts $mig_prj_file {    <MMCMClkOut0> 3.250</MMCMClkOut0>}
   puts $mig_prj_file {    <MMCMClkOut1>1</MMCMClkOut1>}
   puts $mig_prj_file {    <MMCMClkOut2>1</MMCMClkOut2>}
   puts $mig_prj_file {    <MMCMClkOut3>1</MMCMClkOut3>}
   puts $mig_prj_file {    <MMCMClkOut4>1</MMCMClkOut4>}
   puts $mig_prj_file {    <DataWidth>16</DataWidth>}
   puts $mig_prj_file {    <DeepMemory>1</DeepMemory>}
   puts $mig_prj_file {    <DataMask>1</DataMask>}
   puts $mig_prj_file {    <ECC>Disabled</ECC>}
   puts $mig_prj_file {    <Ordering>Normal</Ordering>}
   puts $mig_prj_file {    <BankMachineCnt>4</BankMachineCnt>}
   puts $mig_prj_file {    <CustomPart>FALSE</CustomPart>}
   puts $mig_prj_file {    <NewPartName/>}
   puts $mig_prj_file {    <RowAddress>14</RowAddress>}
   puts $mig_prj_file {    <ColAddress>10</ColAddress>}
   puts $mig_prj_file {    <BankAddress>3</BankAddress>}
   puts $mig_prj_file {    <MemoryVoltage>1.35V</MemoryVoltage>}
   puts $mig_prj_file {    <C0_MEM_SIZE>268435456</C0_MEM_SIZE>}
   puts $mig_prj_file {    <UserMemoryAddressMap>BANK_ROW_COLUMN</UserMemoryAddressMap>}
   puts $mig_prj_file {    <PinSelection>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="R2" SLEW="" VCCAUX_IO="" name="ddr3_addr[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="R6" SLEW="" VCCAUX_IO="" name="ddr3_addr[10]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="U6" SLEW="" VCCAUX_IO="" name="ddr3_addr[11]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="T6" SLEW="" VCCAUX_IO="" name="ddr3_addr[12]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="T8" SLEW="" VCCAUX_IO="" name="ddr3_addr[13]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="M6" SLEW="" VCCAUX_IO="" name="ddr3_addr[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="N4" SLEW="" VCCAUX_IO="" name="ddr3_addr[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="T1" SLEW="" VCCAUX_IO="" name="ddr3_addr[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="N6" SLEW="" VCCAUX_IO="" name="ddr3_addr[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="R7" SLEW="" VCCAUX_IO="" name="ddr3_addr[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="V6" SLEW="" VCCAUX_IO="" name="ddr3_addr[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="U7" SLEW="" VCCAUX_IO="" name="ddr3_addr[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="R8" SLEW="" VCCAUX_IO="" name="ddr3_addr[8]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="V7" SLEW="" VCCAUX_IO="" name="ddr3_addr[9]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="R1" SLEW="" VCCAUX_IO="" name="ddr3_ba[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="P4" SLEW="" VCCAUX_IO="" name="ddr3_ba[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="P2" SLEW="" VCCAUX_IO="" name="ddr3_ba[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="M4" SLEW="" VCCAUX_IO="" name="ddr3_cas_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL135" PADName="V9" SLEW="" VCCAUX_IO="" name="ddr3_ck_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL135" PADName="U9" SLEW="" VCCAUX_IO="" name="ddr3_ck_p[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="N5" SLEW="" VCCAUX_IO="" name="ddr3_cke[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="U8" SLEW="" VCCAUX_IO="" name="ddr3_cs_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="L1" SLEW="" VCCAUX_IO="" name="ddr3_dm[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="U1" SLEW="" VCCAUX_IO="" name="ddr3_dm[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="K5" SLEW="" VCCAUX_IO="" name="ddr3_dq[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="U4" SLEW="" VCCAUX_IO="" name="ddr3_dq[10]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="V5" SLEW="" VCCAUX_IO="" name="ddr3_dq[11]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="V1" SLEW="" VCCAUX_IO="" name="ddr3_dq[12]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="T3" SLEW="" VCCAUX_IO="" name="ddr3_dq[13]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="U3" SLEW="" VCCAUX_IO="" name="ddr3_dq[14]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="R3" SLEW="" VCCAUX_IO="" name="ddr3_dq[15]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="L3" SLEW="" VCCAUX_IO="" name="ddr3_dq[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="K3" SLEW="" VCCAUX_IO="" name="ddr3_dq[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="L6" SLEW="" VCCAUX_IO="" name="ddr3_dq[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="M3" SLEW="" VCCAUX_IO="" name="ddr3_dq[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="M1" SLEW="" VCCAUX_IO="" name="ddr3_dq[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="L4" SLEW="" VCCAUX_IO="" name="ddr3_dq[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="M2" SLEW="" VCCAUX_IO="" name="ddr3_dq[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="V4" SLEW="" VCCAUX_IO="" name="ddr3_dq[8]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="T5" SLEW="" VCCAUX_IO="" name="ddr3_dq[9]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL135" PADName="N1" SLEW="" VCCAUX_IO="" name="ddr3_dqs_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL135" PADName="V2" SLEW="" VCCAUX_IO="" name="ddr3_dqs_n[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL135" PADName="N2" SLEW="" VCCAUX_IO="" name="ddr3_dqs_p[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL135" PADName="U2" SLEW="" VCCAUX_IO="" name="ddr3_dqs_p[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="R5" SLEW="" VCCAUX_IO="" name="ddr3_odt[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="P3" SLEW="" VCCAUX_IO="" name="ddr3_ras_n"/>}
   #
   # The Vivado-generated XML was modifed to change ddr3_reset_n to use LVCMOS15
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="LVCMOS15" PADName="K6" SLEW="" VCCAUX_IO="" name="ddr3_reset_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL135" PADName="P5" SLEW="" VCCAUX_IO="" name="ddr3_we_n"/>}
   puts $mig_prj_file {    </PinSelection>}
   puts $mig_prj_file {    <System_Control>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="sys_rst"/>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="init_calib_complete"/>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="tg_compare_error"/>}
   puts $mig_prj_file {    </System_Control>}
   puts $mig_prj_file {    <TimingParameters>}
   puts $mig_prj_file {      <Parameters tcke="5.625" tfaw="45" tras="36" trcd="13.5" trefi="7.8" trfc="160" trp="13.5" trrd="7.5" trtp="7.5" twtr="7.5"/>}
   puts $mig_prj_file {    </TimingParameters>}
   puts $mig_prj_file {    <mrBurstLength name="Burst Length">8 - Fixed</mrBurstLength>}
   puts $mig_prj_file {    <mrBurstType name="Read Burst Type and Length">Sequential</mrBurstType>}
   puts $mig_prj_file {    <mrCasLatency name="CAS Latency">5</mrCasLatency>}
   puts $mig_prj_file {    <mrMode name="Mode">Normal</mrMode>}
   puts $mig_prj_file {    <mrDllReset name="DLL Reset">No</mrDllReset>}
   puts $mig_prj_file {    <mrPdMode name="DLL control for precharge PD">Slow Exit</mrPdMode>}
   puts $mig_prj_file {    <emrDllEnable name="DLL Enable">Enable</emrDllEnable>}
   puts $mig_prj_file {    <emrOutputDriveStrength name="Output Driver Impedance Control">RZQ/6</emrOutputDriveStrength>}
   puts $mig_prj_file {    <emrMirrorSelection name="Address Mirroring">Disable</emrMirrorSelection>}
   puts $mig_prj_file {    <emrCSSelection name="Controller Chip Select Pin">Enable</emrCSSelection>}
   puts $mig_prj_file {    <emrRTT name="RTT (nominal) - On Die Termination (ODT)">RZQ/6</emrRTT>}
   puts $mig_prj_file {    <emrPosted name="Additive Latency (AL)">0</emrPosted>}
   puts $mig_prj_file {    <emrOCD name="Write Leveling Enable">Disabled</emrOCD>}
   puts $mig_prj_file {    <emrDQS name="TDQS enable">Enabled</emrDQS>}
   puts $mig_prj_file {    <emrRDQS name="Qoff">Output Buffer Enabled</emrRDQS>}
   puts $mig_prj_file {    <mr2PartialArraySelfRefresh name="Partial-Array Self Refresh">Full Array</mr2PartialArraySelfRefresh>}
   puts $mig_prj_file {    <mr2CasWriteLatency name="CAS write latency">5</mr2CasWriteLatency>}
   puts $mig_prj_file {    <mr2AutoSelfRefresh name="Auto Self Refresh">Enabled</mr2AutoSelfRefresh>}
   puts $mig_prj_file {    <mr2SelfRefreshTempRange name="High Temparature Self Refresh Rate">Normal</mr2SelfRefreshTempRange>}
   puts $mig_prj_file {    <mr2RTTWR name="RTT_WR - Dynamic On Die Termination (ODT)">Dynamic ODT off</mr2RTTWR>}
   puts $mig_prj_file {    <PortInterface>AXI</PortInterface>}
   puts $mig_prj_file {    <AXIParameters>}
   puts $mig_prj_file {      <C0_C_RD_WR_ARB_ALGORITHM>RD_PRI_REG</C0_C_RD_WR_ARB_ALGORITHM>}
   puts $mig_prj_file {      <C0_S_AXI_ADDR_WIDTH>28</C0_S_AXI_ADDR_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_DATA_WIDTH>128</C0_S_AXI_DATA_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_ID_WIDTH>4</C0_S_AXI_ID_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_SUPPORTS_NARROW_BURST>0</C0_S_AXI_SUPPORTS_NARROW_BURST>}
   puts $mig_prj_file {    </AXIParameters>}
   puts $mig_prj_file {  </Controller>}
   puts $mig_prj_file {</Project>}

   close $mig_prj_file
}

# -----------------------------------------------------------------------------
# Create the Block Design
# -----------------------------------------------------------------------------
#
proc create_block_design {{parent_cell ""}} {

	# -------------------------------------------------------------------------
	# Block Design Object
	# -------------------------------------------------------------------------
	#
	# The following were generated by Vivado and then slightly reformated.
	#
	if { $parent_cell eq "" } {
		set parent_cell [get_bd_cells /]
	}

	# Get parent object
	set parent_obj [get_bd_cells $parent_cell]
	if { $parent_obj == "" } {
		set msg "Unable to find parent cell <$parent_cell>!"
		catch {common::send_msg_id "design.tcl" "ERROR" $msg}
		return
	}

	# Check the parent type
	set parent_type [get_property TYPE $parent_obj]
	if { $parent_type ne "hier" } {
		set msg    "Parent <$parent_obj> has TYPE = <$parent_type>."
		append msg " Expected to be <hier>."
		catch {common::send_msg_id "design.tcl" "ERROR" $msg}
		return
	}

	# Save current instance; Restore later
	set old_bd_instance [current_bd_instance .]

	# Set parent object as current
	current_bd_instance $parent_obj

	# -------------------------------------------------------------------------
	# Create interface ports
	# -------------------------------------------------------------------------
	#
	# DDR3 interface
	set ddr3 [ create_bd_intf_port -mode Master \
		-vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3 ]

	# -------------------------------------------------------------------------
	# Create ports
	# -------------------------------------------------------------------------
	#
	# Reset (active low)
	set ddr3_sys_rst_n [ create_bd_port -dir I -type rst ddr3_sys_rst_n ]
	set_property -dict [ list \
		CONFIG.POLARITY {ACTIVE_LOW} \
	] $ddr3_sys_rst_n

	# 100MHz system clock
	set ddr3_sys_clk [ create_bd_port -dir I -type clk \
		-freq_hz 100000000 ddr3_sys_clk ]

	# 200MHz IDELAYCTRL clock
	set ddr3_ref_clk [ create_bd_port -dir I -type clk \
		-freq_hz 200000000 ddr3_ref_clk ]

	# DDR3 MMCM locked
	set ddr3_locked [ create_bd_port -dir O ddr3_locked ]

	# DDR3 calibration complete
	set ddr3_ready [ create_bd_port -dir O ddr3_ready ]

	# -------------------------------------------------------------------------
	# u1: JTAG-to-AXI Bridge
	# -------------------------------------------------------------------------
	#
	# Instance
	set u1_jtag [ create_bd_cell -type ip \
		-vlnv xilinx.com:ip:jtag_axi:1.2 u1_jtag ]
	#
	# Properties
	# * M_AXI_DATA_WIDTH can be 32 or 64
	set_property -dict [ list \
		CONFIG.M_AXI_DATA_WIDTH 32 \
	] $u1_jtag

	# -------------------------------------------------------------------------
	# u2: AXI Verification IP
	# -------------------------------------------------------------------------
	#
	# Instance
	set u2_vip [ create_bd_cell -type ip \
		-vlnv xilinx.com:ip:axi_vip:1.1 u2_vip ]

	# -------------------------------------------------------------------------
	# u3: Smart Interconnect
	# -------------------------------------------------------------------------
	#
	# Instance
	set u3_smartconnect [ create_bd_cell -type ip \
		-vlnv xilinx.com:ip:smartconnect:1.0 u3_smartconnect ]
	#
	# Properties
	set_property -dict [list \
		CONFIG.NUM_SI {1} \
	] $u3_smartconnect

	# -------------------------------------------------------------------------
	# u4: DDR3
	# -------------------------------------------------------------------------
	#
	# Instance
	set u4_ddr3 [ create_bd_cell -type ip \
		-vlnv xilinx.com:ip:mig_7series:4.2 u4_ddr3 ]

	# Create the MIG .prj file
	set str_mig_folder [get_property IP_DIR [ get_ips [ get_property CONFIG.Component_Name $u4_ddr3 ] ] ]
	set str_mig_file_name arty_mig.prj
	set str_mig_file_path ${str_mig_folder}/${str_mig_file_name}
	write_arty_mig $str_mig_file_path

	set msg    "MIG path = $str_mig_file_path"
	catch {common::send_msg_id "design.tcl" "ERROR" $msg}

	# Properties
	set_property -dict [list \
		CONFIG.BOARD_MIG_PARAM       {Custom} \
		CONFIG.MIG_DONT_TOUCH_PARAM  {Custom} \
		CONFIG.RESET_BOARD_INTERFACE {Custom} \
		CONFIG.XML_INPUT_FILE        $str_mig_file_path \
	] $u4_ddr3

	# -------------------------------------------------------------------------
	# u5: Reset Synchronizer
	# -------------------------------------------------------------------------
	#
	# Instance
	set u5_reset [ create_bd_cell -type ip \
		-vlnv xilinx.com:ip:proc_sys_reset:5.0 u5_reset ]

	# -------------------------------------------------------------------------
	# Interface Connections
	# -------------------------------------------------------------------------
	#
	# JTAG-to-AXI to AXI VIP connection
	connect_bd_intf_net -intf_net axi_jtag \
		[get_bd_intf_pins u1_jtag/M_AXI] \
		[get_bd_intf_pins u2_vip/S_AXI]

	# AXI VIP to AXI smartconnect
	connect_bd_intf_net -intf_net axi_vip \
		[get_bd_intf_pins u2_vip/M_AXI] \
		[get_bd_intf_pins u3_smartconnect/S00_AXI]

	# AXI smartconnect to DDR3
	connect_bd_intf_net -intf_net axi_ddr3 \
		[get_bd_intf_pins u3_smartconnect/M00_AXI] \
		[get_bd_intf_pins u4_ddr3/S_AXI]

	# DDR3 to top-level
	connect_bd_intf_net -intf_net ddr3 \
		[get_bd_intf_ports ddr3] \
		[get_bd_intf_pins u4_ddr3/DDR3]

	# -------------------------------------------------------------------------
	# Port Connections
	# -------------------------------------------------------------------------
	#
	# DDR3 system reset
	connect_bd_net -net ddr3_sys_rst_n \
		[get_bd_ports ddr3_sys_rst_n] \
		[get_bd_pins u4_ddr3/sys_rst]

	# DDR3 system clock
	connect_bd_net -net ddr3_sys_clk \
		[get_bd_ports ddr3_sys_clk] \
		[get_bd_pins u4_ddr3/sys_clk_i]

	# DDR3 reference clock
	connect_bd_net -net ddr3_ref_clk \
		[get_bd_ports ddr3_ref_clk] \
		[get_bd_pins u4_ddr3/clk_ref_i]

	# DDR3 user interface reset (output to reset synchronizer)
	connect_bd_net -net ddr3_ui_reset \
		[get_bd_pins u4_ddr3/ui_clk_sync_rst] \
		[get_bd_pins u5_reset/ext_reset_in]

	# AXI-MM clock
	connect_bd_net -net axi_clk \
		[get_bd_pins u1_jtag/aclk] \
		[get_bd_pins u2_vip/aclk] \
		[get_bd_pins u3_smartconnect/aclk] \
		[get_bd_pins u4_ddr3/ui_clk] \
		[get_bd_pins u5_reset/slowest_sync_clk]

	# AXI-MM reset
	connect_bd_net -net axi_reset_n \
		[get_bd_pins u1_jtag/aresetn] \
		[get_bd_pins u2_vip/aresetn] \
		[get_bd_pins u3_smartconnect/aresetn] \
		[get_bd_pins u4_ddr3/aresetn] \
		[get_bd_pins u5_reset/peripheral_aresetn]

	# DDR3 locked status
	connect_bd_net -net ddr3_locked \
		[get_bd_pins u4_ddr3/mmcm_locked] \
		[get_bd_ports ddr3_locked]

	# DDR3 calibration complete status
	connect_bd_net -net ddr3_ready \
		[get_bd_pins u4_ddr3/init_calib_complete] \
		[get_bd_ports ddr3_ready]

	# -------------------------------------------------------------------------
	# Create address segments
	# -------------------------------------------------------------------------
	#
	# DDR interface
	assign_bd_address -offset 0x00000000 -range 0x10000000 \
		-target_address_space [get_bd_addr_spaces u1_jtag/Data] \
		[get_bd_addr_segs u4_ddr3/memmap/memaddr] -force

	# -------------------------------------------------------------------------
	# Block design finalization
	# -------------------------------------------------------------------------
	#
	# Restore current instance
	current_bd_instance $old_bd_instance

	# Validate and save
	validate_bd_design
	save_bd_design
	return
}

