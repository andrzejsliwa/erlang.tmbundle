# TextMate Bundle for Erlang Development

To install with Git:
--------------------

    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    git clone git://github.com/andrzejsliwa/erlang.tmbundle.git
    osascript -e 'tell app "TextMate" to reload bundles'


To install without Git:
-----------------------

    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    wget http://github.com/andrzejsliwa/erlang.tmbundle/tarball/master
    tar zxf andrzejsliwa-erlang.tmbundle*.tar.gz
    rm andrzejsliwa-erlang.tmbundle*.tar.gz
    mv andrzejsliwa-erlang.tmbundle* "erlang.tmbundle"
    osascript -e 'tell app "TextMate" to reload bundles'

Required:
---------

    Ruby 1.8.7 or greater
    gem install rb-appscript (and define right PATH to ruby in "TextMate -> Preferences -> Advanced -> Shell Variables")
    Visor (for integration with terminal)

    Define erlang variables for using with autocomplete

    Variable      | Value
    ------------------------------------
    ERLANG_LIB    | value from erl (code:lib_dir().)
    ERL_BIN       | value from string:concat(code:root_dir(), "/bin").

Options ( TextMate -> Preferences -> Advanced -> Shell Variables ):
-------------------------------------------------------------------

    Define erlang node for shell:

    Variable     |  Value
    -----------------------------------
    ERLANG_NODE  |  -name mac@127.0.0.1

    If ERLANG_NODE not defined then is used default '-name mate@127.0.0.1'


Credites
--------

    *   Most of the logic for Erlang code completion is from Alain O'Dea's [erlang code completion][1] repo
    *   eflymake from Kevin Smith's [hl-emacs][2] repo

    [1]: http://github.com/AlainODea/erlang_code_completion
    [2]: http://github.com/kevsmith/hl-emacs
    [3]: http://manual.macromates.com/en/environment_variables.html
    [4]: http://docs.info.apple.com/article.html?path=Mac/10.6/en/8597.html
    [5]: http://docs.info.apple.com/article.html?path=Mac/10.5/en/8324.html
    [6]: http://docs.info.apple.com/article.html?path=Mac/10.4/en/mh632.html

Feedback welcome.

Andrzej Sliwa
June 6, 2011.