library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity MasterInterface is
    port(
        hready: in std_logic;
        hclk : in std_logic;
        hrdata : in std_logic_vector(31 downto 0);

        haddr: out std_logic_vector(15 downto 0);
        hwrite: out std_logic;
        hsize: out std_logic_vector(2 downto 0);
        htrans: out std_logic;  -- '0' idle | '1' nonseq
        hwdata: out std_logic_vector(31 downto 0)
    );
end MasterInterface;
architecture master of MasterInterface is
    TYPE mystate IS (idle,rdAddr,rdDat,wrAddr,wrDat);
    signal state: mystate:= idle;
begin
	--initialise the processor here
     process(hclk)
     begin
     	if(hclk='1' and hclk'event) then
     	case state is
     		when idle=>
     			trans='0';
     			if(condition) then --neither reading nor writing
     				state = idle;
     			elsif(condition) then --reading
     				state = rdAddr;
     			else --writing
     				state = wrAddr;
     			end if;
     		when rdAddr=>
     			trans='1';
     			hwrite = '0';
     			--get the address which the processor has to read and save it in haddr
     			state = rdDat;
     		when rdDat=>
     			trans='0';
     			if(hready='1') then
     				--store hrdata at its appropriate location
     				state = idle;
     			else
     				state = rdDat;
     			end if;
     		when wrAddr=>
     			trans='1';
				hwrite = '1';
     			--get the address/data where/which the processor has to write and save them in haddr/hwdata
     			state = wrDat;
     		when wrDat=>
     			trans='0';
     			if(hready='1') then
     				--when the slave has successfully written the data in the memory
     				state = idle;
     			else
     				state = wrDat;
     			end if;
     	end case;
     	end if;
     end process;     
end master;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity SlaveInterface is
    port(
        haddr: in std_logic_vector(15 downto 0);
        hwrite: in std_logic;
        hsize: in std_logic_vector(2 downto 0);
        htrans: in std_logic;
        --hselx: in std_logic;
        --hready: in std_logic; --let's forget this one, shall we?
        hwdata: in std_logic_vector(31 downto 0);
        hclk : in std_logic;

        hreadyout: out std_logic;
        hrdata : out std_logic_vector(31 downto 0)

    );
end SlaveInterface;
architecture slave of SlaveInterface is
	TYPE mystate IS (waiting,rdAddr,rd1,rd2,rd3,wrAddr,wr1,wr2,wr3);
    signal state: mystate:= waiting;
begin
	process(hclk)
	begin
		if (hclk='1' and hclk'event) then
		case state is
			when waiting=>
				if(htrans='0') then
					state=waiting
				else
					if(hwrite='0') then
						state=rdAddr;
					else
						state=wrAddr;
					end if;
				end if;
			when rdaddr=>
				hreadyout<='0';
				--begin fetching from the memory using haddr
				state=rd1;
			when rd1=>
				state=rd2;
			when rd2=>
				state=rd3;
			when rd3=>
				hreadyout<='1'; --assumed that by the time control reaches here, hrdata is set correctly
				state=waiting;
			when wraddr=>
				hreadyout<='0';
				--begin writing the memory using haddr and hwdata
				state=wr1;
			when wr1=>
				state=wr2;
			when wr2=>
				state=wr3;
			when wr3=>
				hreadyout<='1'; --assumed that by the time control reaches here, hwdata is set correctly
				state=waiting;
		end case;
		end if;
	end process;    
end slave;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity Bus is
	port(
		clk: in std_logic
	);
end Bus;
architecture main of Bus is
	signal slaveReady: std_logic;
	signal slaveReadData: std_logic_vector(31 downto 0);
	signal masterWriteData: std_logic_vector(31 downto 0);
	signal masterAddress: std_logic_vector(15 downto 0);
	signal masterWriteBool: std_logic;
	signal masterSize: std_logic_vector(2 downto 0);
	signal masterTrans: std_logic;
begin
	MasterInterface: entity work.MasterInterface(master) port map(
		hready => slaveReady,
        hclk => clk,
        hrdata => slaveReadData,

        haddr => masterAddress,
        hwrite => masterWriteBool,
        hsize => masterSize,
        htrans => masterTrans,
        hwdata => masterWriteData 
	);	
	SlaveInterface: entity work.SlaveInterface(slave) port map(
		haddr => masterAddress,
        hwrite => masterWriteBool,
        hsize => masterSize,
        htrans => masterTrans,
        --hselx =>,
        --hready =>,
        hwdata => masterWriteData,
        hclk => clk,

        hreadyout => slaveReady,
        hrdata => slaveReadData
	);	
end main;