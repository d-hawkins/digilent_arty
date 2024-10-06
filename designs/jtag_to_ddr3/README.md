# Digilent Arty DDR3 Example

9/25/2024 D. W. Hawkins (dwh@caltech.edu)

This example design demonstrates the use of the Arty DDR3. 

Digilent shows how to instantiate the Xilinx MIG in a block design:

https://digilent.com/reference/programmable-logic/guides/getting-started-with-ipi

Viktor Nikolov implements a variation of the Arty DDR3 design:
 
https://forum.digilent.com/topic/27389-arty-a7-microblaze-ddr3-tutorial/

https://github.com/viktor-nikolov/MicroBlaze-DDR3-tutorial

The design in this repository implements a block design containing:
 
 * u1: A JTAG-to-AXI bridge (for hardware test)
 * u2: An AXI-MM VIP (for simulation test)
 * u3: An AXI SmartConnect
 * u4: A MIG DDR3 controller
 * u5: A processor reset (to convert the active-high ui_rst to AXI-MM active low)

![Vivado block design](./misc/arty_jtag_to_ddr3_block_design.png)

The top-level design, arty.sv, instantiates the block design, along with an MMCM to generate 200MHz for the DDR3 IDELAYCTRL reference clock, and logic to blink the LEDs.

## DDR3 reset incorrect logic standard

The Digilent MIG project file defines the DDR3 reset with an I/O standard of SSTL135.

https://github.com/Digilent/vivado-boards/blob/master/new/board_files/arty-a7-35/E.0/1.1/mig.prj#L114

The datasheet for the Micron DDR3L on the Arty board states that the input logic levels are:

 * VIL(max) = 0.2 x 1.35V = 0.27V
 * VIH(min) = 0.8 x 1.35V = 1.08V

The Artix-7 data sheet indicates that SSTL135 output logic levels are

 * VOL(max) = 1.35V/2 - 0.15V = 0.525V
 * VOH(min) = 1.35V/2 + 0.15V = 0.825V

The FPGA DDR3 SSTL135 reset output will be invalid at the DDR3 device!

Changing the I/O standard to LVCMOS12 or LVCMOS15 results in the error message:

![Vivado error message](./misc/arty_ddr3_reset_lvcmos15_error.png)

## Bitstream Generation

1. Start Vivado

2. Change directory to the project folder, eg.,

~~~
	cd {c:/github/digilent_arty/designs/jtag_to_ddr3}
~~~

3. Run the synthesis script

~~~
	source -notrace scripts/vivado.tcl
~~~

## Simulation

1. Start Questasim

2. Change directory to the project folder, eg.,

~~~
	cd {c:/github/digilent_arty/designs/jtag_to_ddr3}
~~~

3. Run the simulation script

~~~
	source -notrace scripts/questasim.tcl
~~~

The script ends with the testbench procedure name:
~~~
	#  
	# Testbench commands
	# ------------------
	#  
	# Questasim 2023.4 simulating with Vivado 2024.1 libraries
	#  
	# arty_tb - run the Arty testbench
	#  
~~~

4. Run the testbench procedure

~~~
	tcl> arty_tb
	... [snip] ...
	# 
	# XilinxAXIVIP: Found at Path: arty_tb.u1.u10.u2_vip.inst
	# This AXI VIP is in passthrough mode
	# 
	# ** Warning: (vsim-3534) [FOFIR] - Failed to open file "design.txt" for reading.
	# No such file or directory. (errno = ENOENT)    : C:/software/Xilinx/Vivado/2024.1/data/verilog/src/unisims/XADC.v(696)
	#    Time: 0 ps  Iteration: 0  Instance: /arty_tb/u1/u10/u4_ddr3/u_system_u4_ddr3_0_mig/temp_mon_enabled/u_tempmon/xadc_supplied_temperature/XADC_inst
	#  *** Warning: The analog data file design.txt for XADC instance arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.temp_mon_enabled.u_tempmon.xadc_supplied_temperature.XADC_inst was not found. Use the SIM_MONITOR_FILE parameter to specify the analog data file name or use the default name: design.txt.
	# 
	############# Write Clocks PLLE2_ADV Parameters #############
	# 
	# nCK_PER_CLK      =       4
	# CLK_PERIOD       =   10000
	# CLKIN1_PERIOD    =  10.000
	# DIVCLK_DIVIDE    =       1
	# CLKFBOUT_MULT    =      13
	# VCO_PERIOD       =   769.0
	# CLKOUT0_DIVIDE_F =       2
	# CLKOUT1_DIVIDE   =       4
	# CLKOUT2_DIVIDE   =      64
	# CLKOUT3_DIVIDE   =      16
	# CLKOUT0_PERIOD   =    1538
	# CLKOUT1_PERIOD   =    3076
	# CLKOUT2_PERIOD   =   49216
	# CLKOUT3_PERIOD   =   12304
	# CLKOUT4_PERIOD   =    6152
	############################################################
	# 
	############# MMCME2_ADV Parameters #############
	# 
	# MMCM_MULT_F           =           8
	# MMCM_VCO_FREQ (MHz)   = 649.000
	# MMCM_VCO_PERIOD       = 1540.832
	#################################################
	# 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : BYTE_LANES_B0 = f BYTE_LANES_B1 = 0 DATA_CTL_B0 = c DATA_CTL_B1 = 0
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : HIGHEST_LANE =           4 HIGHEST_LANE_B0 =           4 HIGHEST_LANE_B1 =           0
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : HIGHEST_BANK =           1
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : FREQ_REF_PERIOD         = 1538.00 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : DDR_TCK                 = 3077 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_S2_TAPS_SIZE         = 12.02 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_CIRC_BUF_EARLY       = 1 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_CIRC_BUF_OFFSET      = 1610.30 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_CIRC_BUF_META_ZONE   = 200.00 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_STG2_FINE_INTR_DLY   = 890.73 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_STG2_COARSE_INTR_DLY = 575.97 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_STG2_INTRINSIC_DELAY = 1466.70 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_CIRC_BUF_DELAY       = 60 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_INTRINSIC_DELAY      = 1466.70 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_DELAY                = 2187.64 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PO_OCLK_DELAY           = 0 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : L_PHY_0_PO_FINE_DELAY   = 60 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PI_STG1_INTRINSIC_DELAY = 0.00 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PI_STG2_INTRINSIC_DELAY = 865.48 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PI_INTRINSIC_DELAY      = 865.48 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PI_MAX_STG2_DELAY       = 756.98 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PI_OFFSET               = 123.00 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : PI_STG2_DELAY           = 123.00 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy :PI_STG2_DELAY_CAND       = 123.00 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : DEFAULT_RCLK_DELAY      = 10 
	# arty_tb.u1.u10.u4_ddr3.u_system_u4_ddr3_0_mig.u_memc_ui_top_axi.mem_intfc0.ddr_phy_top0.u_ddr_mc_phy_wrapper.u_ddr_mc_phy : RCLK_SELECT_EDGE        = 111 
	#  
	# ==========================================================
	# Arty simulation
	# ==========================================================
	#  
	# ----------------------------------------------------------
	# External Reset
	# ----------------------------------------------------------
	# Time: 0.0 ps
	#  
	# External reset asserted
	# External reset deasserted
	#  
	# ----------------------------------------------------------
	# Setup the AXI4 master
	# ----------------------------------------------------------
	# Time: 10000000.0 ps
	#  
	# arty_tb.u2.u1.reset at time 12262022.0 ps WARNING: 200 us is required before RST_N goes inactive.
	# arty_tb.u2.u1.cmd_task at time 12342770.0 ps WARNING: 500 us is required after RST_N goes inactive before CKE goes active.
	#  
	# ----------------------------------------------------------
	# Wait for DDR3 calibration to complete
	# ----------------------------------------------------------
	# Time: 13384999.0 ps
	#  
	# Wait for DDR3 ready to assert
	#  
	# PHY_INIT: Memory Initialization completed at 22132791.0 ps
	# PHY_INIT: Phaser_In Phase Locked at 24077407.0 ps
	# PHY_INIT: Phaser_In DQSFOUND completed at 53382022.0 ps
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60305892.0 ps WARNING: tWLS violation on DQS bit  1 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60305892.0 ps WARNING: tWLS violation on DQS bit  0 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60308969.0 ps WARNING: tWLS violation on DQS bit  1 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60308969.0 ps WARNING: tWLS violation on DQS bit  0 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60456662.0 ps WARNING: tWLS violation on DQS bit  1 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60456662.0 ps WARNING: tWLS violation on DQS bit  0 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60459738.0 ps WARNING: tWLS violation on DQS bit  1 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60459738.0 ps WARNING: tWLS violation on DQS bit  0 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60462815.0 ps WARNING: tWLS violation on DQS bit  1 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60462815.0 ps WARNING: tWLS violation on DQS bit  0 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60465892.0 ps WARNING: tWLS violation on DQS bit  1 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60465892.0 ps WARNING: tWLS violation on DQS bit  0 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60468969.0 ps WARNING: tWLS violation on DQS bit  1 positive edge.  Indeterminate CK capture is possible.
	# arty_tb.u2.u1.dqs_pos_timing_check: at time 60468969.0 ps WARNING: tWLS violation on DQS bit  0 positive edge.  Indeterminate CK capture is possible.
	# PHY_INIT: Write Leveling completed at 60471253.0 ps
	# PHY_INIT : COMPLEX OCLKDELAY calibration completed at 101000483.0 ps
	# PHY_INIT : PRBS/PER_BIT calibration completed at 101000483.0 ps
	# PHY_INIT: Read Leveling Stage 1 completed at 101000483.0 ps
	# PHY_INIT: Write Calibration completed at 112200483.0 ps
	# PHY_INIT: Write Calibration completed at 133751253.0 ps
	#  
	# DDR3 ready asserted at time 136557307.0 ps
	#  
	# ----------------------------------------------------------
	# DDR3 write/read burst transactions
	# ----------------------------------------------------------
	# Time: 136557307.0 ps
	#  
	# Write burst
	#  
	# Read burst
	#  
	# Check read data
	#  * Read checks passed
	#  
	# ----------------------------------------------------------
	# End simulation
	# ----------------------------------------------------------
	# Time: 248843460.0 ps
	#  
~~~

The Questasim waveform window can be used to view the DDR3, the AXI-MM VIP, and the AXI-MM DDR3 controller interface waveforms.

![Vivado block design](./misc/arty_jtag_to_ddr3_questa_waveforms.png)
