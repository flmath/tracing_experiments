tracing_experiments
=====

An OTP application

Build
-----

    $ local_rebar/rebar3 compile

Run
-----

    $ local_rebar/rebar3 shell
    > tracing_experiments:switch_state().
    ...
    > tracing_experiments:switch_state().
    > gen_statem:call(tracing_experiments, get_value).

Common test without debug info
-----
  
    $ local_rebar/rebar3 as ct ct --sname=my_node
    $ firefox ctlogs/index.html 

Common test with debug info
-----
  
    $ local_rebar/rebar3 as ct_dbg ct --suite te_SUITE 
    $ firefox ctlogs/index.html 

Common test with distributed nodes
-----
  
    $ ./dist_ct.sh  
    $ firefox ctlogs/index.html 