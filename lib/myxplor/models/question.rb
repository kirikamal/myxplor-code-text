module Myxplor
  class Question

    attr_accessor :theme, :type, :text

    def initialize(theme:, type:, text:)
      @theme = theme
      @type = type
      @text = text
    end

  end
end
