// ----------------------------------------------------------------------------
// aximm_memory_pkg.sv
//
// 9/1/2025 D. W. Hawkins (dwh@caltech.edu)
//
// AXI-MM memory test package.
//
// ----------------------------------------------------------------------------

package aximm_memory_pkg;

	// ------------------------------------------------------------------------
	// Packages
	// ------------------------------------------------------------------------
	//
	import aximm_base_pkg::*;

	// ------------------------------------------------------------------------
	// AXI4-MM GPIO Control/Status
	// ------------------------------------------------------------------------
	//
	class aximm_memory #(type AXIMM) extends aximm_base #(AXIMM);

		// --------------------------------------------------------------------
		// Member Variables
		// --------------------------------------------------------------------
		//
		// Memory base address
		int m_addr;

		// --------------------------------------------------------------------
		// Member Functions
		// --------------------------------------------------------------------
		//
		// Constructor
		function new(
			AXIMM axi,
			int   base_addr
		);
			// Baseclass constructor
			super.new(axi);

			// Extended class
			m_addr = base_addr;
		endfunction

		// --------------------------------------------------------------------
		// Member Tasks
		// --------------------------------------------------------------------
		//
		// --------------------------------------------------------------------
		// Write burst
		// --------------------------------------------------------------------
		//
		task write_burst (
			input int unsigned offset,
			input int unsigned data[],
			input bit fifo = 1'b0
		);
			axi_write_burst(m_addr+offset,data,fifo);
		endtask

		// --------------------------------------------------------------------
		// Read burst
		// --------------------------------------------------------------------
		//
		task read_burst (
			input  int unsigned offset,
			input  int unsigned data_size,
			output int unsigned data[],
			input bit fifo = 1'b0
		);
			axi_read_burst(m_addr+offset,data_size,data,fifo);
		endtask

		// --------------------------------------------------------------------
		// Write single
		// --------------------------------------------------------------------
		//
		task write_single (
			input int unsigned offset,
			input int unsigned data
		);
			axi_write_single(m_addr+offset,data);
		endtask

		// --------------------------------------------------------------------
		// Read single
		// --------------------------------------------------------------------
		//
		task read_single (
			input  int unsigned offset,
			output int unsigned data
		);
			axi_read_single(m_addr+offset,data);
		endtask

		// --------------------------------------------------------------------
		// Read burst and check
		// --------------------------------------------------------------------
		//
		task read_burst_and_check (
			input int unsigned offset,
			input int unsigned data[],
			input bit fifo = 1'b0
		);
			int unsigned length = data.size();
			int unsigned capture[];
			int unsigned fail;

			// Read memory
			read_burst(offset, length, capture, fifo);

			// Check the data
			fail = 0;
			for (int unsigned i = 0; i < length; i++) begin
				if (capture[i] != data[i]) begin
					$display("Error: write/read data mismatch!");
					$display(
						"%0d: (expected, actual) = (%.16h, %.16h)",
						i, data[i], capture[i]
					);
					fail++;
					if (fail > 10) begin
						break;
					end
				end
			end
			if (fail) begin
				$fatal(1,"Error: write/read checks failed!");
			end
			$display(" * write/read checks all passed.");

		endtask

		// --------------------------------------------------------------------
		// Read burst and print
		// --------------------------------------------------------------------
		//
		task read_burst_and_print (
			input int unsigned offset,
			input int unsigned length,
			input bit fifo = 1'b0
		);
			int unsigned capture[];

			// Read memory
			read_burst(offset, length, capture, fifo);

			// Print the data
			for (int unsigned i = 0; i < length; i++) begin
				// Address
				if (i==0) begin
					$write("%.8h:", 4*i);
				end
				else if ((i%8)==0) begin
					$write("\n%.8h:", 4*i);
				end
				// Data
				$write(" %.8h", capture[i]);
			end
			$write("\n");
		endtask

		// --------------------------------------------------------------------
		// Fill with modulo pattern
		// --------------------------------------------------------------------
		//
		task fill_modulo (
			input int unsigned length
		);
			int unsigned pattern[];

			$display(" ");
			$display("Memory: write modulo pattern");

			// Create the pattern
			pattern = new[length];
			for (int unsigned i = 0; i < length; i++) begin
				pattern[i] = ((i%16)+1)*32'h01010101;
			end

			// AXI-MM burst write
			write_burst(0,pattern);
		endtask

		// --------------------------------------------------------------------
		// Check modulo pattern
		// --------------------------------------------------------------------
		//
		task check_modulo (
			input int unsigned length
		);
			int unsigned capture[];
			int unsigned pattern;
			int unsigned fail;

			$display(" ");
			$display("Memory: check modulo pattern");

			// Read the memory
			read_burst(0, length, capture);

			// Check the modulo pattern
			fail = 0;
			for (int unsigned i = 0; i < length; i++) begin
				pattern = ((i%16)+1)*32'h01010101;

				// Compare
				if (capture[i] != pattern) begin
					$display("Error: write/read mismatch!");
					$display(
						"%0d: (expected, actual) = (%.16h, %.16h)",
						i, pattern, capture[i]
					);
					fail++;
					if (fail > 10) begin
						break;
					end
				end
			end
			if (fail) begin
				$fatal(1,"Error: write/read checks failed!");
			end
			$display(" * write/read checks all passed.");
		endtask
	endclass
endpackage

