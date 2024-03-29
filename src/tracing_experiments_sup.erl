%%%-------------------------------------------------------------------
%% @doc tracing_experiments top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(tracing_experiments_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_one,
		 intensity => 3,
		 period => 5},
    ChildSpecs = [
		  #{id => 'aFSM',
		    start => {tracing_experiments, start_link, []},
		    restart => transient,
		    shutdown => 5000,
		    type => worker,
		    modules => [tracing_experiments]}
		 ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
