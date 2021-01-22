class Parser
  def initialize(command)
    @command = command.strip()
  end

  attr_accessor :command

  def command_type
    command = @command.split(' ').first
    case command
    when 'push'
      'C_PUSH'
    when 'pop'
      'C_POP'
    when 'label'
      'C_LABEL'
    when 'goto'
      'C_GOTO'
    when 'if-goto'
      'C_IF'
    when 'function'
      'C_FUNCTION'
    when 'return'
      'C_RETURN'
    when 'call'
      'C_CALL'
    else
      'C_ARITHMETIC'
    end
  end

  def arg1
    if command_type == "C_RETURN" 
      return 
    elsif command_type == "C_ARITHMETIC"
      return @command
    else
      return @command.split(' ')[1]
    end
  end

  def arg2
    return unless %w(C_PUSH C_POP C_FUNCTION C_CALL).include?(command_type)

    @command.split(' ')[2]
  end
end
