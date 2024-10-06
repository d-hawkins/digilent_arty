// ----------------------------------------------------------------------------
// arty.sv
//
// 6/19/2024 D. W. Hawkins (dwh@caltech.edu)
//
// Digilent Arty Artix-7 'jtag_to_ddr3' design.
//
// ----------------------------------------------------------------------------

module arty  (
		// External reset
		input         ext_reset_n,

		// 100MHz clock
		input         clk_100mhz,

		// Green LEDs
		output  [3:0] led_g,

		// RGB LEDs
		output [11:0] led_rgb,

		// DDR3 SDRAM
		output        ddr3_reset_n,
		output        ddr3_ck_p,
		output        ddr3_ck_n,
		output        ddr3_cs_n,
		output        ddr3_ras_n,
		output        ddr3_cas_n,
		output        ddr3_we_n,
		output        ddr3_cke,
		output        ddr3_odt,
		output [13:0] ddr3_addr,
		output  [2:0] ddr3_ba,
		output  [1:0] ddr3_dm,
		inout   [1:0] ddr3_dqs_p,
		inout   [1:0] ddr3_dqs_n,
		inout  [15:0] ddr3_dq
	);

	// ------------------------------------------------------------------------
	// Local Parameters
	// ------------------------------------------------------------------------
	//
	// Clock frequency
	localparam real CLK_FREQUENCY = 200.0e6;

	// LED blink rate
	localparam real BLINK_PERIOD = 0.5;

	// Counter width
	//
	// Note: the integer'() casts are important, without them Vivado
	// generates incorrect counter widths (much wider than expected)
	//
	// 4 LEDs driven by 100MHz
	// - Plus 3 extra MSBs for RGB color control
	localparam integer WIDTH =
		$clog2(integer'(CLK_FREQUENCY*BLINK_PERIOD))+6;

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// 100MHz IBUF
	wire clk_100mhz_in;

	// MMCM
	wire pll_locked;
	wire clk_200mhz;

	// Counter
	logic [WIDTH-1:0] count = '0;

	// RGB duty-cycle control
	logic  [6:0] rgb_count;
	logic        rgb_duty;
	logic [11:0] rgb_en;
	logic [11:0] rgb_control;

	// DDR3 MIG reset
    wire ddr3_sys_rst_n;

	// DDR3 status
    wire ddr3_locked;
    wire ddr3_ready;

	// ------------------------------------------------------------------------
	// Input buffer
	// ------------------------------------------------------------------------
	//
	IBUF u1 (
		.I (clk_100mhz   ),
		.O (clk_100mhz_in)
	);

	// ------------------------------------------------------------------------
	// MMCM
	// ------------------------------------------------------------------------
	//
	mmcm_100mhz_to_200mhz u2 (
		.reset      (~ext_reset_n ),
		.locked     (pll_locked   ),
		.clk_100mhz (clk_100mhz_in),  // IBUF input
		.clk_200mhz (clk_200mhz   )   // BUFG output
	);

	// --------------------------------------------------------------
	// Reset synchronizer
	// --------------------------------------------------------------
	//
	xpm_cdc_single #(
		.DEST_SYNC_FF   (4), // Number of synchronizer registers
		.INIT_SYNC_FF   (1), // Simulate init values
		.SIM_ASSERT_CHK (1), // Enable simulation messages
		.SRC_INPUT_REG  (0)  // Additional input register
	) u3 (
		// External control clock domain
		.src_clk (              ),  // Unused when no input register
		.src_in  (pll_locked    ),  // Input signal

		// Synchronous deassertion domain
		.dest_clk(clk_200mhz    ),  // Destination clock domain.
		.dest_out(ddr3_sys_rst_n)   // Synchronized output
	);

	// ------------------------------------------------------------------------
	// Counter
	// ------------------------------------------------------------------------
	//
	always_ff @(posedge clk_200mhz) begin
		count <= count + 1;
	end

	// ------------------------------------------------------------------------
	// Green LEDs
	// ------------------------------------------------------------------------
	//
	assign led_g = count[WIDTH-4:WIDTH-7];

	// ------------------------------------------------------------------------
	// RGB LEDs
	// ------------------------------------------------------------------------
	//
	// 12.5% duty-cycle
	assign rgb_duty = (count[2:0] == 3'h0) ? 1'b1 : 1'b0;

	// RGB LEDs
	// --------
	//
	// - There are 4 RGB LEDs, with 3-bits controlling the LED color:
	//
	//     3'b000 = off
	//     3'b001 = red
	//     3'b010 = green
	//     3'b100 = blue
	//
	// - 7-bits of the counter are used to control the LEDs. The 3-MSBs control
	//   the color, while the 4-LSBs control the count (which of the LEDs are
	//   enabled) from 0 to 15.
	//
	//   7'b000-xxxx =                off + count 0 to 15
	//   7'b001-xxxx =                red + count 0 to 15
	//   7'b010-xxxx =        green       + count 0 to 15
	//   7'b011-xxxx =        green + red + count 0 to 15
	//   7'b100-xxxx = blue               + count 0 to 15
	//   7'b101-xxxx = blue +         red + count 0 to 15
	//   7'b110-xxxx = blue + green       + count 0 to 15 (looks cyan)
	//   7'b111-xxxx = blue + green + red + count 0 to 15
	//
	// Counter 7-MSBs
	assign rgb_count = count[WIDTH-1:WIDTH-7];

	// RGB LED enables
	assign rgb_en =
		{{3{rgb_count[3]}}, {3{rgb_count[2]}}, {3{rgb_count[1]}}, {3{rgb_count[0]}}};

	// Color and count
	assign rgb_control = {4{rgb_count[6:4]}} & rgb_en;

   	// Duty-cycled RGB output
    assign led_rgb = rgb_duty ? rgb_control : 12'h000;

	// ------------------------------------------------------------------------
	// Block Design
	// ------------------------------------------------------------------------
	//
	system u10 (
		// Active low reset to MIG
		.ddr3_sys_rst_n (ddr3_sys_rst_n),

		// Clocks to MIG
		.ddr3_sys_clk   (clk_100mhz_in),
		.ddr3_ref_clk   (clk_200mhz   ),

		// DDR3 SDRAM interface
		.ddr3_reset_n   (ddr3_reset_n),
		.ddr3_ck_p      (ddr3_ck_p   ),
		.ddr3_ck_n      (ddr3_ck_n   ),
		.ddr3_cs_n      (ddr3_cs_n   ),
		.ddr3_ras_n     (ddr3_ras_n  ),
		.ddr3_cas_n     (ddr3_cas_n  ),
		.ddr3_we_n      (ddr3_we_n   ),
		.ddr3_cke       (ddr3_cke    ),
		.ddr3_odt       (ddr3_odt    ),
		.ddr3_addr      (ddr3_addr   ),
		.ddr3_ba        (ddr3_ba     ),
		.ddr3_dm        (ddr3_dm     ),
		.ddr3_dqs_p     (ddr3_dqs_p  ),
		.ddr3_dqs_n     (ddr3_dqs_n  ),
		.ddr3_dq        (ddr3_dq     ),
		.ddr3_locked    (ddr3_locked ),  // MMCM locked
		.ddr3_ready     (ddr3_ready  )   // Calibration complete
	);
endmodule

