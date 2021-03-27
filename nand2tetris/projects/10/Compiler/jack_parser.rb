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

  CLASS_VAR_DEC_KEYWORDS = %w[
    field
    static
  ].freeze
  
  SUBROUTIN_DEC_KEYWORDS = %w[
    method
    function
    constructor
  ].freeze

  def initialize(tokens)
    @tokens = tokens
  end

  def exec
    @blocks = []
    arr = ['<class>']

    @tokens.each do |token|
      @blocks.push token if ['class', 'field'].include?(token)
      execT(token, @blocks.size)
    end

    # Join Array :)
    arr.push('</class>')
    arr.join("\n")
  end

  def execT(token)
    str =
      case token_type(token)
      when 'KEYWORD'
        "<keyword> #{token} </keyword>"
      when 'SYMBOL'
        "<symbol> #{token} </symbol>"
      when 'INT_CONST'
        "<integerConstant> #{token} </integerConstant>"
      when 'IDENTIFIER'
        "<identifier> #{token} </identifier>"
      when 'STRING_CONST'
        token = token.gsub(/\"/, ''
        "<stringConstant> #{token} </stringConstant>"
      end

    '  '*@blocks.size + str
  end

  private

  def token_type(str)
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

  def compile_keyword(str)
    case str
    when 'class'
      '<keyword>class</keyword>'
    when 'method'
      'METHOD'
    when 'function'
      'FUNCTION'
    when 'constructor'
      'CONSTRUCTOR'
    when 'int'
      'INT'
    when 'boolean'
      'BOOLEAN'
    when 'char'
      'CHAR'
    when 'void'
      'VOID'
    when 'var'
      'VAR'
    when 'static'
      'STATIC'
    when 'field'
      'FIELD'
    when 'let'
      'LET'
    when 'do'
      'DO'
    when 'if'
      'IF'
    when 'else'
      'ELSE'
    when 'while'
      'WHILE'
    when 'return'
      'RETURN'
    when 'true'
      'TRUE'
    when 'false'
      'FALSE'
    when 'null'
      'NULL'
    when 'this'
      'THIS'
    end
  end

  def compile_class(class_name)
    arr = [
      'class',
      class_name,
      '{'
    ]

    arr.concat class_var_dec
    arr.concat subroutin_dec
    arr.push '}'

    arr
  end

  def class_var_dec()
  end

  def subroutin_dec()

  end
end
