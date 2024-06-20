# Xilinx JESD204C Analysis

# Digilent Arty

6/19/2024 D. W. Hawkins (dwh@caltech.edu)

# Introduction

This directory contains example designs for the Digilent Arty board.

Digilent provides an extensive reference manual and reference designs for this board - see the Resources below.

## Repository Contents

Directory           | Contents
--------------------|-----------
designs             | Hardware designs
references          | Reference documentation

## Arty Features

* Xilinx Artix-7 (XC7A35T-1CSG324I) FPGA
* 33,280 logic cells in 5,200 slices (each slice contains four 6-input LUTs and 8 flip-flops)
* 1,800 Kbits (50 x 36Kbits BRAMs) of fast block RAM
* Five clock management tiles, each with a phase-locked loop (PLL)
* 90 DSP slices (DSP48E1 with pre-add, 25x18-bit multiply, 48-bit post-add/accumulate)
* Internal clock speeds exceeding 450 MHz
* On-chip analog-to-digital converter (XADC)
* Digilent USB-JTAG port for FPGA programming and communication
* USB-UART Bridge
* 10/100 Mbps Ethernet
* 256MB DDR3L (16-bit bus at 667MHz)
* 16MB Quad-SPI Flash
* 4 user switches
* 4 user buttons
* 1 reset button
* 4 LEDs
* 4 RGB LEDs
* 4 Pmod connectors
* Arduino shield connector

# Resources

Document | Link
---------|-----
Digilent board ($99) with Reference Manual and Schematic | http://store.digilentinc.com/arty-board-artix-7-fpga-development-board-for-makers-and-hobbyists/
Digilent Arty Reference Manual | https://reference.digilentinc.com/reference/programmable-logic/arty/reference-manual
Tutorials | https://reference.digilentinc.com/reference/programmable-logic/arty/start
Digilent Github | https://github.com/Digilent
Vivado Board Files | https://github.com/Digilent/vivado-boards
Vivado Board Files Instructions | https://reference.digilentinc.com/reference/software/vivado/board-files
Arty repo with XDC constraints and tutorial source | https://github.com/Digilent/Arty
Digilent Github examples build procedure | https://reference.digilentinc.com/learn/software/tutorials/vivado-projects-from-digilent-github/start

# Notes

Notes from the Digilent documentation:
* The board supports programming via JTAG and Quad-SPI flash (jumper selectable)
* The USB-UART is an FTDI FT2232HQ
* The two-channel FTDI FT2232HQ is used as a Digilent USB-JTAG programmer and a USB-UART
* The QSPI Flash is a 16Mbit Micron N25Q128A13ESF40 (bitfiles are around 16Mbit)
* The reference clock is a 100MHz oscillator connected to E3
* There are four PMOD connectors; two of them connect to the XADC inputs
* The Artix-7 XADC is a 1MSps 12-bit dual-channel ADC (see UG480 for details)
* The XC7A35T in CS324 does not have GTP transceivers
* The schematic does not include the FTDI interface (the page is missing)
* The Tutorials web page has links to multiple tutorials, which in turn link to the github repo containing the tutorial source

# Git LFS Installation

This repository was created using the github web interface, then checked out using Windows 10 WSL, and git LFS was installed using

~~~
$ git clone git@github.com:d-hawkins/digilent_arty.git
$ cd digilent_arty/
$ git lfs install
~~~

The .gitattributes file from another repo was then copied to this repo, and that file checked in.

~~~
$ git add .gitattributes
$ git commit -m "Git LFS tracking" .gitattributes
$ git push
~~~

The .gitattributes file contains file extension patterns for the majority of binary file types that could be checked into the repo (additional patterns can be added as needed).

