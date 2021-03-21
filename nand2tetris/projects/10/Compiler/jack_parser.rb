class JackParser
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
  
  def initialize(tokens)
    @tokens = tokens
  end

  def exec
    blocks = ['class', 'classVarDec']

    # Loop Token
    @tokens.each do |token|
      if(token == 'class')
        blocks.push('class')
      end
    end

    # Parse Class
  end

  def execT
    arr = ['<tokens>']
    # Loop Token
    @tokens.each do |token|
      p token if token_type(token).nil? 

      case token_type(token)
      when 'KEYWORD'
        arr.push("<keyword> #{token} </keyword>")
      when 'SYMBOL'
        arr.push("<symbol> #{token} </symbol>")
      when 'INT_CONST'
        arr.push("<integerConstant> #{token} </integerConstant>")
      when 'IDENTIFIER'
        arr.push("<identifier> #{token} </identifier>")
      when 'STRING_CONST'
        token = token.gsub(/\"/, '')
        arr.push("<stringConstant> #{token} </stringConstant>")
      end
    end

    # Join Array :)
    arr.push('</tokens>')
    arr.join("\n")
  end

  private def token_type(str)
    if KEYWORD.include?(str)
      'KEYWORD'
    elsif SYMBOL.include?(str)
      'SYMBOL'
    elsif str.to_i.to_s == str && str.to_i <= 32_767 && str.to_i >= 0
      'INT_CONST'
    elsif /^[^0-9][A-Za-z0-9_]+/ =~ str || (str.length == 1 && /[A-Za-z]/ =~ str)
      'IDENTIFIER'
    elsif str.include?('"') || str.include?("\n")
      'STRING_CONST'
    end
  end
end