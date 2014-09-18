module Codeqa
  class Offense
    attr_reader :location
    attr_reader :severity
    attr_reader :message
    attr_reader :checker_name
    def initialize(severity, location, message, checker_name)
      @severity = severity
      @location = location
      @message = message.freeze
      @checker_name = checker_name.freeze
      freeze
    end
  end
end
