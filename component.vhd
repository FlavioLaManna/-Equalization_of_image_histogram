library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
port (
i_clk : in std_logic;
i_rst : in std_logic;
i_start : in std_logic;
i_data : in std_logic_vector(7 downto 0);
o_address : out std_logic_vector(15 downto 0);
o_done : out std_logic;
o_en : out std_logic;
o_we : out std_logic;
o_data : out std_logic_vector (7 downto 0)
);
end project_reti_logiche;

architecture behavioral of project_reti_logiche is
component datapath is
    Port ( i_clk : in std_logic;
           i_rst : in std_logic;
           i_data : in std_logic_vector (7 downto 0);
           o_data : out std_logic_vector (7 downto 0);
           r1_load : in std_logic;
           r2_load : in std_logic;
           r3_load : in std_logic;
           r4_load : in std_logic;
           r5_load : in std_logic;
           r6_load : in std_logic;
           r7_load : in std_logic;
           rMIN_load : in std_logic;
           rMAX_load : in std_logic;
           rd_load : in std_logic;
           rShift_load : in std_logic;
           r3_sel : in std_logic_vector (1 downto 0);
           r5_sel : in std_logic;
           r6_sel : in std_logic;
           r7_sel : in std_logic;
           o_end : out std_logic );
end component;

signal r1_load : std_logic;
signal r2_load : std_logic;
signal r3_load : std_logic;
signal r4_load : std_logic;
signal r5_load : std_logic;
signal r6_load : std_logic;
signal r7_load : std_logic;
signal rMIN_load : std_logic;
signal rMAX_load : std_logic;
signal rd_load : std_logic;
signal rShift_load : std_logic;
signal r3_sel : std_logic_vector (1 downto 0);
signal r5_sel : std_logic;
signal r6_sel : std_logic;
signal r7_sel : std_logic;
signal o_end : std_logic;

type S is (S0, W, S1, S2, W2, S3, S4, W3, S5, S6, S7, W4, S8, S9);
signal cur_state, next_state : S;

signal o_r1 : std_logic_vector (7 downto 0);
signal o_r2 : std_logic_vector (7 downto 0);
signal o_r3 : std_logic_vector (15 downto 0);
signal o_r4 : std_logic_vector (15 downto 0);
signal o_r5 : std_logic_vector (7 downto 0);
signal o_r6 : std_logic_vector (7 downto 0);
signal o_r7 : std_logic_vector (15 downto 0);
signal o_rMIN : std_logic_vector (7 downto 0);
signal o_rMAX : std_logic_vector (7 downto 0);
signal o_rd : std_logic_vector (7 downto 0);
signal o_rShift : std_logic_vector (7 downto 0);
signal prod : std_logic_vector (15 downto 0);
signal mux_r3 : std_logic_vector (15 downto 0);
signal sub1 : std_logic_vector (15 downto 0);
signal compMIN : std_logic_vector (7 downto 0);
signal compMAX : std_logic_vector (7 downto 0);
signal mux_r5 : std_logic_vector (7 downto 0);
signal mux_r6 : std_logic_vector (7 downto 0);
signal sub2 : std_logic_vector (7 downto 0);
signal shiftLevel : std_logic_vector (7 downto 0);
signal mux_r7 : std_logic_vector (15 downto 0);
signal add : std_logic_vector (15 downto 0);
signal temp : std_logic_vector(15 downto 0);


begin 
--state machine
process(i_clk, i_rst)
begin
    if(i_rst = '1') then
        cur_state <= S0;
    elsif i_clk'event and i_clk = '1' then
        cur_state <= next_state;
    end if;
end process;

process(cur_state, i_start, o_end, prod)
begin
    next_state <= cur_state;
    case cur_state is
        when S0 =>
            if(i_start = '1') then
                next_state <= W;
            end if;
        when W =>
             next_state <= S1;
        when S1 =>
             next_state <= S2;
        when S2 =>
             next_state <= W2;
        when W2 =>
             next_state <= S3;
        when S3 =>
             if(prod = "0000000000000000") then
                next_state <= S9;
             else
                next_state <= S4;
             end if;
        when S4 =>
             next_state <= W3;
        when W3 =>
             next_state <= S5;
        when S5 =>
             if(o_end = '0') then
                next_state <= S4;
             else
                next_state <= S6;
             end if;
        when S6 =>
              next_state <= S7;
        when S7 =>
              next_state <= W4;
        when W4 =>
              next_state <= S8;
        when S8 =>
             if(o_end = '0') then
                next_state <= S7;
             else
                next_state <= S9;
             end if;
        when S9 =>
             if(i_start = '0') then
                next_state <= S0;
            end if;
    end case;
end process;

process(cur_state)
begin
    r1_load <= '0';
    r2_load <= '0';
    r3_load <= '0';
    r4_load <= '0';
    r5_load <= '0';
    r6_load <= '0';
    r7_load <= '0';
    rMIN_load <= '0';
    rMAX_load <= '0';
    rd_load <= '0';
    rShift_load <= '0';
    r3_sel <= "00";
    r5_sel <= '0';
    r6_sel <= '0';
    r7_sel <= '0';
    o_address <= "0000000000000000";
    o_en <= '0';
    o_we <= '0';
    o_done <= '0';
    case cur_state is
        when S0 =>
        when W =>
            o_address <= "0000000000000000";
            o_en <= '1';
            r1_load <= '1';
        when S1 =>
            o_address <= "0000000000000000";
            o_en <= '1';
            r1_load <= '1';
        when S2 =>
            o_address <= "0000000000000001";
            o_en <= '1';
            r2_load <= '1';
        when W2 =>
            o_address <= "0000000000000001";
            o_en <= '1';
            r2_load <= '1';
        when S3 =>
            r4_load <= '1';
            r3_load <= '1';
            r5_load <= '1';
            r6_load <= '1';
            r7_load <= '1';
        when S4 =>
            o_address <= (o_r7);
            o_en <= '1';
            r3_sel <= "01";
            r3_load <= '1';
            r7_sel <= '1';
            r7_load <= '1';
        when W3 =>
            rMIN_load <= '1';
            rMAX_load <= '1';
        when S5 =>
            r5_sel <= '1';
            r6_sel <= '1';
            r5_load <= '1';
            r6_load <= '1';
        when S6 =>
            rShift_load <= '1';
            r3_sel <= "10";
            r3_load <= '1';
            r7_sel <= '0';
            r7_load <= '1';
        when S7 =>
            o_address <= (o_r7);
            o_en <= '1';
            r3_sel <= "01";
            r3_load <= '1';
            r7_sel <= '1';
            r7_load <= '1';
        when W4 =>
            rd_load <= '1';
        when S8 =>
            o_address <= std_logic_vector(unsigned(o_r7) + unsigned(o_r4) - 1);
            o_en <= '1';
            o_we <= '1';
        when S9 =>
            o_done <= '1';
     end case;
end process;
            
--datapath
process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_r1 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r1_load = '1') then
                o_r1 <= i_data;
            end if;
        end if;
end process; 

process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_r2 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r2_load = '1') then
                o_r2 <= i_data;
            end if;
        end if;
end process;

prod <= std_logic_vector(unsigned(o_r1) * unsigned(o_r2));

process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_r4 <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(r4_load = '1') then
                o_r4 <= prod;
            end if;
        end if;
end process;    

with r3_sel select
    mux_r3 <= prod when "00",
              sub1 when "01",
              o_r4 when "10",
              "XXXXXXXXXXXXXXXX" when others;     
              
process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_r3 <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(r3_load = '1') then
                o_r3 <= mux_r3;
            end if;
        end if;
end process;    

sub1 <= std_logic_vector(unsigned(o_r3) - 1);

o_end <= '1' when (o_r3 = "0000000000000000") else '0'; 

process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_rMIN <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(rMIN_load = '1') then
                o_rMIN <= i_data;
            end if;
        end if;
end process;   

process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_rMAX <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(rMAX_load = '1') then
                o_rMAX <= i_data;
            end if;
        end if;
end process;       

compMIN <= o_rMIN when (o_rMIN < o_r5) else o_r5;

compMAX <= o_rMAX when (o_rMAX > o_r6) else o_r6;   

with r5_sel select
    mux_r5 <= "11111111" when '0',
              compMIN when '1',
              "XXXXXXXX" when others;  
              
with r6_sel select
    mux_r6 <= "00000000" when '0',
              compMAX when '1',
              "XXXXXXXX" when others;   
              
process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_r5 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r5_load = '1') then
                o_r5 <= mux_r5;
            end if;
        end if;
end process;     

process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_r6 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r6_load = '1') then
                o_r6 <= mux_r6;
            end if;
        end if;
end process;   

sub2 <= std_logic_vector(unsigned(o_r6) - unsigned(o_r5));  

shiftLevel <= "00001000" when (sub2 = "00000000") else  
              "00000111" when (sub2 = "00000001" or sub2 = "00000010") else 
              "00000110" when (sub2 >= "00000011" and sub2 <= "00000110") else
              "00000101" when (sub2 >= "00000111" and sub2 <= "00001110") else    
              "00000100" when (sub2 >= "00001111" and sub2 <= "00011110") else   
              "00000011" when (sub2 >= "00011111" and sub2 <= "00111110") else 
              "00000010" when (sub2 >= "00111111" and sub2 <= "01111110") else 
              "00000001" when (sub2 >= "01111111" and sub2 <= "11111110") else   
              "00000000" when (sub2 = "11111111") else   
              "00001001";      
              
process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_rShift <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(rShift_load = '1') then
                o_rShift <= shiftLevel;
            end if;
        end if;
end process;

process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_rd <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(rd_load = '1') then
                o_rd <= i_data;
            end if;
        end if;
end process;      
                        
temp <= std_logic_vector(shift_left((signed("00000000" & o_rd) - signed("00000000" & o_r5)), to_integer(unsigned(o_rShift))));
                        
o_data <= std_logic_vector(shift_left((signed(o_rd) - signed(o_r5)), to_integer(unsigned(o_rShift)))) when (temp < 255) else "11111111";       
    
with r7_sel select
    mux_r7 <= "0000000000000010" when '0',
              add when '1',
              "XXXXXXXXXXXXXXXX" when others;  
              
process(i_clk, i_rst)
begin
        if(i_rst = '1') then
            o_r7 <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(r7_load = '1') then
                o_r7 <= mux_r7;
            end if;
        end if;
end process;    

add <= std_logic_vector(unsigned(o_r7) + 1);

end Behavioral;