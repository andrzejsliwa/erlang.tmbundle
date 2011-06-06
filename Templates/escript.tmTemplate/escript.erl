%%%'   HEADER
%%
%% @author    ${TM_AUTHOR} <${TM_AUTHOR_EMAIL}>
%% @copyright ${TM_YEAR} ${TM_AUTHOR}
%% @doc       ${1:description} ${2:name}.
%% @end
%% -module(${TM_NEW_FILE_BASENAME}).
-export([main/1]).
-define(CMD, filename:basename(escript:script_name())).

%%%.
%%%'   PUBLIC API
-spec main(Args :: [string()]) -> ok.
main(_)->
    usage().

%%%.
%%%'   PRIVATE FUNCTIONS
%% @private
-spec usage() -> ok.
usage() ->
    io:format("Usage: ~s ...~n", [?CMD]),
    halt(1).
