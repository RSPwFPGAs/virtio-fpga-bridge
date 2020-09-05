# virtio-fpga-bridge
A platform for emulating Virtio frontend and backend bridging with FPGAs.

# Introduction
With the [Qemu-HDL Cosim](http://compas.cs.stonybrook.edu/projects/fpgacloud/vm-hdl-cosim/) framework, it is now possible to run the full system emulation of [BM-Hive](https://dl.acm.org/doi/10.1145/3373376.3378507) (Alibaba Cloud's X-Dragon, Shenlong in Chinese) on a single x86 PC.

## BM-Hive
![BM-Hive architecture](./doc/bm-hive.png)

## virtio-fpga-bridge
The Virtio frontend runs on the 1st x86(Qemu), and the Virtio backend runs on the 2nd x86(Qemu). FPGA(HDL Sim) plays the role of bridging/synchronizing the frontend and backend, with shadow vrings and DMAs. 

![virtio-fpga-bridge architecture](./doc/qemu-hdl-cosim.png)

There are two PCIe-EP IPs instantiated in the FPGA logic. The EP facing the 1st x86 is an implementation of the standard Virtio protocol. And there is no driver modification needed in the 1st x86 OS. The EP interfacing with the 2nd x86 is an implementation of a custom protocol, handling CSR/Mailbox registers and DMAs. And user space drivers, such as [ixy](https://github.com/emmericp/ixy), DPDK and SPDK, are needed for this interface.

# Discussion
## System topology
With Virtio's Virtqueue handling implemented in FPGA, there are many possible combinations of how the system can be constructed.

![Topology comparison](./doc/fpga-bridging.png)

## HW limitations
BM-Hive requires special HW PCB board design, on which the x86 system is not available for many PCIe FPGA development boards. Adding a soft-core CPU inside the FPGA is an interesting option.

![SoC FPGA alternative](./doc/soc-option.png)

# Related Projects
[qemu-hdl-cosim](https://github.com/RSPwFPGAs/qemu-hdl-cosim)

[virtio-fpga](https://github.com/RSPwFPGAs/virtio-fpga)

[ixy Virtio driver with PCIe MMIO](https://github.com/RSPwFPGAs/ixy)

# Useful Links
[阿里云弹性裸金属服务器-神龙架构（X-Dragon）揭秘](https://developer.aliyun.com/article/594276)

[KVM Forum 2019: VirtIO without the Virt](https://kvmforum2019.sched.com/event/TmxF/virtio-without-the-virt-towards-implementations-in-hardware-michael-tsirkin-red-hat)

