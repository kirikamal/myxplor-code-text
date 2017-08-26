module Myxplor
  class Response

    attr_accessor :survey, :email, :employee_id, :submitted_at, :answers

    def initialize(survey:, email:, employee_id:, submitted_at:, answers:)
      @survey = survey
      @email = email
      @employee_id = employee_id
      submitted_at = submitted_at
      @answers = answers
    end

  end
end
