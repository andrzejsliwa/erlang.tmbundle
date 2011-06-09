-module (complete).
-author('alain.odea@gmail.com').
-license('http://opensource.org/licenses/afl-3.0.php').
-export ([string/1, string/2]).

string(String) -> string([], String).
string(Local, String) ->
    complete(Local, lists:reverse(context(String))).

context(String) -> context(String, erl_scan:tokens([], String, 1)).
context(_, {done, Result, []}) -> Result;
context(String, {done, _, LeftOverChars}) ->
    context(String, erl_scan:tokens([], LeftOverChars, 1));
context(String, {more, _}) ->
    {ok, Tokens, _} = erl_scan:string(String),
    Tokens.

complete(_, [{atom,_,Function},{':',_},{atom,_,Module},{'fun',_}|_]) ->
    % select functions in fun M:F/Arity expression
    Prefix = atom_to_list(Function),
    {string:len(Prefix),[{fun_ref, F} || F <- lists:filter(starts_with(Prefix), Module:module_info(exports))]};
complete(_, [{':',_},{atom,_,Module},{'fun',_}|_]) ->
    % all functions in fun M:F/Arity expression
    {0,[{fun_ref, F} || F <- Module:module_info(exports)]};
complete([], [{atom,_,FunctionOrModule},{'fun',_}|_]) ->
    % select modules in fun M:F/Arity expression
    Prefix = atom_to_list(FunctionOrModule),
    {string:len(Prefix), [{fun_ref, F} || F <- lists:filter(starts_with(Prefix), builtins())] ++
    [{module, M} || M <- lists:filter(starts_with(Prefix), lists:sort(erlang:loaded()))]};
complete(Local, [{atom,_,FunctionOrModule},{'fun',_}|_]) ->
    % select local functions in fun F/Arity expression
    % select modules in fun M:F/Arity expression
    Prefix = atom_to_list(FunctionOrModule),
    {string:len(Prefix), [{fun_ref, F} || F <- lists:filter(starts_with(Prefix), Local:module_info(exports) ++ builtins())] ++
    [{module, M} || M <- lists:filter(starts_with(Prefix), lists:sort(erlang:loaded()))]};
complete([], [{'fun',_}|_]) ->
    % select modules in fun M:F/Arity expression
    {0, [{fun_ref, F} || F <- builtins()] ++
    [{module, M} || M <- lists:sort(erlang:loaded())]};
complete(Local, [{'fun',_}|_]) ->
    % select functions in fun F/Arity expression OR
    % select modules in fun M:F/Arity expression
    {0, [{fun_ref, F} || F <- Local:module_info(exports)] ++
    [{module, M} || M <- lists:sort(erlang:loaded())]};

complete(_, [{':',_},{atom,_,Module}|_]) ->
    % all functions in M:F expression
    {0, [{call, F} || F <- Module:module_info(exports)]};
complete(_, [{atom,_,Function},{':',_},{atom,_,Module}|_]) ->
    % select functions in M:F expression
    Prefix = atom_to_list(Function),
    {string:len(Prefix), [{call, F} || F <- lists:filter(starts_with(Prefix), Module:module_info(exports))]};

complete(_, [{'(',_},{atom,_,spawn}|_]) ->
    % all modules in spawn(M,F,A) expression
    % should complete to spawn(M,
    % TODO: support spawn(Node, M, F, A) as well
    {0, [{module, M} || M <- lists:sort(erlang:loaded())]};
complete(_, [{atom,_,Module},{'(',_},{atom,_,spawn}|_]) ->
    % select modules in spawn(M,F,A) expression
    Prefix = atom_to_list(Module),
    {string:len(Prefix), [{module, M} || M <- lists:filter(starts_with(Prefix), lists:sort(erlang:loaded()))]};
complete(_, [{',',_},{atom,_,Module},{'(',_},{atom,_,spawn}|_]) ->
    % all functions in spawn(M,F,A) expression
    % should complete to spawn(M, F,[${0:arg1},${1:arg2},...])
    {0, [{function, F} || F <- Module:module_info(exports)]};
complete(_, [{atom,_,Function},{',',_},{atom,_,Module},{'(',_},{atom,_,spawn}|_]) -> %
    % select functions in spawn(M,F,A) expression
    Prefix = atom_to_list(Function),
    {string:len(Prefix), [{function, F} || F <- lists:filter(starts_with(Prefix), Module:module_info(exports))]};

complete(_, [{atom,_,is},{'when',_}|_]) ->
    % all standard guard expressions
    % TODO: support all allowable guard functions like length
    % TODO: support compound guard expressions: when is_list(L); length(List) == 6; is_tuple(T)
    {0, [{call, F} || F <- lists:filter(starts_with("is_"), builtins())]};

complete([], [{atom,_,FunctionOrModule}|_]) ->
    % select modules
    Prefix = atom_to_list(FunctionOrModule),
    {string:len(Prefix), [{call, F} || F <- lists:filter(starts_with(Prefix), builtins())] ++
    [{module, M} || M <- lists:filter(starts_with(Prefix), lists:sort(erlang:loaded()))]};
complete(Local, [{atom,_,FunctionOrModule}|_]) ->
    % select builtin calls
    % select local calls
    % select modules
    Prefix = atom_to_list(FunctionOrModule),
    {string:len(Prefix), [{call, F} || F <- lists:filter(starts_with(Prefix), Local:module_info(exports) ++ builtins())] ++
    [{module, M} || M <- lists:filter(starts_with(Prefix), lists:sort(erlang:loaded()))]};

complete(_, [{var,_,Var}|Tokens]) ->
    % select variables in local scope
    Prefix = atom_to_list(Var),
    {string:len(Prefix), lists:filter(starts_with(Prefix), lists:ukeysort(2, vars(Tokens)))};
complete(_, Tokens) ->
    % select variables in local scope
    % select modules
    % TODO: select functions in local scope
    {0, lists:ukeysort(2, vars(Tokens)) ++
    [{module, M} || M <- lists:sort(erlang:loaded())]}.

builtins() ->
    lists:filter(fun({F,A}) -> erlang:is_builtin(erlang, F, A) end, erlang:module_info(exports)).

vars([]) -> [];
vars([{var,_,'_'}|Tokens]) -> vars(Tokens);
vars([{var,_,Var}|Tokens]) -> [{var,Var}|vars(Tokens)];
vars([{'->',_},{')',_}|Tokens]) -> vars_args(0, Tokens);
vars([_|Tokens]) -> vars(Tokens).

vars_args(_, []) -> [];
vars_args(0, [{'(',_}|_]) -> [];
vars_args(N, [{'(',_}|Tokens]) -> vars_args(N-1, Tokens);
vars_args(N, [{')',_}|Tokens]) -> vars_args(N+1, Tokens);
vars_args(N, [{var,_,'_'}|Tokens]) -> vars_args(N, Tokens);
vars_args(N, [{var,_,Var}|Tokens]) -> [{var,Var}|vars_args(N, Tokens)];
vars_args(N, [_|Tokens]) -> vars_args(N, Tokens).

starts_with(String) ->
    Len = string:len(String),
    fun({var,Var}) ->
        case string:substr(atom_to_list(Var), 1, Len) of
            String -> true;
            _ -> false
        end;
    ({Atom,_}) ->
        case string:substr(atom_to_list(Atom), 1, Len) of
            String -> true;
            _ -> false
        end;
    (Atom) ->
        case string:substr(atom_to_list(Atom), 1, Len) of
            String -> true;
            _ -> false
        end
    end.
