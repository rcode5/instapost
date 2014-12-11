require 'sass'

class Color < Sass::Script::Color
  extend Sass::Script::Functions
  def options
    {}
  end
  def self.assert_type(*args)
    Sass::Script::Functions::EvaluationContext.new({}).assert_type *args
  end
end
