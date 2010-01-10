require 'albacore/support/albacore_helper'

class XUnitTestRunner
  include AttrMethods
  include RunCommand
  include YAMLConfig

  attr_accessor :path_to_command, :html_output
  attr_array :assemblies, :options

  def initialize(path_to_command='')
    @path_to_command = path_to_command
    @assemblies=[]
    super()
  end

  def get_command_line
    command = []
    command << @path_to_command
    command << get_command_parameters

    cmd = command.join(" ")
    @logger.debug "Build XUnit Test Runner Command Line: " + cmd
    return cmd
  end
  
  def get_command_parameters
    command_params = []
    command_params << build_assembly_list unless @assemblies.empty?
    command_params << @options.join(" ") unless @options.nil?
    command_params << build_html_output unless @html_output.nil?
    command_params
  end

  def execute()
    command_params = get_command_parameters
    result = run_command "XUnit", command_params.join(" ")

    failure_message = 'XUnit Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end

  def build_assembly_list
    @assemblies.map{|asm| "\"#{asm}\""}.join(" ")
  end

  def build_html_output
    "/html #{@html_output}"
  end
end