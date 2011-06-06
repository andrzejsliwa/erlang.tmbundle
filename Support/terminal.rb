begin
  require 'rubygems'
  require 'appscript'
  include Appscript
rescue LoadError
  raise 'You must "sudo gem install rb-appscript"'
end

def run(options)
  source_path = ENV["TM_DIRECTORY"]
  source_file = ENV["TM_FILEPATH"]
  ebin_path = "#{source_path}/../ebin"
  compile_path = File.exists?(ebin_path) ? ebin_path : source_path
  tab_name = "Erlang Textmate Shell"

  term = app('Terminal')
  app('Terminal').activate
  current_window = term.windows.get.first
  tab = current_window.tabs.get.select do |t|
    t.custom_title.get == tab_name 
  end[0]

  if options[:in_visor]
    app("System Events").application_processes["Terminal.app"].keystroke("§", :using => :command_down)
  end

  unless tab
    app("System Events").application_processes["Terminal.app"].keystroke("t", :using => :command_down)
    tab = current_window.tabs.last
    shell_command = "echo -n -e \"\\033]0;#{tab_name}\\007\"; cd #{source_path}; clear; erl -pa . -pa ../ebin -pl ../deps/*/ebin"
    app('Terminal').do_script(shell_command, :in => tab)
  else  
    cd_command = "cd(\"#{source_path}\")." 
    app('Terminal').do_script(cd_command, :in => tab)  
  end
  
  if options[:compile]
    compile_cmd = "c(\"#{source_file}\",[{outdir, \"#{compile_path}\"}])."
    app('Terminal').do_script(compile_cmd, :in => tab)
  end
end
