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
  
  SUBROUTINE_DEC_KEYWORDS = %w[
    method
    function
    constructor
  ].freeze

  STATEMENTS = %w[
    let
    do
    if
    while
    return
    else
  ]

  STATEMENT_BLOCK = %w[
    ifStatement
    whileStatement
    returnStatement
  ]

  OP = %w[
    +
    -
    *
    /
    &
    |
    <
    >
    =
    -
    ~
  ]

  def initialize(tokens)
    @tokens = tokens
  end

  def exec
    @blocks = []
    @arr = []

    def current_block
      @blocks.last
    end

    def get_indent
      '  ' * @blocks.size
    end

    def add_block(str)
      @arr.push("#{get_indent}<#{str}>")
      @blocks.push(str)
    end

    def pop_block(str)
      @blocks.pop
      @arr.push("#{get_indent}</#{str}>")
    end


    @tokens.each do |token|
      # ADD
      # class
      add_block('class') if (token == 'class')
  
      # classVarDec
      add_block('classVarDec') if (current_block == 'class' && CLASS_VAR_DEC_KEYWORDS.include?(token))
  
      # subroutineDec
      add_block('subroutineDec') if (current_block == 'class' && SUBROUTINE_DEC_KEYWORDS.include?(token))
  
      # parameterList
      add_block('parameterList') if (current_block == 'subroutineDec' && token == '(')
    
      # subroutineBody
      add_block('subroutineBody') if (current_block == 'subroutineDec' && token == '{')
  
      # varDec
      add_block('varDec') if (current_block == 'subroutineBody' && token == 'var')
  
      # statements
      add_block('statements') if (current_block != 'statements' && STATEMENTS.include?(token))
  
      # letStatement
      add_block('letStatement') if (current_block != 'statements' && token == 'let')
  
      # ifStatement
      add_block('ifStatement') if (current_block == 'statements' && token == 'if')
  
      # whileStatement
      add_block('whileStatement') if (current_block == 'statements' && token == 'while')
  
      # doStatement
      add_block('doStatement') if (current_block == 'statements' && token == 'do')
      add_block('expressionList') if (current_block == 'doStatement' && token =='(')

      # ReturnStatement
      add_block('returnStatement') if (current_block == 'statements' && token == 'return')

      # expression
      add_block('expression') if (STATEMENT_BLOCK.include?(current_block) && token =='(')
      add_block('expression') if (current_block == 'letStatement' && token == '[')
  
      # term
      add_block('term') if (current_block == 'expression' && !OP.include?(token))

      @arr.push execT(token)

      # POP
      # subroutineBody
      pop_block('subroutineBody') if (current_block == 'subroutineBody' && token == '}')
      # parameterList
      pop_block('parameterList') if (current_block == 'parameterList' && token == ')')

      # subroutineDec
      pop_block('subroutineDec') if (current_block == 'subroutineDec' && token == '}')

      # classVarDec
      pop_block('classVarDec') if (current_block == 'classVarDec' && token == ';') 

      # class
      pop_block('class') if (current_block == 'class' && token == '}')

      # varDec
      pop_block('varDec') if (current_block == 'varDec' && token == ';')
  
      # statements
      pop_block('statements') if (current_block == 'statements' && token === '}')
  
      # letStatement
      pop_block('letStatement') if (current_block == 'letStatement' && token == ';')
  
      # ifStatement
      pop_block('ifStatement') if (current_block == 'ifStatement' && token == '}')
  
  
      # whileStatement
      pop_block('whileStatement') if (current_block == 'whileStatement' && token == '}')
  
      # doStatement
      pop_block('expressionList') if (current_block == 'expressionList' && token ==';')
      pop_block('doStatement') if (current_block == 'doStatement' && token == ';')
  
      # ReturnStatement
      pop_block('returnStatement') if (current_block == 'returnStatement' && token == ';')

      pop_block('term') if (current_block == 'term' && !OP.include?(token))
      
      # expression
      pop_block('expression') if (current_block == 'expression' && [')',']'].include?(token))
    end

    # Join @Array :)
    @arr.join("\n")
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
        token = token.gsub(/\"/, '')
        "<stringConstant> #{token} </stringConstant>"
      end
        
      begin
        '  '*@blocks.size + str
      rescue => exception
        p str
        p token
      end
    
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
