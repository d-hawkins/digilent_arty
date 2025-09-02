// ----------------------------------------------------------------------------
// aximm_base_pkg.sv
//
// 9/1/2025 D. W. Hawkins (dwh@caltech.edu)
//
// AXI-MM Verification IP test package.
//
// ----------------------------------------------------------------------------

package aximm_base_pkg;

	// ------------------------------------------------------------------------
	// Packages
	// ------------------------------------------------------------------------
	//
	import axi_vip_pkg::*;

	// ------------------------------------------------------------------------
	// AXI4-MM Control
	// ------------------------------------------------------------------------
	//
	// Base class to define AXI4-MM VIP passthrough read/write operations.
	//
	class aximm_base #(type AXIMM);

		// --------------------------------------------------------------------
		// Member Variables
		// --------------------------------------------------------------------
		//
		// Xilinx AXI4-MM Passthrough Agent
		AXIMM m_axi;

		// --------------------------------------------------------------------
		// Member Functions
		// --------------------------------------------------------------------
		//
		// Constructor
		function new(
			AXIMM axi
		);
			m_axi = axi;

			// The AXI read/write tasks assume 32-bits
			assert(m_axi.C_AXI_WDATA_WIDTH==32);
		endfunction

		// --------------------------------------------------------------------
		// Member Tasks
		// --------------------------------------------------------------------
		//
		// --------------------------------------------------------------------
		// AXI write burst (up to 256-word block)
		// --------------------------------------------------------------------
		//
		task axi_write_burst_block (
			input int unsigned addr,
			input int unsigned data[]
		);
			int unsigned         data_size   = data.size();
			xil_axi_uint              id     = 0;
			xil_axi_len_t             len    = data_size-1;
			xil_axi_size_t            size   = XIL_AXI_SIZE_4BYTE;
			xil_axi_burst_t           burst  = XIL_AXI_BURST_TYPE_INCR;
			xil_axi_lock_t            lock   = XIL_AXI_ALOCK_NOLOCK;
			xil_axi_cache_t           cache  = XIL_AXI_CACHE_NORM_NONCACHEABLE_BUFFERABLE;
			xil_axi_prot_t            prot   = XIL_AXI_PROT_NORMAL_ACCESS_MASK;
			xil_axi_region_t          region = 0;
			xil_axi_qos_t             qos    = 0;
			xil_axi_user_beat         auser  = 0;
			bit [8*4096-1:0]          wdata  = '0;
			xil_axi_data_beat [255:0] user   = '0;
			xil_axi_resp_t            wresp  = XIL_AXI_RESP_OKAY;

			// Pack the write data
			for (int unsigned i = 0; i < data_size; i++) begin
				wdata[i*32 +: 32] = data[i];
			end

			// AXI write burst
			m_axi.AXI4_WRITE_BURST(
				id, addr, len, size, burst, lock, cache, prot, region,
				qos, auser, wdata, user, wresp
			);
		endtask

		// --------------------------------------------------------------------
		// AXI read burst (up to 256-word block)
		// --------------------------------------------------------------------
		//
		task axi_read_burst_block (
			input  int unsigned addr,
			input  int unsigned data_size,
			output int unsigned data[]
		);
			xil_axi_uint              id     = 0;
			xil_axi_len_t             len    = data_size-1;
			xil_axi_size_t            size   = XIL_AXI_SIZE_4BYTE;
			xil_axi_burst_t           burst  = XIL_AXI_BURST_TYPE_INCR;
			xil_axi_lock_t            lock   = XIL_AXI_ALOCK_NOLOCK;
			xil_axi_cache_t           cache  = XIL_AXI_CACHE_NORM_NONCACHEABLE_BUFFERABLE;
			xil_axi_prot_t            prot   = XIL_AXI_PROT_NORMAL_ACCESS_MASK;
			xil_axi_region_t          region = 0;
			xil_axi_qos_t             qos    = 0;
			xil_axi_user_beat         auser  = 0;
			bit [8*4096-1:0]          rdata  = '0;
			xil_axi_data_beat [255:0] user   = '0;
			xil_axi_resp_t    [255:0] rresp  = '{default:XIL_AXI_RESP_OKAY};

			// AXI read burst
			m_axi.AXI4_READ_BURST(
				id, addr, len, size, burst, lock, cache, prot, region,
				qos, auser, rdata, rresp, user
			);

			// Unpack the read data
			data = new[data_size];
			for (int unsigned i = 0; i < data_size; i++) begin
				data[i] = rdata[i*32 +: 32];
			end
		endtask

		// --------------------------------------------------------------------
		// AXI write burst
		// --------------------------------------------------------------------
		//
		// This task performs bursts of 256 words, to 256 x 32-bit word-aligned
		// addresses. This ensures that bursts do not cross 4k boundaries.
		//
		// The FIFO option was added to support the Xilinx AXI4-Stream FIFO
		// (see PG080) which requires AXI4-MM bursts of length 256 using
		// XIL_AXI_BURST_TYPE_INCR, without changing the AXI4 FIFO start
		// address for bursts that require multiple 256 word transactions.
		//
		task axi_write_burst (
			input int unsigned addr,
			input int unsigned data[],
			input bit fifo = 1'b0
		);
			int unsigned bdata[];
			int unsigned max_burst_length;
			int unsigned number_of_bursts;
			int unsigned burst_offset;
			int unsigned burst_length;
			int unsigned start_addr;
			int unsigned offset;

			// AXI-MM LEN[7:0] maximum
			max_burst_length = 256;

			// Burst offset due to unaligned start address
			burst_offset = (addr/4) % max_burst_length;

			// Number of 256-word aligned bursts
			number_of_bursts = (burst_offset + data.size() +
				(max_burst_length-1))/max_burst_length;

			// AXI-MM bursts
			start_addr = addr;
			offset     = 0;
			for (int unsigned j = 0; j < number_of_bursts; j++) begin
				// Nominal burst length
				burst_length = max_burst_length;
				// First/last burst
				if (j == (number_of_bursts-1)) begin
					// Last burst or single burst
					burst_length = data.size() - offset;
				end
				else if (j == 0) begin
					// First burst (of multiple)
					burst_length = max_burst_length - burst_offset;
				end

				// Copy the burst data
				bdata = new[burst_length];
				for (int unsigned i = 0; i < burst_length; i++) begin
					bdata[i] = data[offset+i];
				end

				// AXI-MM transaction
				axi_write_burst_block(start_addr, bdata);

				// Update loop parameters
				offset += burst_length;
				if (~fifo) begin
					start_addr += 4*burst_length;
				end
			end
		endtask

		// --------------------------------------------------------------------
		// AXI read burst
		// --------------------------------------------------------------------
		//
		// This task performs bursts of 256 words, to 256 x 32-bit word-aligned
		// addresses. This ensures that bursts do not cross 4k boundaries.
		//
		// The FIFO option was added to support the Xilinx AXI4-Stream FIFO
		// (see PG080) which requires AXI4-MM bursts of length 256 using
		// XIL_AXI_BURST_TYPE_INCR, without changing the AXI4 FIFO start
		// address for bursts that require multiple 256 word transactions.
		//
		task axi_read_burst (
			input  int unsigned addr,
			input  int unsigned data_size,
			output int unsigned data[],
			input  bit fifo = 1'b0
		);
			int unsigned bdata[];
			int unsigned max_burst_length;
			int unsigned number_of_bursts;
			int unsigned burst_offset;
			int unsigned burst_length;
			int unsigned start_addr;
			int unsigned offset;

			// AXI-MM LEN[7:0] maximum
			max_burst_length = 256;

			// Burst offset due to unaligned start address
			burst_offset = (addr/4) % max_burst_length;

			// Number of 256-word aligned bursts
			number_of_bursts = (burst_offset + data_size +
				(max_burst_length-1))/max_burst_length;

			// Read data
			data = new[data_size];

			// AXI-MM bursts
			start_addr = addr;
			offset     = 0;
			for (int unsigned j = 0; j < number_of_bursts; j++) begin
				// Nominal burst length
				burst_length = max_burst_length;
				// First/last burst
				if (j == (number_of_bursts-1)) begin
					// Last burst, or single burst
					burst_length = data_size - offset;
				end
				else if (j == 0) begin
					// First burst (of multiple)
					burst_length = max_burst_length - burst_offset;
				end

				// AXI-MM transaction
				axi_read_burst_block(start_addr, burst_length, bdata);

				// Copy the burst data
				for (int unsigned i = 0; i < burst_length; i++) begin
					data[offset+i] = bdata[i];
				end

				// Update loop parameters
				offset += burst_length;
				if (~fifo) begin
					start_addr += 4*burst_length;
				end
			end
		endtask

		// --------------------------------------------------------------------
		// AXI write single
		// --------------------------------------------------------------------
		//
		task axi_write_single (
			input int unsigned addr,
			input int unsigned data
		);
			int unsigned wdata[];
			wdata = new[1];
			wdata[0] = data;
			axi_write_burst_block(addr, wdata);
		endtask

		// --------------------------------------------------------------------
		// AXI read single
		// --------------------------------------------------------------------
		//
		task axi_read_single (
			input  int unsigned addr,
			output int unsigned data
		);
			int unsigned rdata[];
			axi_read_burst_block(addr, 1, rdata);
			data = rdata[0];
		endtask
	endclass
endpackage

