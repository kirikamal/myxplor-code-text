require 'optparse'
require 'csv'
require_relative "lib/myxplor/models/response"

class Parser

  attr_accessor :options

  # This hash will hold all of the options parsed from the comand-line by
  # OptionParser
  def initialize
    @options = { :survey_file_path => nil, :response_file_path => nil }
  end

  def self.parse
    options = { :survey_file_path => nil, :response_file_path => nil }

    parser = OptionParser.new do |opts|
      opts.banner = "Myxplor Code Test"

      opts.on('--s', '--survey file', 'Survey data file') do |opt|
        options[:survey_file_path] = opt
      end

      opts.on('--r', '--response file', 'Response data file') do |opt|
        options[:response_file_path] = opt
        puts "#{options.inspect}"
      end
    end

    parser.parse!

    processor(**options)

  end

  def self.processor(survey_file_path:, response_file_path:)
    @survey_file = File.new(survey_file_path)
    @response_file = File.new(response_file_path)

    survey_data = CSV.new(@survey_file, headers: true, header_converters: :symbol).to_a.map(&:to_hash)

    response_data = CSV.new(@response_file).to_a.map do |row|
      {
        email: row[0],
        employee_id: row[1],
        submitted_at: row[2],
        answers: row[3..-1]
      }
    end

    puts "Survey Data: #{survey_data.inspect}"
    puts "Res Data: #{response_data.inspect}"
    @responses ||= response_data.map do |rp|
      Myxplor::Response.new(survey: survey_data, **rp)
    end

    responses_count = @responses.length
    puts "Res count #{responses_count}"

    submitted_count = response_data.select{|x| x[:submitted_at]!=nil }
    submitted_responses_count = submitted_count.length
    puts "Sub count #{submitted_responses_count}"

    # Part 1
    participation_percentage = ((submitted_responses_count.to_f / responses_count) * 100).round(2)
    puts "Participation %: #{participation_percentage}"

    participant_count = submitted_responses_count
    puts "Participant count: #{participant_count}"

    # Part 2



  end



end

Parser.new
Parser.parse
