-module(cowboytest_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
            {'_', [
                    {"/", toppage_handler, []},
                    {"/websocket", ws_handler, []},
                    {"/static/[...]", cowboy_static, [
                            {directory, {priv_dir, websocket, [<<"static">>]}},
                            {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                        ]}
                ]}
        ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}]),
    cowboytest_sup:start_link().

stop(_State) ->
    ok.
