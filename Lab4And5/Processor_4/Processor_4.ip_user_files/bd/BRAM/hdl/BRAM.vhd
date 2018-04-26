--Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
--Date        : Thu Apr 26 19:08:34 2018
--Host        : atishya-HP-Pavilion-Notebook running 64-bit Ubuntu 16.04.4 LTS
--Command     : generate_target BRAM.bd
--Design      : BRAM
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity BRAM is
  port (
    BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_clk : in STD_LOGIC;
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTA_en : in STD_LOGIC;
    BRAM_PORTA_rst : in STD_LOGIC;
    BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of BRAM : entity is "BRAM,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=BRAM,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of BRAM : entity is "BRAM.hwdef";
end BRAM;

architecture STRUCTURE of BRAM is
  component BRAM_blk_mem_gen_0_0 is
  port (
    clka : in STD_LOGIC;
    rsta : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 3 downto 0 );
    addra : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component BRAM_blk_mem_gen_0_0;
  signal BRAM_PORTA_1_ADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal BRAM_PORTA_1_CLK : STD_LOGIC;
  signal BRAM_PORTA_1_DIN : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal BRAM_PORTA_1_DOUT : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal BRAM_PORTA_1_EN : STD_LOGIC;
  signal BRAM_PORTA_1_RST : STD_LOGIC;
  signal BRAM_PORTA_1_WE : STD_LOGIC_VECTOR ( 3 downto 0 );
begin
  BRAM_PORTA_1_ADDR(31 downto 0) <= BRAM_PORTA_addr(31 downto 0);
  BRAM_PORTA_1_CLK <= BRAM_PORTA_clk;
  BRAM_PORTA_1_DIN(31 downto 0) <= BRAM_PORTA_din(31 downto 0);
  BRAM_PORTA_1_EN <= BRAM_PORTA_en;
  BRAM_PORTA_1_RST <= BRAM_PORTA_rst;
  BRAM_PORTA_1_WE(3 downto 0) <= BRAM_PORTA_we(3 downto 0);
  BRAM_PORTA_dout(31 downto 0) <= BRAM_PORTA_1_DOUT(31 downto 0);
blk_mem_gen_0: component BRAM_blk_mem_gen_0_0
     port map (
      addra(31 downto 0) => BRAM_PORTA_1_ADDR(31 downto 0),
      clka => BRAM_PORTA_1_CLK,
      dina(31 downto 0) => BRAM_PORTA_1_DIN(31 downto 0),
      douta(31 downto 0) => BRAM_PORTA_1_DOUT(31 downto 0),
      ena => BRAM_PORTA_1_EN,
      rsta => BRAM_PORTA_1_RST,
      wea(3 downto 0) => BRAM_PORTA_1_WE(3 downto 0)
    );
end STRUCTURE;
