-module(tm_menu).
-export([selection/1]).
-include_lib("xmerl/include/xmerl.hrl").

selection([]) -> "";
selection(MenuItems) ->
    % Just in case there are any spaces in the path to tm_dialog
    Dialog = re:replace(os:getenv("DIALOG_1"), "\s", "\\\\ ", [{return, list}]),
    PlistXml = os:cmd(string:concat(Dialog, io_lib:format(" -u -p \"~s\"", [ascii_plist(MenuItems)]))),
    {PlistDoc, _Rest} = xmerl_scan:string(PlistXml),
    selected( xmerl_xpath:string("/plist/dict/dict[preceding-sibling::key[1]='selectedMenuItem']/string[preceding-sibling::key[1]='title']/text()", PlistDoc)).

selected([#xmlText{value=Selected}]) -> Selected;
selected([]) ->"".

ascii_plist(MenuItems) ->
    ["{menuItems = (", [io_lib:format("{title = ~s;},", [Item]) || Item <- MenuItems], ");}"].
