require 'spec_helper'
require_relative "../../lib/myxplor/processor"

RSpec.describe Myxplor::Processor do
  let(:survey_file) { File.new('sample-data/survey-1.cvs') }
  let(:response_file) { File.new('sample-data/survey-1-responses.csv') }

  it(:process_survey_data) do
    is_expected.to eq(
      [
        {
          theme: 'The Work',
          type:  'ratingquestion',
          text:  'I like the kind of work I do.'
        },
        {
          theme: 'The Work',
          type:  'ratingquestion',
          text:  'In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.'
        },
        {
          theme: 'The Work',
          type:  'ratingquestion',
          text:  'We are working at the right pace to meet our goals.'
        },
        {
          theme: 'The Place',
          type:  'ratingquestion',
          text:  'I feel empowered to get the work done for which I am responsible.'
        },
        {
          theme: 'The Place',
          type:  'ratingquestion',
          text:  'I am appropriately involved in decisions that affect my work.'
        }
      ]
    )
  end

  it(:process_response_data) do
    is_expected.to eq(
      [
        {
          email:        'employee1@abc.xyz',
          employee_id:  '1',
          submitted_at: '2014-07-28T20:35:41+00:00',
          answers:      ['5', '5', '5', '4', '4']
        },
        {
          email:        nil,
          employee_id:  '2',
          submitted_at: '2014-07-29T07:05:41+00:00',
          answers:      ['4', '5', '5', '3', '3']
        },
        {
          email:        nil,
          employee_id:  '3',
          submitted_at: '2014-07-29T17:35:41+00:00',
          answers:      ['5', '5', '5', '5', '4']
        },
        {
          email:        'employee4@abc.xyz',
          employee_id:  '4',
          submitted_at: '2014-07-30T04:05:41+00:00',
          answers:      ['5', '5', '5', '4', '4']
        },
        {
          email:        nil,
          employee_id:  '5',
          submitted_at: '2014-07-31T11:35:41+00:00',
          answers:      ['4', '5', '5', '2', '3']
        },
        {
          email:        'employee5@abc.xyz',
          employee_id:  '6',
          submitted_at: nil,
          answers:      [nil, nil, nil, nil, nil]
        }
      ]
    )
  end
end
