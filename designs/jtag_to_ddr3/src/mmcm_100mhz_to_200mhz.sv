// ----------------------------------------------------------------------------
// mmcm_100mhz_to_200mhz.sv
//
// 10/5/2024 D. W. Hawkins (dwh@caltech.edu)
//
// Digilent Arty 100MHz to 200MHz generation.
//
// The DDR3 controller IDELAYCTRL component requires 200MHz, so an MMCM is
// used to generate it from the external 100MHz source.
//
// ----------------------------------------------------------------------------
// Core Generation
// ---------------
//
// Generated using "Clocking Wizard" v6.0 (Vivado 2024.1).
//
// Clocking Options Tab:
//  * Primitive: MMCM
//  * Clock Features: Frequency Synthesis
//  * Jitter Optimization: Balanced
//  * Input lock 'clk_in1' 100.0MHz
//
// Output Clocks Tab:
//  * Ouput clock 'clk_out1' 200.0MHz
//  * 'reset' input checked (active high selected)
//  * 'locked' output checked
//
// MMCM Settings Tab:
//  * CLKFBOUT_MULT_F 10.000     (VCO at 1000MHz)
//  * CLKIN1_PERIOD   10.000     (100MHz input
//  * DIVCLK_DIVIDE   1
//  * CLKOUT0 divide  5.000      (200MHz output)
//
// ----------------------------------------------------------------------------

module mmcm_100mhz_to_200mhz (
		// Reset
		input         reset,

		// Locked
		output        locked,

		// Clock input
		input         clk_100mhz,

		// Clock out ports
		output        clk_200mhz
	);

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	logic pll_fb_out;
	logic pll_fb_in;
	logic pll_200mhz;

	// ------------------------------------------------------------------------
	// MMCM
	// ------------------------------------------------------------------------
	//
	MMCME2_ADV #(
		.BANDWIDTH            ("OPTIMIZED"),
		.CLKOUT4_CASCADE      ("FALSE"),
		.COMPENSATION         ("ZHOLD"),
		.STARTUP_WAIT         ("FALSE"),
		.DIVCLK_DIVIDE        (1),           // F_PFD = 100MHz
		.CLKFBOUT_MULT_F      (10.000),      // F_VCO = 1000MHz
		.CLKFBOUT_PHASE       (0.000),
		.CLKFBOUT_USE_FINE_PS ("FALSE"),
		.CLKOUT0_DIVIDE_F     (5.000),       // F_OUT = 200MHz
		.CLKOUT0_PHASE        (0.000),
		.CLKOUT0_DUTY_CYCLE   (0.500),
		.CLKOUT0_USE_FINE_PS  ("FALSE"),
		.CLKIN1_PERIOD        (10.000)       // F_IN = 100MHz
	) u1 (
		// Reset
		.RST                 (reset     ),

		// Locked
		.LOCKED              (locked    ),

		// Input clock
		.CLKIN1              (clk_100mhz),
		.CLKIN2              (1'b0      ),
		.CLKINSEL            (1'b1      ),  // Use CLKIN1

		// Feedback clock
		.CLKFBIN             (pll_fb_in ),
		.CLKFBOUT            (pll_fb_out),
		.CLKFBOUTB           (          ),

		// 200MHz output clock
		.CLKOUT0             (pll_200mhz),
		.CLKOUT0B            (          ),

		// Unused output clocks
		.CLKOUT1             ( ),
		.CLKOUT1B            ( ),
		.CLKOUT2             ( ),
		.CLKOUT2B            ( ),
		.CLKOUT3             ( ),
		.CLKOUT3B            ( ),
		.CLKOUT4             ( ),
		.CLKOUT5             ( ),
		.CLKOUT6             ( ),

		// Unused ports
		.DADDR               (7'h0 ),
		.DCLK                (1'b0 ),
		.DEN                 (1'b0 ),
		.DI                  (16'h0),
		.DO                  (     ),
		.DRDY                (     ),
		.DWE                 (1'b0 ),
		.PSCLK               (1'b0 ),
		.PSEN                (1'b0 ),
		.PSINCDEC            (1'b0 ),
		.PSDONE              (     ),
		.CLKINSTOPPED        (     ),
		.CLKFBSTOPPED        (     ),
		.PWRDWN              (1'b0 )
	);

	// ------------------------------------------------------------------------
	// BUFGs
	// ------------------------------------------------------------------------
	//
	// Feedback clock
	BUFG u2 (
		.I (pll_fb_out),
		.O (pll_fb_in)
	);

	// 200MHz output
	BUFG u3 (
		.I   (pll_200mhz),
		.O   (clk_200mhz)
	);

endmodule
