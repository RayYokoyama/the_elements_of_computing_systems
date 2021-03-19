class JackAnalyzer
  attr_reader :file_name_without_ext, :file_name

  def initialize(file_name)
    @file_name = file_name
    @file_name_without_ext = File.basename(directory_path)
  end

  def exec
    File.open("#{file_name_without_ext}.xml", 'w') do |w|
      File.open(file_name, 'r') do |str|
        jt = JackTokenizer.new(str)
        token =
          case jt.token_type
          when 'KEYWORD'
            j.keyword
          end
        w.write CompilationEngine.new(token).compile
      end
    end
  end
end

JackAnalyzer.new(ARGV[0]).exec
