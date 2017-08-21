module Myxplor
  module Models
    class Survey
      attr_accessor :questions_data

      def initialize(questions_data)
        @questions_data = questions_data
      end
    end
  end
end
