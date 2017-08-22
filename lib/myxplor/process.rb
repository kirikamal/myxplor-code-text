
require 'csv'

module Myxplor
	class Process

		attr_accessor :survey_file, :response_file

		def initialize(survey_file, response_file)
			@survey_file = survey_file
			@response_file = response_file	
		end

		def process_survey_data
			CVS.new(survey_file, headers: true, header_converters: :symbol).to_a.map(&:to_hash)
		end

		def process_response_data
			CSV.new(response_file).to_a.map do |row|
				{
					email: row[0],
					employee_id: row[1]
					submitted_id: row[2],
					answers: row[3]
				}
			end
		end

		def number_of_submission
			
		end
	end
end