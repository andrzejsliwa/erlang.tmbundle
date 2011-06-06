require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'

class RebarController < ApplicationController

  before_filter :check_rebar

  def compile
    handle_compile_errors(run_rebar('compile'))
    render "rebar/compile"
  end

  def eunit
    handle_compile_errors(run_rebar('eunit'))
    render "rebar/eunit"
  end

  def clean
    handle_compile_errors(run_rebar('clean'))
    render "rebar/clean"
  end

  def custom
    @command = TextMate::UI.request_string(:title => "Run Rebar Command", :prompt => "Enter rebar command:")
    run_rebar(@command)
    render "rebar/custom"
  end

  private

  def check_rebar
    unless File.exist?(ENV['TM_PROJECT_DIRECTORY'] + "/rebar")
      @error = "Missing Rebar in project directory."
      render "rebar/_error"
      false
    else
      true
    end
  end

  def handle_compile_errors(output)
    @results = []
    output.each_line do |line|
      if /(.*):(\d+):(\sWarning:|)\s(.*)/ =~ line
        file = ENV['TM_PROJECT_DIRECTORY'] + "/" +Regexp.last_match[1]
        lineNum = Regexp.last_match[2]
        className = Regexp.last_match[3].size == 0 ? 'error' : 'warning'
        message = Regexp.last_match[4]
        url = "txmt://open/?url=file://" + file.gsub(/[^a-zA-Z0-9.-\_\/]/) { |m| sprintf("%%%02X", m[0]) } +
          "&amp;line=" + lineNum
        @results << { :url => url, :line => line, :class => className }
        @output = @output.gsub(line, "")
      end
    end

  end

  def run_rebar(tasks)
    @output = `cd #{ENV['TM_PROJECT_DIRECTORY']};./rebar #{tasks}`
    @output
  end
end