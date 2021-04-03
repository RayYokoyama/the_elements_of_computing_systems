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
  ]

  EXPRESSION_LIST_STATEMENTS = %w[
    term
    doStatement
  ]

  STATEMENT_BLOCK = %w[
    ifStatement
    whileStatement
    returnStatement
  ]

  UNARY_OP = %w[
    -
    ~
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

    def root_statement
      @blocks.reverse.each do |block|
        return block if (STATEMENT_BLOCK + %w[letStatement doStatement]).include?(block)
      end
    end

    def is_dot?(i)
      @tokens[0..i].reverse.each.with_index do |token, j|
        if token == '('
          return @tokens[0..i].reverse[j + 2] == '.'
        end
      end
    end

    def get_indent
      '  ' * @blocks.size
    end

    def add_block(str, option = '')
      @arr.push("#{get_indent}<#{str}>#{option}")
      @blocks.push(str)
    end

    def pop_block(str, option = '')
      @blocks.pop
      @arr.push("#{get_indent}</#{str}>#{option}")
    end


    @tokens.each.with_index do |token, i|
      # ADD
      # class
      add_block('class') if (token == 'class')
  
      # classVarDec
      add_block('classVarDec') if (current_block == 'class' && CLASS_VAR_DEC_KEYWORDS.include?(token))
  
      # subroutineDec
      add_block('subroutineDec') if (current_block == 'class' && SUBROUTINE_DEC_KEYWORDS.include?(token))
    
      # subroutineBody
      add_block('subroutineBody') if (current_block == 'subroutineDec' && token == '{')
  
      # varDec
      add_block('varDec') if (current_block == 'subroutineBody' && token == 'var')
  
      # statements
      add_block('statements') if (current_block != 'statements' && STATEMENTS.include?(token))
  
      # letStatement
      add_block('letStatement') if (current_block == 'statements' && token == 'let')
  
      # ifStatement
      add_block('ifStatement') if (current_block == 'statements' && token == 'if')
  
      # whileStatement
      add_block('whileStatement') if (current_block == 'statements' && token == 'while')
  
      # doStatement
      add_block('doStatement') if (current_block == 'statements' && token == 'do')

      # ReturnStatement
      add_block('returnStatement') if (current_block == 'statements' && token == 'return')
  
      # term
      add_block('term') if (current_block == 'expression' && !OP.include?(token) && token != ';')

      add_block('term') if (current_block == 'term' && !OP.include?(token) && @tokens[i - 1] == '-')

      # parameterList
      pop_block('parameterList') if (current_block == 'parameterList' && token == ')')

      # Expression List
      pop_block('expressionList') if (current_block == 'expressionList' && token == ')')

      # statements
      pop_block('statements') if (current_block == 'statements' && token === '}')

      if current_block == 'term' && (OP.include?(token) || [')', ']'].include?(token)) && root_statement == 'ifStatement'
        pop_block('term')
      end

      if current_block == 'term' && [']', ';'].include?(token) && root_statement == 'letStatement'
        pop_block('term')
      end

      if current_block == 'term' && [')'].include?(token) && root_statement == 'letStatement' && !is_dot?(i)
        pop_block('term')
      end

      if current_block == 'term' && token == ')' && !is_dot?(i)
        pop_block('term')
      end

      if current_block == 'term' && OP.include?(token) && @tokens[i - 1] != '('
        pop_block('term')
      end

      # term
      add_block('term') if (current_block == 'expression' && UNARY_OP.include?(token) && @tokens[i - 1] == '(')

      # expression
      pop_block('expression') if (current_block == 'expression' && [')',']'].include?(token))

      # expression
      pop_block('expression') if (current_block == 'expression' && token == ';' && root_statement == 'letStatement')

      @arr.push execT(token)

      # Expression List
      if EXPRESSION_LIST_STATEMENTS.include?(current_block) && token == '('
        if @tokens[i - 2] == '.'
          add_block('expressionList')
        else
          add_block('expression')
        end
      end

      # expression
      add_block('expression') if (STATEMENT_BLOCK.include?(current_block) && token =='(')
      if (current_block == 'letStatement' && ['[', '='].include?(token))
        add_block('expression')
      elsif (current_block == 'term' && root_statement == 'letStatement' && token == '[')
        add_block('expression')
      end

      # parameterList
      add_block('parameterList') if (current_block == 'subroutineDec' && token == '(')

      # POP
      # class
      pop_block('class') if (current_block == 'class' && token == '}')

      # subroutineBody
      pop_block('subroutineBody') if (current_block == 'subroutineBody' && token == '}')

      # subroutineDec
      pop_block('subroutineDec') if (current_block == 'subroutineDec' && token == '}')

      # classVarDec
      pop_block('classVarDec') if (current_block == 'classVarDec' && token == ';')

      # varDec
      pop_block('varDec') if (current_block == 'varDec' && token == ';')

      # letStatement
      pop_block('letStatement') if (current_block == 'letStatement' && token == ';')

      # ifStatement
      if (current_block == 'ifStatement' && token == '}' && @tokens[i + 1] != 'else')
        pop_block('ifStatement')
      end

      # whileStatement
      pop_block('whileStatement') if (current_block == 'whileStatement' && token == '}')

      # doStatement
      pop_block('doStatement') if (current_block == 'doStatement' && token == ';')

      # ReturnStatement
      pop_block('returnStatement') if (current_block == 'returnStatement' && token == ';')

      if current_block == 'term' && [')', ']'].include?(token)
        pop_block('term')
      end

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
    elsif str.include?('"') || str.include?("\n")
      'STRING_CONST'
    elsif /^[^0-9][A-Za-z0-9_]+/ =~ str || (str.length == 1 && /[A-Za-z]/ =~ str)
      'IDENTIFIER'
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
