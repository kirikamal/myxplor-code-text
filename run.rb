require 'optparse'
require 'csv'
require_relative "lib/myxplor/models/response"
require_relative "lib/myxplor/models/question"
require_relative "lib/myxplor/processor"

class ParserProcess

  attr_accessor :options

  # This hash will hold all of the options parsed from the comand-line by
  # OptionParser
  def initialize
    @options = { :survey_file_path => nil, :response_file_path => nil }
  end

  def parse
    options = { :survey_file_path => nil, :response_file_path => nil }

    parser = OptionParser.new do |opts|
      opts.banner = "Myxplor Code Test"

      opts.on('--s', '--survey file', 'Survey data file') do |opt|
        options[:survey_file_path] = opt
      end

      opts.on('--r', '--response file', 'Response data file') do |opt|
        options[:response_file_path] = opt
      end
    end

    parser.parse!

    Myxplor::Processor.new.process_data(**options)

  end

end

# run the programm

p = ParserProcess.new
p.parse
