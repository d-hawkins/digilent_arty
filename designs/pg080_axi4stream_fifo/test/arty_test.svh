// ----------------------------------------------------------------------------
// arty_test.svh
//
// 9/1/2025 D. Hawkins (dwh@caltech.edu)
//
// Digilent Arty AXI4-Stream FIFO design test package.
//
// This file is tick-included into arty_test_pkg.sv and should not be
// compiled directly.
//
// ----------------------------------------------------------------------------
// References
// ----------
//
// [1] AMD/Xilinx, "PG080: AXI4-Stream FIFO (v4.3)", Nov. 8, 2023.
//     https://docs.amd.com/r/en-US/pg080-axi-fifo-mm-s
//
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Test Class
// ----------------------------------------------------------------------------
//
class arty_test #(
	type AXI_MASTER_VIF_TYPE=int,
	type AXI_MASTER_TYPE=int
);

	// ------------------------------------------------------------------------
	// System Address Map
	// ------------------------------------------------------------------------
	//
	// AXI4-Stream FIFO AXI-MM Lite Interface
	localparam int AXIS_FIFO_LITE_BASE = 32'h0000_0000;
	//
	// AXI4-Stream FIFO AXI-MM Full Interface
	localparam int AXIS_FIFO_FULL_BASE = 32'h0001_0000;

	// ------------------------------------------------------------------------
	// Member variables
	// ------------------------------------------------------------------------
	//
	// AXI4-MM master
	AXI_MASTER_VIF_TYPE m_master_vif;
	AXI_MASTER_TYPE     m_master;

	// AXI-MM VIP started
	bit m_start;

	// Memory-mapped interfaces
	aximm_memory #(AXI_MASTER_TYPE) m_fifo_lite;
	aximm_memory #(AXI_MASTER_TYPE) m_fifo_full;

	// AXIS FIFO depth
	int unsigned m_txd_fifo_depth;
	int unsigned m_rxd_fifo_depth;

	// ------------------------------------------------------------------------
	// Constructor
	// ------------------------------------------------------------------------
	//
	function new(
		AXI_MASTER_VIF_TYPE master_vif,
		int unsigned txd_fifo_depth,
		int unsigned rxd_fifo_depth
	);

		// Virtual Interfaces
		// ------------------
		m_master_vif = master_vif;

		// AXI4-MM Master
		// -------------------
		//
		// Constructor
		m_master = new("master", master_vif);
		//
		// Debug message tag
		m_master.set_agent_tag("AXI VIP Master");
		//
		// Verbosity
	    m_master.set_verbosity(0);   // 0 = No messages, 400 = all messages

		// AXI4-MM Master Devices
		// ----------------------
		//
		m_fifo_lite = new(m_master, AXIS_FIFO_LITE_BASE);
		m_fifo_full = new(m_master, AXIS_FIFO_FULL_BASE);

	    // VIPs have not been started
	    m_start = 1'b0;

	    // AXIS FIFO depth
	    m_txd_fifo_depth = txd_fifo_depth;
	    m_rxd_fifo_depth = rxd_fifo_depth;
	endfunction

	// ========================================================================
	// Member tasks
	// ========================================================================
	//
	// ------------------------------------------------------------------------
	// Start the VIPs
	// ------------------------------------------------------------------------
	//
	// The VIP start tasks should only be called once. The test run() task can
	// be run multiple times, so start() is called only if m_start is zero.
	//
	task automatic start();
		axi_ready_gen rready_gen;

		// Do nothing if VIPs have already been started
		if (m_start) begin
			return;
		end

		// AXI4-MM Master
		m_master.start_master();

		// Turn off AXI-MM read RREADY backpressure
		rready_gen = m_master.mst_rd_driver.create_ready("rready");
		rready_gen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
		m_master.mst_rd_driver.send_rready(rready_gen);

		// VIPs have been started
		m_start = 1'b1;

	endtask

	// ------------------------------------------------------------------------
	// Write/read/check test
	// ------------------------------------------------------------------------
	//
	task automatic write_read_check(int unsigned axi_len);
		int unsigned axi_wdata;
		int unsigned axi_rdata;
		int unsigned axi_wdata_array[];
		int unsigned axi_rdata_array[];

		// --------------------------------------------------------------------
		// FIFO Transmit
		// --------------------------------------------------------------------
		//
		$display(" ");
		$display("----------------------------------------------------------");
		$display("Transmit %0d x 32-bit words", axi_len);
		$display("----------------------------------------------------------");
		$display("Time: %0t",$time);
		$display(" ");

		// Read the TXD vacancy register
		m_fifo_lite.read_single('h0C, axi_rdata);
		$display("TXD vacancy = 32'h%.8h", axi_rdata);

		// Write data
		axi_wdata_array = new[axi_len];
		for (int i = 0; i < axi_len; i++) begin
			axi_wdata_array[i] = i;
		end
		$display("Write 32'h%.4h words to FIFO", axi_len);
		m_fifo_full.write_burst(0, axi_wdata_array, 1'b1);

		// Read the TXD vacancy register
		m_fifo_lite.read_single('h0C, axi_rdata);
		$display("TXD vacancy = 32'h%.8h", axi_rdata);

		// Write to the transmit length register to send the packet
		// (the length is in bytes)
		$display("Send the packet");
		m_fifo_lite.write_single('h14, 4*axi_len);

		// Wait
		#1us;

		// --------------------------------------------------------------------
		// FIFO Receive
		// --------------------------------------------------------------------
		//
		$display(" ");
		$display("----------------------------------------------------------");
		$display("Receive %0d x 32-bit words", axi_len);
		$display("----------------------------------------------------------");
		$display("Time: %0t",$time);
		$display(" ");

		// Poll the RXD occupancy register until it is non-zero
		while (1) begin
			m_fifo_lite.read_single('h1C, axi_rdata);
			$display("RXD occupancy register  = 32'h%.8h", axi_rdata);
			if (axi_rdata != axi_len) begin
				// Wait
				#1us;
			end
			else begin
				break;
			end
		end

		// Read the Receive Length Register (RLR)
		m_fifo_lite.read_single('h24, axi_rdata);
		$display("RXD length = 32'h%.8h", axi_rdata);

		// Read and check data
		$display("Read and check 32'h%.4h words from FIFO", axi_len);
		m_fifo_full.read_burst_and_check('h1000, axi_wdata_array, 1'b1);

		// Wait
		#1us;

	endtask

	// ------------------------------------------------------------------------
	// Run the test
	// ------------------------------------------------------------------------
	//
	task automatic run();
		int unsigned axi_len;
		$display("arty_test::run() started");

		// --------------------------------------------------------------------
		// Start the VIPs
		// --------------------------------------------------------------------
		//
		start();

		// --------------------------------------------------------------------
		// Reset
		// --------------------------------------------------------------------
		//
		$display(" ");
		$display("----------------------------------------------------------");
		$display("Reset");
		$display("----------------------------------------------------------");
		$display("Time: %0t",$time);
		$display(" ");

		// Wait for reset on the master to deassert
		$display("\nWait for reset to deassert");
		@(posedge m_master_vif.ACLK);
		while (m_master_vif.ARESET_N !== 1'b1) begin
			@(posedge m_master_vif.ACLK);
		end
		$display(" * Reset deasserted");

		// Wait
		repeat (500) begin
			@(posedge m_master_vif.ACLK);
		end

		// --------------------------------------------------------------------
		// FIFO Transmit/Receive tests
		// --------------------------------------------------------------------
		//
		$display(" ");
		$display("----------------------------------------------------------");
		$display("FIFO Transmit/Receive Tests");
		$display("----------------------------------------------------------");
		$display("Time: %0t",$time);
		$display(" ");
		$display("TXD FIFO depth = %0d", m_txd_fifo_depth);
		$display("RXD FIFO depth = %0d", m_rxd_fifo_depth);

		// Check the FIFO depths are the same
		if (m_txd_fifo_depth != m_rxd_fifo_depth) begin
			$fatal(1, "FIFO TXD and RXD depths should match!");
		end

		// Check the FIFO depth is 2k or larger
		if (m_txd_fifo_depth < 2048) begin
			$fatal(1, "FIFO TXD and RXD depths should be at least 2048!");
		end

		// Loop over several power-of-2 depths
		for (int unsigned i = 0; i < 5; i++) begin
			axi_len = m_rxd_fifo_depth >> i;
			write_read_check(axi_len);
		end

		// Loop over several power-of-10 depths
		write_read_check(2000);
		write_read_check(1000);
		write_read_check(500);
		write_read_check(300);
		write_read_check(100);

		// Wait
		#1us;

		$display("\narty_test::run() ended");

	endtask

endclass

