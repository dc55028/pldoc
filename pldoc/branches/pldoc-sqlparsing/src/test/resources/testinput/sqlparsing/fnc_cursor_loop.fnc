create or replace function fnc_for_loop_example (
    p_par_1   in number,
    p_par_2  in number)
    return varchar2
is
    l varchar2(255) := null;
begin
    for c1 in (
       select col1
       from   tab_1 p,
              tab_2 f,
              tab_3 w,
              (select nvl(v('FLOW_SECURITY_GROUP_ID'),0) sgid from dual) d
       where  (f.owner = user or user in ('SYS','SYSTEM', 'APEX_040000')  or d.sgid = f.security_group_id) and
              f.col_1 = w.col_1 and
              f.col_2 = p.col_2 and
              f.col_3 = p.col_3 and
              p.col_4 = p_col_4 and
              p.col_5 = p_col_5 and
              p.col_5 = 'LITERAL'
              ) loop
       l := dbms_lob.substr(c1.col1,255,1);
       l := substr(l,instr(l,':')+1);
       l := substr(l,1,instr(l,':')-1);
       exit;
    end loop;
    return l;
end;

