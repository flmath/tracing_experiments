%%%-------------------------------------------------------------------
%% @doc tracing_experiments public API
%% @end
%%%-------------------------------------------------------------------

-module(tracing_experiments_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    tracing_experiments_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
