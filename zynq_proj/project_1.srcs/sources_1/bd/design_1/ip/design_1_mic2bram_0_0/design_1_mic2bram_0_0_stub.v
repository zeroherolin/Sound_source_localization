// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Fri Mar  3 18:02:40 2023
// Host        : DESKTOP-849AITH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/ZhouLin/Desktop/Sound_source_localization/zynq_proj/project_1.srcs/sources_1/bd/design_1/ip/design_1_mic2bram_0_0/design_1_mic2bram_0_0_stub.v
// Design      : design_1_mic2bram_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "mic2bram,Vivado 2019.2" *)
module design_1_mic2bram_0_0(clk, rst_n, mic_sck, din, dout, ram_en, ram_we, 
  ram_rst, ram_addr, mic_sd, mic_ws, mic_ck, start, done)
/* synthesis syn_black_box black_box_pad_pin="clk,rst_n,mic_sck,din[31:0],dout[31:0],ram_en,ram_we[3:0],ram_rst,ram_addr[31:0],mic_sd[3:0],mic_ws,mic_ck,start,done" */;
  input clk;
  input rst_n;
  input mic_sck;
  input [31:0]din;
  output [31:0]dout;
  output ram_en;
  output [3:0]ram_we;
  output ram_rst;
  output [31:0]ram_addr;
  input [3:0]mic_sd;
  output mic_ws;
  output mic_ck;
  input start;
  output done;
endmodule
