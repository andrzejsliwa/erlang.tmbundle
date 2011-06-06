%%%'   HEADER
%%
%% @author    ${TM_AUTHOR} <${TM_AUTHOR_EMAIL}>
%% @copyright ${TM_YEAR} ${TM_AUTHOR}
%% @doc       EUnit test suite module ${1:name}.
%% @end
-module(${TM_NEW_FILE_BASENAME}).
-author('${TM_AUTHOR} <${TM_AUTHOR_EMAIL}>').

-define(NOTEST, true).
-define(NOASSERT, true).
-include_lib("eunit/include/eunit.hrl").

-define(MODNAME, ${1:name}).
%%%.
%%%' TEST GENERATOR
-spec ${1:name}_test_() -> [term()].
${1:name}_test_() ->
    %% add your asserts in the returned list, e.g.:
    %% [
    %%   ?assert(?MODNAME:double(2) =:= 4),
    %%   ?assertMatch({ok, Pid}, ?MODNAME:spawn_link()),
    %%   ?assertEqual("ba", ?MODNAME:reverse("ab")),
    %%   ?assertError(badarith, ?MODNAME:divide(X, 0)),
    %%   ?assertExit(normal, ?MODNAME:exit(normal)),
    %%   ?assertThrow({not_found, _}, ?MODNAME:func(unknown_object))
    %% ]
    [].
