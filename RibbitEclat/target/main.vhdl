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

  type t_state is (compute84, get_wait89, pause_getI85, pause_getII86, pause_setI102, pause_setI106, pause_setI90, pause_setI94, pause_setI98, pause_setII103, pause_setII107, pause_setII91, pause_setII95, pause_setII99, q_wait100, q_wait104, q_wait108, q_wait87, q_wait92, q_wait96);
  signal \state\: t_state;
  type array_value_32 is array (natural range <>) of value(0 to 31);
  type array_value_96 is array (natural range <>) of value(0 to 95);
  signal arr80 : array_value_96(0 to 89999) := (others => (others => '0'));
  signal \$arr80_value\ : value(0 to 95);
  signal \$arr80_ptr\ : natural range 0 to 89999;
  signal \$arr80_ptr_write\ : natural range 0 to 89999;
  signal \$arr80_write\ : value(0 to 95);
  signal \$arr80_write_request\ : std_logic := '0';
  signal arr81 : array_value_32(0 to 4) := (others => (others => '0'));
  signal \$arr81_value\ : value(0 to 31);
  signal \$arr81_ptr\ : natural range 0 to 4;
  signal \$arr81_ptr_write\ : natural range 0 to 4;
  signal \$arr81_write\ : value(0 to 31);
  signal \$arr81_write_request\ : std_logic := '0';
  
  begin
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr80_write_request\ = '1' then
                    arr80(\$arr80_ptr_write\) <= \$arr80_write\;
                  else
                   \$arr80_value\ <= arr80(\$arr80_ptr\);
                  end if;
            end if;
        end process;
    
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr81_write_request\ = '1' then
                    arr81(\$arr81_ptr_write\) <= \$arr81_write\;
                  else
                   \$arr81_value\ <= arr81(\$arr81_ptr\);
                  end if;
            end if;
        end process;
    
    process(clk)
      variable \$v16\ : value(0 to 95) := (others => '0');
      variable \$v93\, sp_lock, result82, \$v88\, rdy83, \$v109\, \$v101\, 
               \$v97\, \$v105\ : value(0 to 0) := (others => '0');
      variable pos, stbl, pc, st, \$v15\, sp : value(0 to 31) := (others => '0');
      variable \$arr80_ptr_take\ : value(0 to 0) := "0";
      variable \$arr81_ptr_take\ : value(0 to 0) := "0";
      
    begin
      
      if rising_edge(clk) then
        if (reset = '1') then
          default_zero(\$v105\); default_zero(\$v16\); default_zero(sp); 
          default_zero(\$v15\); default_zero(st); default_zero(\$v97\); 
          default_zero(pc); default_zero(\$v101\); default_zero(stbl); 
          default_zero(\$v109\); default_zero(rdy83); default_zero(\$v88\); 
          default_zero(result82); default_zero(sp_lock); 
          default_zero(\$v93\); default_zero(pos); 
          rdy <= "1";
          rdy83 := "0";
          \state\ <= compute84;
          
        else if run = '1' then
          case \state\ is
          when get_wait89 =>
            if sp_lock(0) = '1' then
              \state\ <= get_wait89;
            else
              \$v15\ := sp;
              \$v88\ := \$arr80_ptr_take\;
              if \$v88\(0) = '1' then
                \state\ <= q_wait87;
              else
                \$arr80_ptr_take\(0) := '1';
                \$arr80_ptr\ <= to_integer(unsigned(\$v15\));
                \state\ <= pause_getI85;
              end if;
            end if;
          when pause_getI85 =>
            \state\ <= pause_getII86;
          when pause_getII86 =>
            \$arr80_ptr_take\(0) := '0';
            \$v16\ := \$arr80_value\;
            result82 := eclat_unit;
            eclat_print_string(of_string("Test"));
            
            rdy83 := eclat_true;
            \state\ <= compute84;
          when pause_setI102 =>
            \$arr81_write_request\ <= '0';
            \state\ <= pause_setII103;
          when pause_setI106 =>
            \$arr81_write_request\ <= '0';
            \state\ <= pause_setII107;
          when pause_setI90 =>
            \$arr81_write_request\ <= '0';
            \state\ <= pause_setII91;
          when pause_setI94 =>
            \$arr81_write_request\ <= '0';
            \state\ <= pause_setII95;
          when pause_setI98 =>
            \$arr81_write_request\ <= '0';
            \state\ <= pause_setII99;
          when pause_setII103 =>
            \$arr81_ptr_take\(0) := '0';
            \$v101\ := \$arr81_ptr_take\;
            if \$v101\(0) = '1' then
              \state\ <= q_wait100;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 2;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= st;
              \state\ <= pause_setI98;
            end if;
          when pause_setII107 =>
            \$arr81_ptr_take\(0) := '0';
            \$v105\ := \$arr81_ptr_take\;
            if \$v105\(0) = '1' then
              \state\ <= q_wait104;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 1;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= sp;
              \state\ <= pause_setI102;
            end if;
          when pause_setII91 =>
            \$arr81_ptr_take\(0) := '0';
            if sp_lock(0) = '1' then
              \state\ <= get_wait89;
            else
              \$v15\ := sp;
              \$v88\ := \$arr80_ptr_take\;
              if \$v88\(0) = '1' then
                \state\ <= q_wait87;
              else
                \$arr80_ptr_take\(0) := '1';
                \$arr80_ptr\ <= to_integer(unsigned(\$v15\));
                \state\ <= pause_getI85;
              end if;
            end if;
          when pause_setII95 =>
            \$arr81_ptr_take\(0) := '0';
            \$v93\ := \$arr81_ptr_take\;
            if \$v93\(0) = '1' then
              \state\ <= q_wait92;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 4;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= pos;
              \state\ <= pause_setI90;
            end if;
          when pause_setII99 =>
            \$arr81_ptr_take\(0) := '0';
            \$v97\ := \$arr81_ptr_take\;
            if \$v97\(0) = '1' then
              \state\ <= q_wait96;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 3;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= stbl;
              \state\ <= pause_setI94;
            end if;
          when q_wait100 =>
            \$v101\ := \$arr81_ptr_take\;
            if \$v101\(0) = '1' then
              \state\ <= q_wait100;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 2;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= st;
              \state\ <= pause_setI98;
            end if;
          when q_wait104 =>
            \$v105\ := \$arr81_ptr_take\;
            if \$v105\(0) = '1' then
              \state\ <= q_wait104;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 1;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= sp;
              \state\ <= pause_setI102;
            end if;
          when q_wait108 =>
            \$v109\ := \$arr81_ptr_take\;
            if \$v109\(0) = '1' then
              \state\ <= q_wait108;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 0;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= pc;
              \state\ <= pause_setI106;
            end if;
          when q_wait87 =>
            \$v88\ := \$arr80_ptr_take\;
            if \$v88\(0) = '1' then
              \state\ <= q_wait87;
            else
              \$arr80_ptr_take\(0) := '1';
              \$arr80_ptr\ <= to_integer(unsigned(\$v15\));
              \state\ <= pause_getI85;
            end if;
          when q_wait92 =>
            \$v93\ := \$arr81_ptr_take\;
            if \$v93\(0) = '1' then
              \state\ <= q_wait92;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 4;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= pos;
              \state\ <= pause_setI90;
            end if;
          when q_wait96 =>
            \$v97\ := \$arr81_ptr_take\;
            if \$v97\(0) = '1' then
              \state\ <= q_wait96;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 3;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= stbl;
              \state\ <= pause_setI94;
            end if;
          when compute84 =>
            rdy83 := eclat_false;
            pc := eclat_sub("00000000000000000000000000000000" & "00000000000000000000000000000001");
            sp := X"000" & X"15f90";
            st := eclat_sub("00000000000000000000000000000000" & "00000000000000000000000000000001");
            stbl := eclat_sub("00000000000000000000000000000000" & "00000000000000000000000000000001");
            pos := "00000000000000000000000000000000";
            \$v109\ := \$arr81_ptr_take\;
            if \$v109\(0) = '1' then
              \state\ <= q_wait108;
            else
              \$arr81_ptr_take\(0) := '1';
              \$arr81_ptr_write\ <= 0;
              \$arr81_write_request\ <= '1';
              \$arr81_write\ <= pc;
              \state\ <= pause_setI106;
            end if;
          end case;
          
          result <= result82;
          rdy <= rdy83;
          
        end if;
      end if;
    end if;
  end process;
end architecture;
