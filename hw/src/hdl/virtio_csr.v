`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module virtio_csr (
  clk,
  rst,
  en,
  we,
  addr,
  din,
  dout
);

  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *)
  input wire clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *)
  input wire rst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *)
  input wire en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *)
  input wire [3 : 0] we;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *)
  input wire [31 : 0] addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *)
  input wire [31 : 0] din;
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 4096, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *)
  output wire [31 : 0] dout;


  //  Xilinx Single Port Byte-Write Read First RAM
  //  This code implements a parameterizable single-port byte-write read-first memory where when data
  //  is written to the memory, the output reflects the prior contents of the memory location.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.
  //  Modify the parameters for the desired RAM characteristics.

  parameter NB_COL = 4;                           // Specify number of columns (number of bytes)
  parameter COL_WIDTH = 8;                        // Specify column width (byte width, typically 8 or 9)
  parameter RAM_DEPTH = 32;                       // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "LOW_LATENCY";      // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  wire [clogb2(RAM_DEPTH-1)-1:0] addra;  // Address bus, width determined from RAM_DEPTH
  wire [(NB_COL*COL_WIDTH)-1:0] dina;    // RAM input data
  wire clka;                           // Clock
  wire [NB_COL-1:0] wea;               // Byte-write enable
  wire ena;                            // RAM Enable, for additional power savings, disable port when not in use
  wire rsta;                           // Output reset (does not affect memory contents)
  wire regcea;                         // Output register enable
  wire [(NB_COL*COL_WIDTH)-1:0] douta;          // RAM output data

  reg [(NB_COL*COL_WIDTH)-1:0] csr_reg_file [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] csr_reg = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, csr_reg_file, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          csr_reg_file[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  always @(posedge clka)
    if (ena) begin
      csr_reg <= csr_reg_file[addra];
    end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge clka)
         if (ena)
           if (wea[i])
             csr_reg_file[addra][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= dina[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign douta = csr_reg;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] douta_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge clka)
        if (rsta)
          douta_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (regcea)
          douta_reg <= csr_reg;

      assign douta = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction



  // implement interactive logic with Host Driver

  reg [7:0] csr_reg_12B1;           // 0x12, 1Byte, Device Status
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      csr_reg_12B1 <= 8'h00;
    end else begin
      csr_reg_12B1 <= (addr == 'h10 && en && we == 'b0100)? din[23:16]: csr_reg_12B1;
    end 
  end
  wire csr_drv_ok      = csr_reg_12B1[2];
  wire csr_rst         = (addr == 'h10 && en && we == 'b0100 && din[23:16] == 8'h00)? 1'b1: 1'b0;

  reg [15:0] csr_reg_0eB2;          // 0x0e, 2Byte, Queue Select 
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      csr_reg_0eB2    <= 16'h0000;
    end else begin
      csr_reg_0eB2               <= (addr == 'h0c && en && we == 'b1100)? din[31:16]: csr_reg_0eB2;
    end 
  end

  reg [31:0] csr_reg_08B4 [3-1:0];  // 0x08, 4Byte, Queue Address
  always @(posedge clk) begin
    if (csr_rst) begin              // soft reset
      csr_reg_08B4[0] <= 32'h00000000;
      csr_reg_08B4[1] <= 32'h00000000;
      csr_reg_08B4[2] <= 32'h00000000;
    end else begin
      csr_reg_08B4[csr_reg_0eB2] <= (addr == 'h08 && en && we == 'b1111)? din[31: 0]: csr_reg_08B4[csr_reg_0eB2];
    end 
  end
  wire csr_access_08B4 = (addr == 'h08)? 1'b1: 1'b0;
  
  reg [15:0] csr_reg_10B2;          // 0x10, 2Byte, Queue Notify
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      csr_reg_10B2 <= 8'h00;
    end else begin
      csr_reg_10B2 <= (addr == 'h10 && en && we == 'b0011)? din[15:0]: csr_reg_10B2;
    end 
  end
  wire csr_access_10B2 = (addr == 'h10 && en && we == 'b0011)? 1'b1: 1'b0;

  reg [15:0] csr_reg_14B2;           // 0x14, 2Byte, Config MSIX Vector
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      csr_reg_14B2 <= 16'h0000;
    end else begin
      csr_reg_14B2 <= (addr == 'h14 && en && we == 'b0011)? din[15:0]: csr_reg_14B2;
    end 
  end

  reg [15:0] csr_reg_16B2 [3-1:0];   // 0x16, 2Byte, Queue MSIX Vector
  always @(posedge clk) begin
    if (csr_rst) begin               // soft reset
      csr_reg_16B2[0] <= 16'h0000;
      csr_reg_16B2[1] <= 16'h0000;
      csr_reg_16B2[2] <= 16'h0000;
    end else begin
      csr_reg_16B2[csr_reg_0eB2] <= (addr == 'h14 && en && we == 'b1100)? din[31:16]: csr_reg_16B2[csr_reg_0eB2];
    end 
  end
  wire csr_access_14B4 = (addr == 'h14)? 1'b1: 1'b0;


  // map the interface signals
  assign rsta = rst;
  assign clka = clk;
  assign ena = en;
  assign wea = we;
  assign addra = addr;
  assign dina = din;
  assign dout = (csr_access_08B4)?  csr_reg_08B4[csr_reg_0eB2]:
	       ((csr_access_14B4)? {csr_reg_16B2[csr_reg_0eB2], csr_reg_14B2}:
	        douta);  

endmodule

