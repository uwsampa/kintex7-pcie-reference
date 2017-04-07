create_project k7-board k7-board -part xc7k325tffg900-2
set_property board_part xilinx.com:kc705:part0:1.4 [current_project]

set_property  ip_repo_paths  hardware [current_project]
update_ip_catalog

create_bd_design "k7_board"
create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:3.0 xdma_0
apply_bd_automation -rule xilinx.com:bd_rule:xdma -config {lane_width "X8" link_speed "5.0 GT/s (PCIe Gen 2)" axi_clk "Maximum Data Width" axi_intf "AXI Stream" bar_size "Disable" h2c "1" c2h "1" }  [get_bd_cells xdma_0]

create_bd_cell -type ip -vlnv cs.uw.edu:sampa:jump_top:1.0 jump_top_0
connect_bd_intf_net [get_bd_intf_pins jump_top_0/S_AXIS] [get_bd_intf_pins xdma_0/M_AXIS_H2C_0]
connect_bd_intf_net [get_bd_intf_pins jump_top_0/M_AXIS] [get_bd_intf_pins xdma_0/S_AXIS_C2H_0]
connect_bd_net [get_bd_pins jump_top_0/CLK] [get_bd_pins xdma_0/axi_aclk]
connect_bd_net [get_bd_pins jump_top_0/RESET_N] [get_bd_pins xdma_0/axi_aresetn]

make_wrapper -files [get_files k7-board/k7-board.srcs/sources_1/bd/k7_board/k7_board.bd] -top
add_files -norecurse k7-board/k7-board.srcs/sources_1/bd/k7_board/hdl/k7_board_wrapper.v
set_property top k7_board_wrapper [current_fileset]

reset_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
