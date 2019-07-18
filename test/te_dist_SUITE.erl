-module(te_dist_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("tracing_experiments/include/tracing_experiments.hrl").

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
    OK1 = application:start(sasl),
    OK2 = application:start(tracing_experiments),
    ct:pal("************************* applications start ~p", [{OK1,OK2}]),
    Config.

end_per_suite(Config) ->  
    OK2 = application:stop(tracing_experiments),
    OK1 = application:stop(sasl),
    ct:pal("************************* applications stop ~p", [{OK1,OK2}]),
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
    tracing_experiments:switch_state(),
    timer:sleep(5 * ?HeavyStateWindowLength),
    {ok, heavy_state, _No} = gen_statem:call({global, tracing_experiments}, get_value),
    tracing_experiments:switch_state(),
    NewNo = No+6,
    {ok, light_state, NewNo} = gen_statem:call({global, tracing_experiments}, get_value).
