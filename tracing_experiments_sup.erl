%%% Created : 08 Jun 2019 by Mathias Green (flmath)
%%%-------------------------------------------------------------------
-module(tracing_experiments_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, kill/0, stop/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


kill()->
    supervisor:terminate_child(?SERVER, 'aFSM').

stop()->
    exit(self(), shutdown).
%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
init([]) ->

    SupFlags = #{strategy => one_for_one,
		 intensity => 1,
		 period => 5},

    AChild = #{id => 'aFSM',
	       start => {tracing_experiments, start_link, []},
	       restart => transient,
	       shutdown => 5000,
	       type => worker,
	       modules => [tracing_experiments]},

    {ok, {SupFlags, [AChild]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
