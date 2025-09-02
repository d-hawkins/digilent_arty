// ----------------------------------------------------------------------------
// arty_tb.sv
//
// 9/1/2025 D. W. Hawkins (dwh@caltech.edu)
//
// Digilent Arty testbench.
//
// ----------------------------------------------------------------------------

module arty_tb;

	// ------------------------------------------------------------------------
	// Packages
	// ------------------------------------------------------------------------
	//
	// Vivado Verification IP
	import axi_vip_pkg::*;
	//
	// AXI4 Master instance
	// * 'system' block design instance 'u2_vip'
	import system_u2_vip_0_pkg::*;
	//
	// Test package
	import arty_test_pkg::*;

	// ------------------------------------------------------------------------
	// Types
	// ------------------------------------------------------------------------
	//
	// The auto-generated packages are missing these typedefs. These VIF types
	// are needed, so that user test classes can pass VIF handles.

	// AXI-MM Passthrough virtual interface type
	//  * See arty.gen/sources_1/bd/system/ip/system_u2_vip_0/sim
	//    for the parameter order to the agent typedef.
	typedef virtual axi_vip_if #(
		system_u2_vip_0_VIP_PROTOCOL,
		system_u2_vip_0_VIP_ADDR_WIDTH,
		system_u2_vip_0_VIP_DATA_WIDTH,
		system_u2_vip_0_VIP_DATA_WIDTH,
		system_u2_vip_0_VIP_ID_WIDTH,
		system_u2_vip_0_VIP_ID_WIDTH,
		system_u2_vip_0_VIP_AWUSER_WIDTH,
		system_u2_vip_0_VIP_WUSER_WIDTH,
		system_u2_vip_0_VIP_BUSER_WIDTH,
		system_u2_vip_0_VIP_ARUSER_WIDTH,
		system_u2_vip_0_VIP_RUSER_WIDTH,
		system_u2_vip_0_VIP_SUPPORTS_NARROW,
		system_u2_vip_0_VIP_HAS_BURST,
		system_u2_vip_0_VIP_HAS_LOCK,
		system_u2_vip_0_VIP_HAS_CACHE,
		system_u2_vip_0_VIP_HAS_REGION,
		system_u2_vip_0_VIP_HAS_PROT,
		system_u2_vip_0_VIP_HAS_QOS,
		system_u2_vip_0_VIP_HAS_WSTRB,
		system_u2_vip_0_VIP_HAS_BRESP,
		system_u2_vip_0_VIP_HAS_RRESP,
		system_u2_vip_0_VIP_HAS_ARESETN
	) system_u2_vip_0_passthrough_vif_t;

	// Parameterized test class
	// * The parameters are the types used in the Vivado block design
	// * Using parameters allows the block design name, and the
	//   instance names to change, without needing to change the test.
	//
	typedef arty_test #(
		system_u2_vip_0_passthrough_vif_t,
		system_u2_vip_0_passthrough_t
	) arty_test_t;

	// ------------------------------------------------------------------------
	// Local parameters
	// ------------------------------------------------------------------------
	//
	// Clock frequency
	localparam real CLK_FREQUENCY = 100.0e6;

	// Clock period
	localparam time CLK_PERIOD = (1.0e9/CLK_FREQUENCY)*1ns;

	// ------------------------------------------------------------------------
	// Local Signals
	// ------------------------------------------------------------------------
	//
	// Arty ports
	logic        ext_reset_n;
	logic        clk_100mhz;
	wire   [3:0] led_g;
	wire  [11:0] led_rgb;

	// ------------------------------------------------------------------------
	// Clock generator
	// ------------------------------------------------------------------------
	//
	initial begin
		clk_100mhz = 1'b0;
		forever begin
			#(CLK_PERIOD/2) clk_100mhz = ~clk_100mhz;
		end
	end

	// ------------------------------------------------------------------------
	// Reset generator
	// ------------------------------------------------------------------------
	//
	initial begin
		// Asserted
		ext_reset_n = 1'b0;

		// Wait
		#(50*CLK_PERIOD);

		// Deasserted
		ext_reset_n = 1'b1;
	end

	// ------------------------------------------------------------------------
	// Arty design
	// ------------------------------------------------------------------------
	//
	arty u1 (
		.ext_reset_n  (ext_reset_n ),
		.clk_100mhz   (clk_100mhz  ),
		.led_g        (led_g       ),
		.led_rgb      (led_rgb     )
	);

	// ========================================================================
	// Stimulus
	// ========================================================================
	//
	arty_test_t test;
	initial begin
		// Time string format
		$timeformat(-9, 2, " ns", 20);

		$display(" ");
		$display("==========================================================");
		$display("Arty PG080 AXI4-Stream FIFO simulation");
		$display("==========================================================");
		$display("Time: %0t", $time);
		$display(" ");

		$display("VIP data width = %0d",
			system_u2_vip_0_VIP_DATA_WIDTH);

		// --------------------------------------------------------------------
		// Construct the test
		// --------------------------------------------------------------------
		//
		$display(" ");
		$display("----------------------------------------------------------");
		$display("Construct the test");
		$display("----------------------------------------------------------");
		$display("Time: %0t",$time);
		$display(" ");

		// Construct the test
		// * u1.u2 = 'system' instance in arty.sv
		// * Pass the AXI-MM master virtual interface and the FIFO depth
		test = new(
			u1.u2.u2_vip.inst.IF,
			u1.u2.u4_fifo.U0.C_TX_FIFO_DEPTH,
			u1.u2.u4_fifo.U0.C_RX_FIFO_DEPTH
		);

		// Change the AXI-MM VIP from pass-through to master mode
		u1.u2.u2_vip.inst.set_master_mode();

		// --------------------------------------------------------------------
		// Run Test
		// --------------------------------------------------------------------
		//
		$display(" ");
		$display("----------------------------------------------------------");
		$display("Run Test");
		$display("----------------------------------------------------------");
		$display("Time: %0t",$time);
		$display(" ");

		// A test-suite could use pass a string argument to the testbench,
		// and pass that as an argument to run() to select a specific test.
		test.run();

		// --------------------------------------------------------------------
		// End simulation
		// --------------------------------------------------------------------
		//
		$display(" ");
		$display("----------------------------------------------------------");
		$display("End simulation");
		$display("----------------------------------------------------------");
		$display("Time: %0t", $time);
		$display(" ");
		$stop(0);
	end

endmodule
