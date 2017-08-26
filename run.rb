require 'optparse'
require 'csv'
require_relative "lib/myxplor/models/response"
require_relative "lib/myxplor/models/question"

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

    # puts "Survey Data: #{survey_data.inspect}"
    # puts "Res Data: #{response_data.inspect}"
    @responses ||= response_data.map do |rp|
      Myxplor::Response.new(survey: survey_data, **rp)
    end

    responses_count = @responses.length
    # puts "Res count #{responses_count}"

    submitted_responses = response_data.select{|x| x[:submitted_at]!=nil }
    submitted_responses_count = submitted_responses.length
    # puts "Submited Responses #{submitted_responses}"
    # puts "Sub count #{submitted_responses_count}"

    # Part 1
    participation_percentage = ((submitted_responses_count.to_f / responses_count) * 100).round(2)
    puts "Participation %: #{participation_percentage}"

    participant_count = submitted_responses_count
    puts "Participant count: #{participant_count}"

    # Part 2
    @questions ||= survey_data.map do |q|
      Myxplor::Question.new(**q)
    end
    # puts "Questions : #{@questions.inspect}"

    quest = @questions.select{ |q| q.type == "ratingquestion"}
    # puts "Quest : #{quest.inspect}"

    number_of_rating_questions = quest.length
    puts "Rating count: #{number_of_rating_questions}"

    qs = []
    quest.each do |q|
      qs << q.text
    end

    # qa = []
    # submitted_responses.each do |sub|
    #   qa << qs.zip(sub[:answers])

    #   # puts "Q&A #{qs.zip(sub[:answers]).inspect}"
    #   puts "A #{sub[:answers].inspect}"
    # end


    # qas = []
    # i = 0
    # quest.each do |x|
    #   qa = []
    #   qa << x.text
    #   submitted_responses.each do |sub|
    #     qa << sub[:answers][i]
    #   end
    #   i = i+1
    #   qas << qa
    # end

    qas = []
    i = 0
    quest.each do |x|
      qa = {}
      qa = {:question => x.text }
      answers = []
      submitted_responses.each do |sub|
        answers << sub[:answers][i]
      end
      qa[:answers] = answers
      i = i+1
      qas << qa
    end



    # puts "QS -> #{qs.inspect}"
      puts "QA -> #{qas.inspect}"

    # qa.each do |q|
    #   puts "Q -> #{q.inspect}"
    # end


  end



end

Parser.new
Parser.parse
