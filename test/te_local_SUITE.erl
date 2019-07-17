-module(te_local_SUITE).

-include_lib("common_test/include/ct.hrl").

%% Common Test
-export([all/0,
         init_per_suite/1,
         end_per_suite/1]).

%% Tests
-export([switch_test/1]).

%%==============================================================================
%% Common Test
%%==============================================================================

all() ->
  [switch_test].

init_per_suite(Config) ->
    OK1 = application:start(tracing_experiments),
    ct:pal("************************* applications start ~p", [OK1]),
    Config.

end_per_suite(Config) ->  
    OK2 = application:stop(tracing_experiments),
    ct:pal("************************* applications stop ~p", [OK2]),

  Config.

%%==============================================================================
%% Exported Test functions
%%==============================================================================

switch_test(_Config) ->
    {ok, State, No} = 
	gen_statem:call(tracing_experiments, get_value),
    ct:pal("get state ~p~n",[{State, No}]).

