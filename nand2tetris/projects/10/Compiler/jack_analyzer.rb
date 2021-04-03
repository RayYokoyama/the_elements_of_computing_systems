require './jack_tokenizer.rb'
require './jack_parser.rb'
SYMBOL = %w[{ } ( ) [ ] .  , ; + - * / & | < > = ~].freeze

class JackAnalyzer  
  attr_reader :file_name_without_ext, :file_name

  def initialize(file_name)
    @file_name = file_name
    @file_name_without_ext = File.basename(file_name, '.*')
  end

  def exec
    File.open("#{file_name_without_ext}.xml", 'w') do |w|
      File.open(file_name, 'r') do |file|
        jt = JackTokenizer.new(file.read)
        tokens = jt.exec

        jp = JackParser.new(tokens)
        xml = jp.exec
        
        w.write(xml)
        w.write("\n")
      end
    end
  end
end

JackAnalyzer.new(ARGV[0]).exec
