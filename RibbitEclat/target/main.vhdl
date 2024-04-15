-- code generated from the following source code:
--   ../RibbitVm/fail.ecl
--   ../RibbitVm/vm.ecl
--
-- with the following command:
--
--    ./eclat ../RibbitVm/fail.ecl ../RibbitVm/vm.ecl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.runtime.all;


entity main is
  
  port(signal clk    : in std_logic;
       signal reset  : in std_logic;
       signal run    : in std_logic;
       signal rdy    : out value(0 to 0);
       signal argument : in value(0 to 0);
       signal result : out value(0 to 0));
       
end entity;
architecture rtl of main is

  type t_state is (compute173, \$97_forever130\, pause_setI174, pause_setI178, pause_setI182, pause_setI186, pause_setI190, pause_setI194, pause_setII175, pause_setII179, pause_setII183, pause_setII187, pause_setII191, pause_setII195, q_wait176, q_wait180, q_wait184, q_wait188, q_wait192, q_wait196);
  signal \state\: t_state;
  type array_value_32 is array (natural range <>) of value(0 to 31);
  signal arr164 : array_value_32(0 to 89999) := (others => (others => '0'));
  signal \$arr164_value\ : value(0 to 31);
  signal \$arr164_ptr\ : natural range 0 to 89999;
  signal \$arr164_ptr_write\ : natural range 0 to 89999;
  signal \$arr164_write\ : value(0 to 31);
  signal \$arr164_write_request\ : std_logic := '0';
  signal arr165 : array_value_32(0 to 0) := (others => (others => '0'));
  signal \$arr165_value\ : value(0 to 31);
  signal \$arr165_ptr\ : natural range 0 to 0;
  signal \$arr165_ptr_write\ : natural range 0 to 0;
  signal \$arr165_write\ : value(0 to 31);
  signal \$arr165_write_request\ : std_logic := '0';
  signal arr166 : array_value_32(0 to 0) := (others => (others => '0'));
  signal \$arr166_value\ : value(0 to 31);
  signal \$arr166_ptr\ : natural range 0 to 0;
  signal \$arr166_ptr_write\ : natural range 0 to 0;
  signal \$arr166_write\ : value(0 to 31);
  signal \$arr166_write_request\ : std_logic := '0';
  signal arr167 : array_value_32(0 to 0) := (others => (others => '0'));
  signal \$arr167_value\ : value(0 to 31);
  signal \$arr167_ptr\ : natural range 0 to 0;
  signal \$arr167_ptr_write\ : natural range 0 to 0;
  signal \$arr167_write\ : value(0 to 31);
  signal \$arr167_write_request\ : std_logic := '0';
  signal arr168 : array_value_32(0 to 0) := (others => (others => '0'));
  signal \$arr168_value\ : value(0 to 31);
  signal \$arr168_ptr\ : natural range 0 to 0;
  signal \$arr168_ptr_write\ : natural range 0 to 0;
  signal \$arr168_write\ : value(0 to 31);
  signal \$arr168_write_request\ : std_logic := '0';
  signal arr169 : array_value_32(0 to 0) := (others => (others => '0'));
  signal \$arr169_value\ : value(0 to 31);
  signal \$arr169_ptr\ : natural range 0 to 0;
  signal \$arr169_ptr_write\ : natural range 0 to 0;
  signal \$arr169_write\ : value(0 to 31);
  signal \$arr169_write_request\ : std_logic := '0';
  signal arr170 : array_value_32(0 to 0) := (others => (others => '0'));
  signal \$arr170_value\ : value(0 to 31);
  signal \$arr170_ptr\ : natural range 0 to 0;
  signal \$arr170_ptr_write\ : natural range 0 to 0;
  signal \$arr170_write\ : value(0 to 31);
  signal \$arr170_write_request\ : std_logic := '0';
  
  begin
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr164_write_request\ = '1' then
                    arr164(\$arr164_ptr_write\) <= \$arr164_write\;
                  else
                   \$arr164_value\ <= arr164(\$arr164_ptr\);
                  end if;
            end if;
        end process;
    
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr165_write_request\ = '1' then
                    arr165(\$arr165_ptr_write\) <= \$arr165_write\;
                  else
                   \$arr165_value\ <= arr165(\$arr165_ptr\);
                  end if;
            end if;
        end process;
    
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr166_write_request\ = '1' then
                    arr166(\$arr166_ptr_write\) <= \$arr166_write\;
                  else
                   \$arr166_value\ <= arr166(\$arr166_ptr\);
                  end if;
            end if;
        end process;
    
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr167_write_request\ = '1' then
                    arr167(\$arr167_ptr_write\) <= \$arr167_write\;
                  else
                   \$arr167_value\ <= arr167(\$arr167_ptr\);
                  end if;
            end if;
        end process;
    
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr168_write_request\ = '1' then
                    arr168(\$arr168_ptr_write\) <= \$arr168_write\;
                  else
                   \$arr168_value\ <= arr168(\$arr168_ptr\);
                  end if;
            end if;
        end process;
    
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr169_write_request\ = '1' then
                    arr169(\$arr169_ptr_write\) <= \$arr169_write\;
                  else
                   \$arr169_value\ <= arr169(\$arr169_ptr\);
                  end if;
            end if;
        end process;
    
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr170_write_request\ = '1' then
                    arr170(\$arr170_ptr_write\) <= \$arr170_write\;
                  else
                   \$arr170_value\ <= arr170(\$arr170_ptr\);
                  end if;
            end if;
        end process;
    
    process(clk)
      variable \$v177\, rdy172, \$v185\, \$v197\, \$v181\, result171, 
               \$v193\, \$v189\ : value(0 to 0) := (others => '0');
      variable \$arr164_ptr_take\ : value(0 to 0) := "0";
      variable \$arr165_ptr_take\ : value(0 to 0) := "0";
      variable \$arr166_ptr_take\ : value(0 to 0) := "0";
      variable \$arr167_ptr_take\ : value(0 to 0) := "0";
      variable \$arr168_ptr_take\ : value(0 to 0) := "0";
      variable \$arr169_ptr_take\ : value(0 to 0) := "0";
      variable \$arr170_ptr_take\ : value(0 to 0) := "0";
      
    begin
      
      if rising_edge(clk) then
        if (reset = '1') then
          default_zero(\$v189\); default_zero(\$v193\); 
          default_zero(result171); default_zero(\$v181\); 
          default_zero(\$v197\); default_zero(\$v185\); default_zero(rdy172); 
          default_zero(\$v177\); 
          rdy <= "1";
          rdy172 := "0";
          \state\ <= compute173;
          
        else if run = '1' then
          case \state\ is
          when \$97_forever130\ =>
            \state\ <= \$97_forever130\;
          when pause_setI174 =>
            \$arr170_write_request\ <= '0';
            \state\ <= pause_setII175;
          when pause_setI178 =>
            \$arr169_write_request\ <= '0';
            \state\ <= pause_setII179;
          when pause_setI182 =>
            \$arr168_write_request\ <= '0';
            \state\ <= pause_setII183;
          when pause_setI186 =>
            \$arr167_write_request\ <= '0';
            \state\ <= pause_setII187;
          when pause_setI190 =>
            \$arr166_write_request\ <= '0';
            \state\ <= pause_setII191;
          when pause_setI194 =>
            \$arr165_write_request\ <= '0';
            \state\ <= pause_setII195;
          when pause_setII175 =>
            \$arr170_ptr_take\(0) := '0';
            result171 := eclat_unit;
            eclat_print_string(of_string("Test"));
            
            rdy172 := eclat_true;
            \state\ <= compute173;
          when pause_setII179 =>
            \$arr169_ptr_take\(0) := '0';
            \$v177\ := \$arr170_ptr_take\;
            if \$v177\(0) = '1' then
              \state\ <= q_wait176;
            else
              \$arr170_ptr_take\(0) := '1';
              \$arr170_ptr_write\ <= 0;
              \$arr170_write_request\ <= '1';
              \$arr170_write\ <= X"000" & X"15f90";
              \state\ <= pause_setI174;
            end if;
          when pause_setII183 =>
            \$arr168_ptr_take\(0) := '0';
            \$v181\ := \$arr169_ptr_take\;
            if \$v181\(0) = '1' then
              \state\ <= q_wait180;
            else
              \$arr169_ptr_take\(0) := '1';
              \$arr169_ptr_write\ <= 0;
              \$arr169_write_request\ <= '1';
              \$arr169_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI178;
            end if;
          when pause_setII187 =>
            \$arr167_ptr_take\(0) := '0';
            \$v185\ := \$arr168_ptr_take\;
            if \$v185\(0) = '1' then
              \state\ <= q_wait184;
            else
              \$arr168_ptr_take\(0) := '1';
              \$arr168_ptr_write\ <= 0;
              \$arr168_write_request\ <= '1';
              \$arr168_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI182;
            end if;
          when pause_setII191 =>
            \$arr166_ptr_take\(0) := '0';
            \$v189\ := \$arr167_ptr_take\;
            if \$v189\(0) = '1' then
              \state\ <= q_wait188;
            else
              \$arr167_ptr_take\(0) := '1';
              \$arr167_ptr_write\ <= 0;
              \$arr167_write_request\ <= '1';
              \$arr167_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI186;
            end if;
          when pause_setII195 =>
            \$arr165_ptr_take\(0) := '0';
            \$v193\ := \$arr166_ptr_take\;
            if \$v193\(0) = '1' then
              \state\ <= q_wait192;
            else
              \$arr166_ptr_take\(0) := '1';
              \$arr166_ptr_write\ <= 0;
              \$arr166_write_request\ <= '1';
              \$arr166_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI190;
            end if;
          when q_wait176 =>
            \$v177\ := \$arr170_ptr_take\;
            if \$v177\(0) = '1' then
              \state\ <= q_wait176;
            else
              \$arr170_ptr_take\(0) := '1';
              \$arr170_ptr_write\ <= 0;
              \$arr170_write_request\ <= '1';
              \$arr170_write\ <= X"000" & X"15f90";
              \state\ <= pause_setI174;
            end if;
          when q_wait180 =>
            \$v181\ := \$arr169_ptr_take\;
            if \$v181\(0) = '1' then
              \state\ <= q_wait180;
            else
              \$arr169_ptr_take\(0) := '1';
              \$arr169_ptr_write\ <= 0;
              \$arr169_write_request\ <= '1';
              \$arr169_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI178;
            end if;
          when q_wait184 =>
            \$v185\ := \$arr168_ptr_take\;
            if \$v185\(0) = '1' then
              \state\ <= q_wait184;
            else
              \$arr168_ptr_take\(0) := '1';
              \$arr168_ptr_write\ <= 0;
              \$arr168_write_request\ <= '1';
              \$arr168_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI182;
            end if;
          when q_wait188 =>
            \$v189\ := \$arr167_ptr_take\;
            if \$v189\(0) = '1' then
              \state\ <= q_wait188;
            else
              \$arr167_ptr_take\(0) := '1';
              \$arr167_ptr_write\ <= 0;
              \$arr167_write_request\ <= '1';
              \$arr167_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI186;
            end if;
          when q_wait192 =>
            \$v193\ := \$arr166_ptr_take\;
            if \$v193\(0) = '1' then
              \state\ <= q_wait192;
            else
              \$arr166_ptr_take\(0) := '1';
              \$arr166_ptr_write\ <= 0;
              \$arr166_write_request\ <= '1';
              \$arr166_write\ <= "00000000000000000000000000000000";
              \state\ <= pause_setI190;
            end if;
          when q_wait196 =>
            \$v197\ := \$arr165_ptr_take\;
            if \$v197\(0) = '1' then
              \state\ <= q_wait196;
            else
              \$arr165_ptr_take\(0) := '1';
              \$arr165_ptr_write\ <= 0;
              \$arr165_write_request\ <= '1';
              \$arr165_write\ <= X"000" & X"15f90";
              \state\ <= pause_setI194;
            end if;
          when compute173 =>
            rdy172 := eclat_false;
            \$v197\ := \$arr165_ptr_take\;
            if \$v197\(0) = '1' then
              \state\ <= q_wait196;
            else
              \$arr165_ptr_take\(0) := '1';
              \$arr165_ptr_write\ <= 0;
              \$arr165_write_request\ <= '1';
              \$arr165_write\ <= X"000" & X"15f90";
              \state\ <= pause_setI194;
            end if;
          end case;
          
          result <= result171;
          rdy <= rdy172;
          
        end if;
      end if;
    end if;
  end process;
end architecture;
