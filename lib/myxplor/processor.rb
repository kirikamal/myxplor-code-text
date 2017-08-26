require 'optparse'
require 'csv'

module Myxplor
	class Processor

		attr_accessor :survey_file, :response_file, :response_data, :survey_data, :question_and_answers, :number_of_rating_questions

		# def initialize(survey_file_path:, response_file_path:)
		# 	@survey_file = File.new(survey_file_path)
		# 	@response_file = File.new(response_file_path)
		# end

		def process_data(survey_file_path:, response_file_path:)
			@survey_file = File.new(survey_file_path)
	    @response_file = File.new(response_file_path)

	    @response_data = process_response_data
	    @survey_data = process_survey_data


	    process_ratings
	    print_participation
			print_ratings

		end

		def submitted_responses
			response_data.select{|x| x[:submitted_at]!=nil }
		end

		def submitted_responses_count
			submitted_responses.length
		end

		def responses_count
			responses.length
		end

		def participated_percentage
			((submitted_responses.length.to_f / responses_count) * 100).round(2)
		end

		def process_survey_data
			CSV.new(survey_file, headers: true, header_converters: :symbol).to_a.map(&:to_hash)
		end

		def process_response_data
			CSV.new(response_file).to_a.map do |row|
				{
					email: row[0],
					employee_id: row[1],
					submitted_at: row[2],
					answers: row[3..-1]
				}
			end
		end

		def responses
			response_data.map do |rp|
	      Response.new(survey: survey_data, **rp)
	    end
		end

		def process_ratings
			questions ||= survey_data.map do |q|
	      Question.new(**q)
	    end

			questions = questions.select{ |q| q.type == "ratingquestion"}
	    @number_of_rating_questions = questions.length

	    question_arr = []
	    questions.each do |q|
	      question_arr << q.text
	    end

	    @question_and_answers = []
	    count = 0

	    questions.each do |x|
	      question_answer = {}
	      answers = []
	      question_answer = {:question => x.text }
	      submitted_responses.each do |sub|
	        answers << sub[:answers][count].to_i
	      end
	      question_answer[:answers] = answers
	      @question_and_answers << question_answer
	      count = count + 1
	    end
		end

		def print_participation
			puts " "
	    puts "Participation Details"
	    puts "---------------------"
	    puts "Participation percentage : #{participated_percentage}"
			puts "Participant count        : #{submitted_responses_count}"
		end

		def print_ratings
			puts " "
	    puts "Rating Questions"
	    puts "----------------"
	    puts ""
	    puts "Average Rating | Question"
	    puts "---------------  -----------------------------"

	    question_and_answers.each do |arr|
	      total_answers = arr[:answers].inject(0, :+)
	      ans = total_answers.to_f / number_of_rating_questions.to_f
	      puts "   #{ans}          #{arr[:question]}"
	    end
		end

	end
end
