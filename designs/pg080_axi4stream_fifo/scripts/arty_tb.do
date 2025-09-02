onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Arty top-level}
add wave -noupdate /arty_tb/ext_reset_n
add wave -noupdate /arty_tb/clk_100mhz
add wave -noupdate /arty_tb/led_g
add wave -noupdate /arty_tb/led_rgb
add wave -noupdate -divider {AXIS TXD}
add wave -noupdate /arty_tb/u1/axis_txd_tready
add wave -noupdate /arty_tb/u1/axis_txd_tvalid
add wave -noupdate /arty_tb/u1/axis_txd_tlast
add wave -noupdate /arty_tb/u1/axis_txd_tdata
add wave -noupdate -divider {AXIS RXD}
add wave -noupdate /arty_tb/u1/axis_rxd_tready
add wave -noupdate /arty_tb/u1/axis_rxd_tvalid
add wave -noupdate /arty_tb/u1/axis_rxd_tlast
add wave -noupdate /arty_tb/u1/axis_rxd_tdata
add wave -noupdate -divider {AXI-MM VIP}
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARADDR
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARBURST
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARCACHE
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARID
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARLEN
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARLOCK
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARPROT
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARQOS
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARREADY
add wave -noupdate /arty_tb/u1/u2/axi_vip_ARVALID
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWADDR
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWBURST
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWCACHE
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWID
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWLEN
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWLOCK
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWPROT
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWQOS
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWREADY
add wave -noupdate /arty_tb/u1/u2/axi_vip_AWVALID
add wave -noupdate /arty_tb/u1/u2/axi_vip_BID
add wave -noupdate /arty_tb/u1/u2/axi_vip_BREADY
add wave -noupdate /arty_tb/u1/u2/axi_vip_BRESP
add wave -noupdate /arty_tb/u1/u2/axi_vip_BVALID
add wave -noupdate /arty_tb/u1/u2/axi_vip_RDATA
add wave -noupdate /arty_tb/u1/u2/axi_vip_RID
add wave -noupdate /arty_tb/u1/u2/axi_vip_RLAST
add wave -noupdate /arty_tb/u1/u2/axi_vip_RREADY
add wave -noupdate /arty_tb/u1/u2/axi_vip_RRESP
add wave -noupdate /arty_tb/u1/u2/axi_vip_RVALID
add wave -noupdate /arty_tb/u1/u2/axi_vip_WDATA
add wave -noupdate /arty_tb/u1/u2/axi_vip_WLAST
add wave -noupdate /arty_tb/u1/u2/axi_vip_WREADY
add wave -noupdate /arty_tb/u1/u2/axi_vip_WSTRB
add wave -noupdate /arty_tb/u1/u2/axi_vip_WVALID
add wave -noupdate -divider {AXI-MM FIFO Lite}
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_ARADDR
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_ARREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_ARVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_AWADDR
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_AWREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_AWVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_BREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_BRESP
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_BVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_RDATA
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_RREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_RRESP
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_RVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_WDATA
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_WREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_WSTRB
add wave -noupdate /arty_tb/u1/u2/axi_fifo_lite_WVALID
add wave -noupdate -divider {AXI-MM FIFO Full}
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARADDR
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARBURST
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARCACHE
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARLEN
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARLOCK
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARPROT
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARSIZE
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_ARVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWADDR
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWBURST
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWCACHE
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWLEN
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWLOCK
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWPROT
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWSIZE
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_AWVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_BREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_BRESP
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_BVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_RDATA
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_RLAST
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_RREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_RRESP
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_RVALID
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_WDATA
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_WLAST
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_WREADY
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_WSTRB
add wave -noupdate /arty_tb/u1/u2/axi_fifo_full_WVALID
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {14547750 ps}
