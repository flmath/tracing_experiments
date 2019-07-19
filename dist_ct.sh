local_rebar/rebar3  as dist,test compile 

ct_run -dir test -suite test/te_dist_SUITE \
    -pa ../../_build/dist\+test/lib/*/ebin -logdir ctlogs  -sname ct
