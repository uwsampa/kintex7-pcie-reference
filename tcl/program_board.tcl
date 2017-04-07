open_project k7-board/k7-board.xpr

open_hw
connect_hw_server

open_hw_target
set_property PROGRAM.FILE {k7-board/k7-board.runs/impl_1/k7_board_wrapper.bit} [lindex [get_hw_devices xc7k325t_0] 0]

current_hw_device [lindex [get_hw_devices xc7k325t_0] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7k325t_0] 0]

set_property PROBES.FILE {} [lindex [get_hw_devices xc7k325t_0] 0]
set_property PROGRAM.FILE {k7-board/k7-board.runs/impl_1/k7_board_wrapper.bit} [lindex [get_hw_devices xc7k325t_0] 0]
program_hw_devices [lindex [get_hw_devices xc7k325t_0] 0]
refresh_hw_device [lindex [get_hw_devices xc7k325t_0] 0]

close_hw_target
disconnect_hw_server
close_hw
close_project