class JackTokenizer

  KEYWORD = %w[
    class
    constructor
    function
    method
    field
    static
    var
    int
    char
    boolean
    void
    true
    false
    null
    this
    let
    do
    if
    else
    while
    return
  ].freeze

  SYMBOL = %w[{ } () [ ] .  , ; + - * / & | < > = ~].freeze

  attr_reader :str

  def initialize(str)
    @str = str
  end

  def token_type
    if KEYWORD.include?(str)
      'KEYWORD'
    elsif SYMBOL.include?(str)
      'SYMBOL'
    elsif str.to_i.to_s == str && str.to_i <= 32_767 && str.to_i >= 0
      'INT_CONST'
    elsif /^[^0-9][A-Za-z0-9_]+/ =~ str
      'IDENTIFIER'
    elsif str.include?('"') || str.include?("\n")
      'STRING_CONST'
    end
  end
end
