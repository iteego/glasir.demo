
drop user glasir_core cascade;
create user glasir_core identified by password;
grant all privileges to glasir_core;

-- To avoid XAException.XAER_RMERR
grant select on sys.dba_pending_transactions to glasir_core;
grant select on sys.pending_trans$ to glasir_core;
grant select on sys.dba_2pc_pending to glasir_core;
grant execute on sys.dbms_system to glasir_core;

drop user glasir_a cascade;
create user glasir_a identified by password;
grant all privileges to glasir_a;

-- To avoid XAException.XAER_RMERR
grant select on sys.dba_pending_transactions to glasir_a;
grant select on sys.pending_trans$ to glasir_a;
grant select on sys.dba_2pc_pending to glasir_a;
grant execute on sys.dbms_system to glasir_a;

drop user glasir_b cascade;
create user glasir_b identified by password;
grant all privileges to glasir_b;

-- To avoid XAException.XAER_RMERR
grant select on sys.dba_pending_transactions to glasir_b;
grant select on sys.pending_trans$ to glasir_b;
grant select on sys.dba_2pc_pending to glasir_b;
grant execute on sys.dbms_system to glasir_b;

drop user glasir_pub cascade;
create user glasir_pub identified by password;
grant all privileges to glasir_pub;

-- To avoid XAException.XAER_RMERR
grant select on sys.dba_pending_transactions to glasir_pub;
grant select on sys.pending_trans$ to glasir_pub;
grant select on sys.dba_2pc_pending to glasir_pub;
grant execute on sys.dbms_system to glasir_pub;

commit;

-- for the grants, see the following url:
-- http://docs.codehaus.org/display/BTM/FAQ#FAQ-WhyisOraclethrowingaXAExceptionduringinitializationofmydatasource%3F

