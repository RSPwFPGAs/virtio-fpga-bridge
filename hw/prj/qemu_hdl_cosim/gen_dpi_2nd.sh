rm ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
cp ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.c ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c

sed -i 's/qemu_req/qemu_req_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/qemu_resp/qemu_resp_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/hdl_req/hdl_req_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/hdl_resp/hdl_resp_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/ls_sock/ls_sock_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/ls_sock2/ls_sock2_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/poller /poller_2nd /g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/poller,/poller_2nd,/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/poller)/poller_2nd)/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/adv_step/adv_step_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/log2c/log2c_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/COSIM_PORT/COSIM_PORT_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_teardown_pcie_connection/C_teardown_pcie_connection_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_setup_pcie_connection/C_setup_pcie_connection_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_poll/C_poll_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_qemu_step/C_qemu_step_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_req_read/C_req_read_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_resp_read/C_resp_read_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_resp_write/C_resp_write_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_req_write/C_req_write_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
sed -i 's/C_req_interrupt/C_req_interrupt_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
#sed -i 's//_2nd/g' ../../src/qemu_hdl_cosim/sim_ip/QEMUPCIeBridge/hdl/dpi-pcie.2nd.c
