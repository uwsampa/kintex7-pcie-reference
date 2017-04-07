create_project ipx ipx -part xc7k325tffg900-2
set_property board_part xilinx.com:kc705:part0:1.4  [current_project]

add_files -scan_for_includes hdl
import_files [glob ip/*.xci]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

ipx::package_project \
  -root_dir . \
  -vendor cs.uw.edu \
  -library sampa \
  -taxonomy /UserIP

set_property name jump_top [ipx::current_core]
set_property display_name jump_top_v1_0 [ipx::current_core]
set_property description jump_top_v1_0 [ipx::current_core]

ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::check_integrity -quiet [ipx::current_core]
