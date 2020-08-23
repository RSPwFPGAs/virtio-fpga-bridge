`timescale 1ns / 100ps

`include "axi_vip_0_passthrough_mst_stimulus.sv"
`include "axi_vip_1_passthrough_mst_stimulus.sv"
`include "axi_vip_0_passthrough_mst_stimulus.2nd.sv"
`include "axi_vip_1_passthrough_mst_stimulus.2nd.sv"

module test_top ();

reg  PERSTN;
reg  PCIE_CLK_N;
reg  PCIE_CLK_P;
reg  FPGA_SYSCLK_N;
reg  FPGA_SYSCLK_P;
reg  RESET;

// 1st PCIe EP 
wire [7:0] PCIE_RX_N;
wire [7:0] PCIE_RX_P;
wire [7:0] PCIE_TX_N;
wire [7:0] PCIE_TX_P;
shell_region_wrapper DUT (
  .pci_express_rxn (PCIE_RX_N),
  .pci_express_rxp (PCIE_RX_P),
  .pci_express_txn (PCIE_TX_N),
  .pci_express_txp (PCIE_TX_P),
  .pcie_perstn (PERSTN),
  .pcie_refclk_clk_n (PCIE_CLK_N),
  .pcie_refclk_clk_p (PCIE_CLK_P)
);
defparam test_top.DUT.shell_region_i.FIM.FIU.pcie_axi_bridge.QEMUPCIeBridge_0.inst.INST_2ND = 0;

// 2nd PCIe EP
wire [7:0] PCIE_RX_N_2ND;
wire [7:0] PCIE_RX_P_2ND;
wire [7:0] PCIE_TX_N_2ND;
wire [7:0] PCIE_TX_P_2ND;
shell_region_wrapper DUT_2ND (
  .pci_express_rxn (PCIE_RX_N_2ND),
  .pci_express_rxp (PCIE_RX_P_2ND),
  .pci_express_txn (PCIE_TX_N_2ND),
  .pci_express_txp (PCIE_TX_P_2ND),
  .pcie_perstn (PERSTN),
  .pcie_refclk_clk_n (PCIE_CLK_N),
  .pcie_refclk_clk_p (PCIE_CLK_P)
);
defparam test_top.DUT_2ND.shell_region_i.FIM.FIU.pcie_axi_bridge.QEMUPCIeBridge_0.inst.INST_2ND = 1;

// instantiate vip master
  axi_vip_0_passthrough_mst_stimulus mst_axilite_toCSR();  // for initialization of CSR
  axi_vip_1_passthrough_mst_stimulus mst_axifull_toDMA();  // for transaction of DMA
  axi_vip_0_passthrough_mst_stimulus_2nd mst_axilite_toCSR_2nd();  // for initialization of CSR
  axi_vip_1_passthrough_mst_stimulus_2nd mst_axifull_toDMA_2nd();  // for transaction of DMA
    
always
begin
  PCIE_CLK_N = 1;
  #5.0;
  PCIE_CLK_N = 0;
  #5.0;
end
always
begin
  PCIE_CLK_P = 0;
  #5.0;
  PCIE_CLK_P = 1;
  #5.0;
end

always
begin
  FPGA_SYSCLK_N = 0;
  #2.5;
  FPGA_SYSCLK_N = 1;
  #2.5;
end
always
begin
  FPGA_SYSCLK_P = 1;
  #2.5;
  FPGA_SYSCLK_P = 0;
  #2.5;
end

initial
begin
  $display("[%t] V_TB: System Reset(test_top/RESET) Is Asserted...", $realtime);
  RESET = 1;
  #5000;
  $display("[%t] V_TB: System Reset(test_top/RESET) Is DeAsserted...", $realtime);
  RESET = 0;
end

initial
begin
  $display("[%t] V_TB: System Reset(test_top/PERSTN) Is Asserted...", $realtime);
  PERSTN = 0;
  #100;
  $display("[%t] V_TB: System Reset(test_top/PERSTN) Is DeAsserted...", $realtime);
  PERSTN = 1;
end

initial begin
  $display("[%t] V_TB: Testbench Init.", $realtime);
end

endmodule

