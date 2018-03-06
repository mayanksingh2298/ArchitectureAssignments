library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--The IEEE.std_logic_unsigned contains definitions that allow 
--std_logic_vector types to be used with the + operator to instantiate a 
--counter.
use IEEE.std_logic_unsigned.all;

entity tb is
    Port ( SW 			: in  STD_LOGIC_VECTOR (15 downto 0);
           BTN 			: in  STD_LOGIC_VECTOR (4 downto 0);
           CLK 			: in  STD_LOGIC;
           LED 			: out  STD_LOGIC_VECTOR (15 downto 0);
           SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN 		: out  STD_LOGIC_VECTOR (3 downto 0);
           UART_TXD 	: out  STD_LOGIC;
           UART_RXD     : in   STD_LOGIC;
           VGA_RED      : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_BLUE     : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_GREEN    : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_VS       : out  STD_LOGIC;
           VGA_HS       : out  STD_LOGIC;
           PS2_CLK      : inout STD_LOGIC;
           PS2_DATA     : inout STD_LOGIC
		);
end tb;

architecture Behavioral of tb is

component memory_uart
--  Port ( );
PORT(
    CLK : in std_logic;
    RST : in std_logic;
    UART_TX: out std_logic;
    UART_RX: in std_logic;
    LAST_DATA_RX : out std_logic_vector(7 downto 0);
    ENABLE_TX: in std_logic;
    ENABLE_RX: in std_logic;
    UART_RX_CNT : out std_logic_vector(15 downto 0);
    CLK_MEM : IN STD_LOGIC;
    ENA_MEM : IN STD_LOGIC;
    WEA_MEM : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ADDR_MEM : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    DIN_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOUT_MEM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component;

--component Datapath
--PORT ( 
--	clock, reset : in std_logic;
--	ins          : out word;
--	F            : out nibble;
--	PW           : in  std_logic;
--	IorD         : in  std_logic;
--	MR           : in  std_logic;
--	MW           : in  std_logic;
--	IW           : in  std_logic;
--	DW           : in  std_logic;
--	Rsrc         : in  std_logic;
--	M2R          : in  std_logic;
--	RW           : in  std_logic;
--	AW           : in  std_logic;
--	BW           : in  std_logic;
--	Asrc1        : in  std_logic;
--	Asrc2        : in  bit_pair;
--	Fset         : in  std_logic;
--	Op           : in  nibble;
--	ReW          : in  std_logic
--);
--end component;


signal temp: std_logic;
signal btn_3_d: std_logic;
signal UART_RX_CNT : std_logic_vector(15 downto 0);
signal clk_mem : std_logic;
signal ena_mem : std_logic;
signal wea_mem : std_logic_vector(3 downto 0);
signal addr_mem : std_logic_vector(11 downto 0);
signal din_mem : std_logic_vector(31 downto 0);
signal dout_mem : std_logic_vector(31 downto 0);
signal IR : std_logic_vector(31 downto 0);
signal rx_uart : std_logic_vector(7 downto 0);
signal switch_pair : std_logic_vector(1 downto 0);
signal reset_mem : std_logic;
--signal Flags_out : nibble;
begin


----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--instantiate the processor datapath (written by you) here and then connect the dout_mem signal(32 bits) to your datapath inputs.
--Reset as shown below is to be connected to BTN(4)
--Press BTN(3) for every next input set of signals from memory.
-- Sample connections are shown below
-- LEDs are currently connected to monitor the file transfer from uart to memory
 
--DP_inst : Datapath port map(
--	clock => CLK,
--	reset => BTN(4),             
--	ins   => IR,                 
--	F     => Flags_out,          
--	PW    => dout_mem(0),        
--	IorD  => dout_mem(1),        
--	MR    => dout_mem(2),        
--	MW    => dout_mem(3),        
--	IW    => dout_mem(4),        
--	DW    => dout_mem(5),        
--	Rsrc  => dout_mem(6),        
--	M2R   => dout_mem(7),        
--	RW    => dout_mem(8),        
--	AW    => dout_mem(9),        
--	BW    => dout_mem(10),       
--	Asrc1 => dout_mem(11),       
--	Asrc2 => dout_mem(13 downto 12),
--	Fset  => dout_mem(14),        
--	Op    => dout_mem(18 downto 15),
--	ReW   => dout_mem(19)        
--);




--------------------------------------------------------------------------------------------------------
--CAUTION: DO NOT TOUCH THE CODE PORTION BELOW. The appropriate signals have been already brought out and use them.
--------------------------------------------------------------------------------------------------------


clk_mem <= CLK;
ena_mem <= '1';

btn_input: process(CLK, BTN(4)) begin
if (BTN(4) = '1') then
    btn_3_d  <= '0';
elsif (CLK'event and CLK = '1') then
    btn_3_d    <= BTN(3);
end if;    
end process;

--mem_read: process(CLK, BTN(4)) begin
--if (BTN(4) = '1') then
--    addr_mem <= (others => '0');
--    wea_mem <= (others=>'0');
--    din_mem <= (others=>'0');
--elsif (CLK'event and CLK = '1') then
--    if (BTN(3) = '1' and btn_3_d = '0') then
--        addr_mem <= addr_mem + 1;
--    end if;
--end if;    
--end process;

mem_reset: process(CLK, BTN(4)) begin
if (BTN(4) = '1') then
    reset_mem <= '1';
    addr_mem <= "111111111111";
    wea_mem <= (others=>'0');
    din_mem <= (others=>'0');
elsif (CLK'event and CLK = '1') then
    if(reset_mem = '1') then
      addr_mem <= addr_mem + '1';
      wea_mem <= "1111";
      if(addr_mem = "111111111110") then
        reset_mem <= '0';
        wea_mem <= (others=>'0');
        addr_mem <= (others=>'0');
      end if;
    elsif (BTN(3) = '1' and btn_3_d = '0') then
        addr_mem <= addr_mem + 1;
    end if;
end if;    
end process;

mem_if: memory_uart port map(
    CLK => CLK,
    RST => BTN(4),
    UART_TX => UART_TXD,
    UART_RX => UART_RXD,
    LAST_DATA_RX => rx_uart, 
    ENABLE_TX => '0', 
    ENABLE_RX => SW(0),
    UART_RX_CNT => UART_RX_CNT,
    CLK_MEM => clk_mem,
    ENA_MEM => ena_mem,
    WEA_MEM => wea_mem,
    ADDR_MEM => addr_mem,
    DIN_MEM => din_mem,
    DOUT_MEM => dout_mem
);

switch_pair <= SW(1) & SW(2);
with switch_pair select
		LED(7 downto 0) <= dout_mem(7 downto 0) when ("10"),
		                   dout_mem(23 downto 16) when ("11"),
		                   rx_uart when others;
with switch_pair select
        LED(15 downto 8) <= dout_mem(15 downto 8) when ("10"),
                            dout_mem(31 downto 24) when ("11"),
                            "00000000" when others;
			


--below is self loopback for debug
--mem_if: memory port map(
--    CLK => CLK,
--    RST => BTN(4),
--    UART_TX => temp,
--    UART_RX => temp
--);
--UART_TXD <= temp;

end Behavioral;
