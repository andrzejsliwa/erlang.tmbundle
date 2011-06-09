-module (tm_complete).
-export ([complete/2, string/2]).

complete(Local, String) ->
    lists:flatten(string(Local, String)).

string(Local, String) -> 
    {PrefixLength, Options} = complete:string(Local, String),
    Choice = users_choice(Options),
    snippet(PrefixLength, Choice).

users_choice(Options) ->
    Menu = menu(Options),
    Selection = tm_menu:selection(Menu),
    option(Selection, Options, Menu).

menu([{fun_ref, {Function, Arity}}|Options]) ->
    [lists:flatten(io_lib:format("~w/~w", [Function, Arity]))|menu(Options)];
menu([{call, {Function, Arity}}|Options]) ->
    [lists:flatten(io_lib:format("~w/~w", [Function, Arity]))|menu(Options)];
menu([{module, Module}|Options]) -> [atom_to_list(Module)|menu(Options)];
menu([{var, Var}|Options]) -> [atom_to_list(Var)|menu(Options)];
menu([_|Options]) -> menu(Options);
menu([]) -> [].

option([], _, _) -> "";
option(Selection, [Option|_], [Selection|_]) -> Option;
option(Selection, [_|Options], [_|Menu]) -> option(Selection, Options, Menu).

snippet(L, {fun_ref, {F, A}}) -> io_lib:format("~s/~w", [trim(L, F), A]);
snippet(L, {call, {F, A}}) -> io_lib:format("~s(~s)", [trim(L, F), args(A)]);
snippet(L, {module, M}) -> trim(L, M);
snippet(L, {var, V}) -> trim(L, V);
snippet(_, _) -> "".

trim(PrefixLength, Atom) -> string:substr(atom_to_list(Atom), PrefixLength + 1).

args(0) -> "";
args(Arity) -> args(Arity, 1).
args(Arity, Arity) -> io_lib:format("${~w:Arg~w}", [Arity, Arity]);
args(Arity, N) ->
    [io_lib:format("${~w:Arg~w}, ", [N, N])|
    args(Arity, N + 1)].
