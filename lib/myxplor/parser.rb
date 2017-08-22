require 'optparse'

module Myxplor
  class Parser

    attr_accessor :options

    # This hash will hold all of the options parsed from the comand-line by
    # OptionParser
    def initialize
      @options = {}
    end

    def self.parse
      parser = OptionParser.new do |opts|
        opts.banner = "Myxplor Code Test"

        opts.on('--q', '--question file', 'Question data file') do |opt|
          options[:survey_file_path] = opt
        end

        opts.on('--r', '--response file', 'Response data file') do |opt|
          options[:response_file_path] = opt
        end
      end

      parser.parse!
    end

  end
end
