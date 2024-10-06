# Digilent Arty DDR3 Example

9/25/2024 D. W. Hawkins (dwh@caltech.edu)

This example design demonstrates the use of the Arty DDR3. 

Digilent shows how to instantiate the Xilinx MIG in a block design:

https://digilent.com/reference/programmable-logic/guides/getting-started-with-ipi

Viktor Nikolov implements a variation of the Arty DDR3 design:
 
https://forum.digilent.com/topic/27389-arty-a7-microblaze-ddr3-tutorial/

https://github.com/viktor-nikolov/MicroBlaze-DDR3-tutorial

The design in this repository implements a block design containing:
 
 * A JTAG-to-AXI bridge (for hardware test)
 * An AXI-MM VIP (for simulation test)
 * A MIG DDR3 controller
 * A processor reset (to convert the active-high ui_rst to AXI-MM active low)
 * An MMCM to generate 200MHz for the DDR3 IDELAYCTRL reference clock

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

