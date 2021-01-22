# frozen_string_literal: true

class Translator
  include Paser
  include CodeWiter

end

t = Translator.new
t.exec
