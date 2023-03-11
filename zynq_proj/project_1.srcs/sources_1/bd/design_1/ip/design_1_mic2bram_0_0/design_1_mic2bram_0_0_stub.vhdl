-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Fri Mar  3 18:02:40 2023
-- Host        : DESKTOP-849AITH running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/ZhouLin/Desktop/Sound_source_localization/zynq_proj/project_1.srcs/sources_1/bd/design_1/ip/design_1_mic2bram_0_0/design_1_mic2bram_0_0_stub.vhdl
-- Design      : design_1_mic2bram_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_mic2bram_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    mic_sck : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ram_en : out STD_LOGIC;
    ram_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ram_rst : out STD_LOGIC;
    ram_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mic_sd : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mic_ws : out STD_LOGIC;
    mic_ck : out STD_LOGIC;
    start : in STD_LOGIC;
    done : out STD_LOGIC
  );

end design_1_mic2bram_0_0;

architecture stub of design_1_mic2bram_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rst_n,mic_sck,din[31:0],dout[31:0],ram_en,ram_we[3:0],ram_rst,ram_addr[31:0],mic_sd[3:0],mic_ws,mic_ck,start,done";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "mic2bram,Vivado 2019.2";
begin
end;
