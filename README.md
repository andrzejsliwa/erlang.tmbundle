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
    sudo gem install rb-appscript
    Visor (for integration with terminal)
    
    
Feedback welcome.

Andrzej Sliwa  
June 6, 2011.