module Codeqa
  class CheckErrors
    def initialize
      @details = []
    end

    attr_reader :details

    def add(place, message)
      @details << [place, message]
    end

    def success?
      @details.empty?
    end

    def errors?
      !success?
    end
  end
end
