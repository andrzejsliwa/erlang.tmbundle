#!/usr/bin/env ruby

helper_path = ENV['TM_BUNDLE_SUPPORT'].gsub(/\\/, '') + "/shell_helper.scpt"
source_path, source_file = ARGV
ebin_path = "#{source_path}/../ebin"

compile_path = File.exists?(ebin_path) ? ebin_path : source_path

ENV['TM_BUNDE_SUPPORT'] = "/Users/mark/Library/Application\ Support/TextMate/Bundles/Erlang.tmbundle/Support"
system("/usr/bin/osascript", helper_path, source_path, source_file, compile_path)
