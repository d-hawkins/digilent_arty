// ----------------------------------------------------------------------------
// arty.sv
//
// 9/1/2025 D. W. Hawkins (dwh@caltech.edu)
//
// Digilent Arty Artix-7 top-level design.
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
		output [11:0] led_rgb
	);

	// ------------------------------------------------------------------------
	// Local Parameters
	// ------------------------------------------------------------------------
	//
	// Clock frequency
	localparam real CLK_FREQUENCY = 100.0e6;

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
	// Counter
	logic [WIDTH-1:0] count = '0;

	// RGB duty-cycle control
	logic  [6:0] rgb_count;
	logic        rgb_duty;
	logic [11:0] rgb_en;
	logic [11:0] rgb_control;

	// Reset synchronizer
	wire         rst_n;

	// AXI4-Stream FIFO Transmit
	wire        axis_txd_tready;
	wire        axis_txd_tvalid;
	wire        axis_txd_tlast;
	wire [31:0] axis_txd_tdata;

	// AXI4-Stream FIFO Receive
	wire        axis_rxd_tready;
	wire        axis_rxd_tvalid;
	wire        axis_rxd_tlast;
	wire [31:0] axis_rxd_tdata;

	// ------------------------------------------------------------------------
	// Counter
	// ------------------------------------------------------------------------
	//
	always_ff @(posedge clk_100mhz) begin
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
	// Reset synchronizer
	// ------------------------------------------------------------------------
	//
	xpm_cdc_single #(
		.DEST_SYNC_FF   (4), // Number of synchronizer registers
		.INIT_SYNC_FF   (1), // Simulate init values
		.SIM_ASSERT_CHK (1), // Enable simulation messages
		.SRC_INPUT_REG  (0)  // Additional input register
	) u1 (
		// External control clock domain
		.src_clk (           ),  // Unused when no input register
		.src_in  (ext_reset_n),  // Input signal

		// Synchronous deassertion domain
		.dest_clk(clk_100mhz),  // Destination clock domain.
		.dest_out(rst_n     )   // Synchronized output
	);

	// ------------------------------------------------------------------------
	// 'system' block design
	// ------------------------------------------------------------------------
	//
	system u2 (
		// Reset and clock
		.rst_n           (rst_n          ),
		.clk             (clk_100mhz     ),

		// AXI4-Stream Transmit
		.axis_txd_tready (axis_txd_tready),
		.axis_txd_tvalid (axis_txd_tvalid),
		.axis_txd_tlast  (axis_txd_tlast ),
		.axis_txd_tdata  (axis_txd_tdata ),

		// AXI4-Stream Receive
		.axis_rxd_tready (axis_rxd_tready),
		.axis_rxd_tvalid (axis_rxd_tvalid),
		.axis_rxd_tlast  (axis_rxd_tlast ),
		.axis_rxd_tdata  (axis_rxd_tdata )
	);

	// ------------------------------------------------------------------------
	// AXI4-Stream TXD-to-RXD Loopback
	// ------------------------------------------------------------------------
	//
	// Receive-to-Transmit
	assign axis_txd_tready = axis_rxd_tvalid;
	//
	// Transmit-to-Receive
	assign axis_rxd_tvalid = axis_txd_tvalid;
	assign axis_rxd_tlast  = axis_txd_tlast;
	assign axis_rxd_tdata  = axis_txd_tdata;

endmodule

