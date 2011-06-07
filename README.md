# TextMate Bundle for Erlang Development

To install with Git:

    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    git clone git://github.com/andrzejsliwa/erlang.tmbundle.git
    osascript -e 'tell app "TextMate" to reload bundles'


To install without Git:

    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    wget http://github.com/andrzejsliwa/erlang.tmbundle/tarball/master
    tar zxf andrzejsliwa-erlang.tmbundle*.tar.gz
    rm andrzejsliwa-erlang.tmbundle*.tar.gz
    mv andrzejsliwa-erlang.tmbundle* "erlang.tmbundle"
    osascript -e 'tell app "TextMate" to reload bundles'

Required:

    Ruby 1.8.7 or greater
    gem install rb-appscript (and define right PATH to ruby in "TextMate -> Preferences -> Advanced -> Shell Variables")
    Visor (for integration with terminal)

Options ( TextMate -> Preferences -> Advanced -> Shell Variables ):

    Define erlang node for shell:

    Variable     |  Value
    -----------------------------------
    ERLANG_NODE  |  -name mac@127.0.0.1

    If ERLANG_NODE not defined then is used default '-name mate@127.0.0.1'

Feedback welcome.

Andrzej Sliwa
June 6, 2011.