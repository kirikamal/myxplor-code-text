module Myxplor
  module Models
    class Response

      attr_accessor :survey, :email, :employee_id, :submitted_at, :answers

      def initialize(survey, email, employee_id, submitted_at, asnwers)
        @survey = survey
        @email = email
        @employee_id = employee_id
        submitted_at = submitted_at
        @answers = answers
      end

      def is_submitted?
        !submitted_at.nil?
      end

    end
  end
end
