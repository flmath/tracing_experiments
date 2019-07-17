%%%-------------------------------------------------------------------
%%% @copyright (C) 2019, Mathias Green
%%% @doc
%%% Basic statem for testing purposes
%%% @end
%%% Created : 08 Jun 2019 by Mathias Green (flmath)
%%%-------------------------------------------------------------------
-module(tracing_experiments).

-behaviour(gen_statem).

%% API
-export([start_link/0]).
-export([switch_state/0, stop/0]).
%% gen_statem callbacks
-export([init/1, callback_mode/0, light_state/3, heavy_state/3,
	 terminate/3, code_change/4]).
-define(NAME, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
start_link() ->
    gen_statem:start_link({local, ?NAME}, ?MODULE, [], []).

switch_state()->
    gen_statem:cast(?NAME, switch_state).

stop() ->
    gen_statem:call(?NAME, stop).

%%%===================================================================
%%% gen_statem callbacks
%%%===================================================================

%%--------------------------------------------------------------------
init([]) ->
    {ok, light_state, #{iterator=>0}}.

callback_mode() ->
    state_functions.

%%--------------------------------------------------------------------
light_state(cast, switch_state, State) ->
    #{iterator:=Number}=State,
    traced_function(enter_heavy_state, Number),
    {next_state, heavy_state, State#{iterator:=Number+1},1000};
light_state({call, From}, get_value, State) ->    
    #{iterator:=Number} = State,     
    {next_state, light_state, State, [{reply, From, {ok, light_state, Number}}]}.

heavy_state(cast, switch_state, State) ->   
    #{iterator:=Number}=State,
    traced_function(enter_light_state, Number),
    {next_state, light_state, State#{iterator:=Number+1}};
heavy_state(timeout, _Event, State) ->   
    #{iterator:=Number}=State,
    traced_function(stay_heavy_state, Number),
    {next_state, heavy_state, State#{iterator:=Number+1},1000};
heavy_state({call, From}, get_value, State) ->  
    #{iterator:=Number}=State,       
    {next_state, heavy_state, State, [{reply, From, {ok, heavy_state, Number}}]}.



%%--------------------------------------------------------------------

handle_call(From, stop, State) ->
     {stop_and_reply, normal,  {reply, From, ok}, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

%%--------------------------------------------------------------------
code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

traced_function(StateName, Number)->
    io:format("io:format called from state ~p number ~p~n", [StateName, Number]).
