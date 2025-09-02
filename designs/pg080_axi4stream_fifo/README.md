# Digilent Arty PG080 AXI4-Stream FIFO Example

9/25/2024 D. W. Hawkins (dwh@caltech.edu)

This example design demonstrates the use of the Xilinx PG080 AXI4-Stream FIFO

https://docs.amd.com/r/en-US/pg080-axi-fifo-mm-s 

The design implements:

 * A top-level SystemVerilog design
 * A Vivado block design called 'system' containing:
   - u1: A JTAG-to-AXI bridge (for hardware test)
   - u2: An AXI-MM VIP (for simulation test)
   - u3: An AXI SmartConnect
   - u4: An AXI4-Stream FIFO with ports exported to the top-level
 * The AXI4-Stream TXD and RXD are looped-back at the top-level

Vivado block design:  
![Vivado block design](./misc/arty_system.png)

## Bitstream Generation

1. Start Vivado

2. Change directory to the project folder, eg.,

~~~
	cd {c:/github/digilent_arty/designs/pg080_axi4stream_fifo}
~~~

3. Run the synthesis script

~~~
	source -notrace scripts/vivado.tcl
~~~

## Simulation

1. Start Questasim

2. Change directory to the project folder, eg.,

~~~
	cd {c:/github/digilent_arty/designs/pg080_axi4stream_fifo}
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
	# XilinxAXIVIP: Found at Path: arty_tb.u1.u2.u2_vip.inst
	# This AXI VIP is in passthrough mode
	#  
	# ==========================================================
	# Arty PG080 AXI4-Stream FIFO simulation
	# ==========================================================
	# Time: 0.00 ns
	#  
	# VIP data width = 32
	#  
	# ----------------------------------------------------------
	# Construct the test
	# ----------------------------------------------------------
	# Time: 0.00 ns
	#  
	# ----------------------------------------------------------
	# Run Test
	# ----------------------------------------------------------
	# Time: 0.00 ns
	#  
	# arty_test::run() started
	#  
	# ----------------------------------------------------------
	# Reset
	# ----------------------------------------------------------
	# Time: 545.00 ns
	# 
	# Wait for reset to deassert
	#  * Reset deasserted
	#  
	# ----------------------------------------------------------
	# FIFO Transmit/Receive Tests
	# ----------------------------------------------------------
	# Time: 5555.00 ns
	#  
	# TXD FIFO depth = 2048
	# RXD FIFO depth = 2048
	#  
	# ----------------------------------------------------------
	# Transmit 2048 x 32-bit words
	# ----------------------------------------------------------
	# Time: 5555.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h0800 words to FIFO
	# TXD vacancy = 32'h00000ffe
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 2048 x 32-bit words
	# ----------------------------------------------------------
	# Time: 30315.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000800
	# RXD length = 32'h00002000
	# Read and check 32'h0800 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 1024 x 32-bit words
	# ----------------------------------------------------------
	# Time: 73985.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h0400 words to FIFO
	# TXD vacancy = 32'h000003fe
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 1024 x 32-bit words
	# ----------------------------------------------------------
	# Time: 87345.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000400
	# RXD length = 32'h00001000
	# Read and check 32'h0400 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 512 x 32-bit words
	# ----------------------------------------------------------
	# Time: 109335.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h0200 words to FIFO
	# TXD vacancy = 32'h000005fe
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 512 x 32-bit words
	# ----------------------------------------------------------
	# Time: 116995.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000200
	# RXD length = 32'h00000800
	# Read and check 32'h0200 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 256 x 32-bit words
	# ----------------------------------------------------------
	# Time: 128145.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h0100 words to FIFO
	# TXD vacancy = 32'h000006fe
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 256 x 32-bit words
	# ----------------------------------------------------------
	# Time: 132955.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000100
	# RXD length = 32'h00000400
	# Read and check 32'h0100 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 128 x 32-bit words
	# ----------------------------------------------------------
	# Time: 139985.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h0080 words to FIFO
	# TXD vacancy = 32'h0000077e
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 128 x 32-bit words
	# ----------------------------------------------------------
	# Time: 143515.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000080
	# RXD length = 32'h00000200
	# Read and check 32'h0080 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 2000 x 32-bit words
	# ----------------------------------------------------------
	# Time: 147965.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h07d0 words to FIFO
	# TXD vacancy = 32'h0000002e
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 2000 x 32-bit words
	# ----------------------------------------------------------
	# Time: 172245.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h000007d0
	# RXD length = 32'h00001f40
	# Read and check 32'h07d0 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 1000 x 32-bit words
	# ----------------------------------------------------------
	# Time: 215435.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h03e8 words to FIFO
	# TXD vacancy = 32'h00000416
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 1000 x 32-bit words
	# ----------------------------------------------------------
	# Time: 228555.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h000003e8
	# RXD length = 32'h00000fa0
	# Read and check 32'h03e8 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 500 x 32-bit words
	# ----------------------------------------------------------
	# Time: 250305.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h01f4 words to FIFO
	# TXD vacancy = 32'h0000060a
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 500 x 32-bit words
	# ----------------------------------------------------------
	# Time: 257845.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h000001f4
	# RXD length = 32'h000007d0
	# Read and check 32'h01f4 words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 300 x 32-bit words
	# ----------------------------------------------------------
	# Time: 268875.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h012c words to FIFO
	# TXD vacancy = 32'h000006d2
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 300 x 32-bit words
	# ----------------------------------------------------------
	# Time: 274415.00 ns
	#  
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h00000000
	# RXD occupancy register  = 32'h0000012c
	# RXD length = 32'h000004b0
	# Read and check 32'h012c words from FIFO
	#  * write/read checks all passed.
	#  
	# ----------------------------------------------------------
	# Transmit 100 x 32-bit words
	# ----------------------------------------------------------
	# Time: 282145.00 ns
	#  
	# TXD vacancy = 32'h000007fc
	# Write 32'h0064 words to FIFO
	# TXD vacancy = 32'h0000079a
	# Send the packet
	#  
	# ----------------------------------------------------------
	# Receive 100 x 32-bit words
	# ----------------------------------------------------------
	# Time: 285395.00 ns
	#  
	# RXD occupancy register  = 32'h00000064
	# RXD length = 32'h00000190
	# Read and check 32'h0064 words from FIFO
	#  * write/read checks all passed.
	# 
	# arty_test::run() ended
	#  
	# ----------------------------------------------------------
	# End simulation
	# ----------------------------------------------------------
	# Time: 289265.00 ns
	#  
~~~

The Questasim waveform window shows the AXI4-Stream and AXI-MM waveforms.

![Questasim waveforms](./misc/arty_questa_waveforms.png)
