// ----------------------------------------------------------------------------
// arty.sv
//
// 6/19/2024 D. W. Hawkins (dwh@caltech.edu)
//
// Digilent Arty Artix-7 'blinky' design.
//
// When the Arty board is oriented with the Ethernet RJ45 connector on the
// left-side, the LEDs are located on the bottom left corner. The four Green
// LEDs are located above the four RGB LEDs. The 'blinky' design generates
// the same 4-bit count on the Green and RGB LEDs, but the color of the RGB
// LEDs changes as the count increases.
//
// ----------------------------------------------------------------------------

module arty  (
		// Green LEDs
		output  [3:0] led_g,

		// RGB LEDs
		output [11:0] led_rgb
	);

	// ------------------------------------------------------------------------
	// Local Parameters
	// ------------------------------------------------------------------------
	//
	// Clock frequency (65MHz per Artix-7 DS181)
	localparam real CLK_FREQUENCY = 65.0e6;

	// LED blink rate
	localparam real BLINK_PERIOD = 0.5;

	// Counter width
	//
	// Note: the integer'() casts are important, without them Vivado
	// generates incorrect counter widths (much wider than expected)
	//
	// 4 LEDs driven by 65MHz
	// - Plus 3 extra MSBs for RGB color control
	localparam integer WIDTH =
		$clog2(integer'(CLK_FREQUENCY*BLINK_PERIOD))+6;

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// CFGMCLK
	logic cfgmclk;

	// Global clock buffer
	logic clk_65mhz;

	// DONE LED
	logic done;

	// Counter
	logic [WIDTH-1:0] count = '0;

	// RGB duty-cycle control
	logic  [6:0] rgb_count;
	logic        rgb_duty;
	logic [11:0] rgb_en;
	logic [11:0] rgb_control;

	// ------------------------------------------------------------------------
	// STARTUPE2
	// ------------------------------------------------------------------------
	//
	STARTUPE2 #(
		.PROG_USR("FALSE"),
		.SIM_CCLK_FREQ(0.0)
	) u1 (
		.CFGCLK    (       ),
		.CFGMCLK   (cfgmclk), // 65MHz oscillator
		.EOS       (       ),
		.PREQ      (       ),
		.CLK       (1'b0   ),
		.GSR       (1'b0   ),
		.GTS       (1'b0   ),
		.KEYCLEARB (1'b0   ),
		.PACK      (1'b0   ),
		.USRCCLKO  (1'b0   ),
		.USRCCLKTS (1'b1   ),
		.USRDONEO  (done   ),
		.USRDONETS (1'b0   )
	);

	// DONE LED
	assign done = count[WIDTH-7];

	// ------------------------------------------------------------------------
	// Global clock buffer
	// ------------------------------------------------------------------------
	//
	BUFG u2 (
		.I(cfgmclk  ),
		.O(clk_65mhz)
	);

	// ------------------------------------------------------------------------
	// Counter
	// ------------------------------------------------------------------------
	//
	always_ff @(posedge clk_65mhz) begin
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

endmodule

