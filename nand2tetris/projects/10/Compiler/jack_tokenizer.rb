class JackTokenizer
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def exec
    arr = []
    is_multi_commenting = false
    text.split("\n").each do |line|
      # Strip Comment
      line = line.gsub(/\/\/.*/, '')
      line = line.gsub(/\/\*\*.*\*\//, '')
      line = line.strip()

      # Multi Comment Strip
      if line.include?('/**')
        is_multi_commenting = true
        next
      end

      if line.include?('*/')
        is_multi_commenting = false
        next
      end

      if is_multi_commenting
        next
      end

      # Line tokenizer
      arr.concat(line_tokenizer(line))
    end

    # Flat Array
    arr.flatten!()
  
    # Return
    arr
  end

  private def line_tokenizer(str)
    char_building = ''
    tokens = []

    is_building_string = false
    str.split('').each do |char|
      if (SYMBOL.include?(char))
        tokens.push(char_building) if char_building != ''
        char_building = ''
        tokens.push(char)

      elsif (char == '"' && !is_building_string)
        is_building_string = true
        char_building = char_building + char

      elsif (char == '"' && is_building_string)
        is_building_string = false
        char_building = char_building + char
        tokens.push(char_building)
        char_building = ''

      elsif (char == ' ' && !is_building_string && !char_building.empty?)
        tokens.push(char_building)
        char_building = ''

      elsif (char == ' ' && is_building_string)
        char_building = char_building + char

      elsif (char != ' ')
        char_building = char_building + char

      end
    end

    tokens
  end
end
