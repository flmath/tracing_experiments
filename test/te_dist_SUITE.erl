-module(te_dist_SUITE).

-include_lib("common_test/include/ct.hrl").
-include("../include/tracing_experiments.hrl").

%% Common Test
-export([all/0,
         init_per_suite/1,
         end_per_suite/1]).

%% Tests
-export([five_seconds_test/1, switch_test/1]).

%%==============================================================================
%% Common Test
%%==============================================================================

all() ->
    [switch_test, five_seconds_test].

init_per_suite(Config) ->
    {ok, HostNodeA} = start_slave(a),
    ct:pal("************************* applications start ~p", [{HostNodeA}]),
    ok = global:sync(),
    Config.

start_slave(Node)->
    ErlFlags = "-pa ../../_build/dist+test/lib/*/ebin",
    {ok, HostNode} = 
	ct_slave:start(Node,
		       [{kill_if_fail, true}, {monitor_master, true},
			{init_timeout, 3000}, {startup_timeout, 3000},
			{startup_functions, 
			 [{application, start, [sasl]},
			  {application, start, [tracing_experiments]}]},
			{erl_flags, ErlFlags}]),
    pong = net_adm:ping(HostNode),    
    ct:pal("pong == ~p",[ pong = net_adm:ping(HostNode)]),
    {ok, HostNode}.

end_per_suite(Config) ->  
    Config.

%%==============================================================================
%% Exported Test functions
%%==============================================================================

switch_test(_Config) ->
    {ok, State, No} = 
	gen_statem:call({global, tracing_experiments}, get_value),
    ct:pal("get state ~p~n",[{State, No}]).

five_seconds_test(_Config) ->
    {ok, light_state, No} = 
	gen_statem:call({global, tracing_experiments}, get_value),
    gen_statem:cast({global, tracing_experiments}, switch_state),
    timer:sleep(5 * ?HeavyStateWindowLength),
    {ok, heavy_state, _No} = gen_statem:call({global, tracing_experiments}, get_value),
    gen_statem:cast({global, tracing_experiments}, switch_state),
    NewNo = No+6,
    {ok, light_state, NewNo} = gen_statem:call({global, tracing_experiments}, get_value).
