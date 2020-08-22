create_project proj_opae_fim ./proj_opae_fim -part xcku040-ffva1156-2-e -f
set_property board_part xilinx.com:kcu105:part0:1.5 [current_project]

set_property ip_repo_paths {../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge} [current_project]
update_ip_catalog

source [lindex $argv 1]
set_property ip_repo_paths [lappend AFU_IP_PATH [get_property ip_repo_paths [current_fileset]]] [current_project]
update_ip_catalog


add_files -norecurse ../../src/hdl/virtio_csr.v

