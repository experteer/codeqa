module Codeqa
  class OffenseCollector
    attr_accessor :offenses
    def initialize
      @offenses = []
    end
    %i(warn error info convention).each do |severity|
      define_method(severity) do |location, message, checker_name|
        offenses << Offense.new(severity, location, message, checker_name)
      end
    end
  end
end
