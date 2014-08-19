module Codeqa
  module Checkers
    class PatternChecker < Checker
      def check
        sourcefile.content.lines.each.with_index do |line, line_number|
          pos = (line =~ pattern)
          errors.add("#{line_number + 1},#{pos + 1}", error_msg(line, line_number + 1, pos)) if pos
        end
      end

      def self.available?
        respond_to?(:pattern)
      end

    private

      def pattern
        self.class.pattern
      end

      def error_msg(*_args)
        raise 'not implemented'
      end
    end
  end
end

[
  {
    :klass_name => 'CheckPry',
    :name       => 'pry',
    :pattern    => /binding\.pry/,
    :hint       => 'Leftover binding.pry found, please remove it.',
    :type       => ->(f){f.ruby? },
    :msg        => lambda do |_line, line_number, _pos|
      "binding.pry in line #{line_number}"
    end
  },
  {
    :klass_name => 'CheckLinkto',
    :name       => 'link_to',
    :pattern    => /<% link_to.* do.*%>/,
    :hint       => "<% link_to ... do ... %> detected add an '=' after the <%",
    :type       => ->(f){f.erb? },
    :msg        => lambda do |_line, line_number, _pos|
      "old style block link_to in line #{line_number}"
    end
  },
  {
    :klass_name => 'CheckRspecFocus',
    :name       => 'rspec-focus',
    :pattern    => /:focus/,
    :hint       => 'Leftover :focus in spec found, please remove it.',
    :type       => ->(f){f.spec? },
    :msg        => lambda do |_line, line_number, _pos|
      ":focus in line #{line_number}"
    end
  },
  {
    :klass_name => 'CheckStrangeChars',
    :name       => 'strange chars',
    :pattern    => /(\x09|\x0c)/,
    :hint       => 'The file contains a tab or form feed. Remove them.',
    :type       => ->(f){f.text? },
    :msg        => lambda do |line, line_number, pos|
      strangeness = (line.include?("\x09") ? 'TAB x09' : 'FORM FEED x0C')
      "#{strangeness} at line #{line_number} column #{pos + 1}"
    end
  },
  {
    :klass_name => 'CheckConflict',
    :name       => 'conflict',
    :pattern    => /^<<<<<<<|^>>>>>>>|^=======$/m,
    :hint       => 'Remove the lines which are beginning with <<<<<<< or >>>>>>> or =======.',
    :type       => ->(f){f.text? },
    :msg        => lambda do |_line, line_number, _pos|
      "conflict leftovers in line #{line_number}, please merge properly"
    end
  }
].each do |pattern_checker|
  tmp_klass = Class.new(Codeqa::Checkers::PatternChecker) do
    define_singleton_method :check? do |sourcefile|
      pattern_checker[:type][sourcefile]
    end

    define_singleton_method :pattern do
      @pattern ||= pattern_checker[:pattern]
    end

    define_method :name do
      pattern_checker[:name]
    end

    define_method :hint do
      pattern_checker[:hint]
    end

    define_method :error_msg do |*args|
      pattern_checker[:msg][*args]
    end
    private :error_msg
  end
  Codeqa::Checkers.const_set(pattern_checker[:klass_name], tmp_klass)
end
