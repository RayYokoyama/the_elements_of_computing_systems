require './parser'
require './code_writer'

class Translator
  include CodeWriter

  attr_reader :file_name_without_ext
  def initialize(directory_path)
    @directory_path = directory_path
    @file_name_without_ext = File.basename(directory_path)
  end

  def execute
    File.open("#{@file_name_without_ext}.asm", 'w') do |w|
      w.write set_sp.join("\n")
      w.write "\n"
      w.write writeCall('Sys.init', 0).join("\n")
      w.write "\n"
      # w.write set_local.join("\n")
      # w.write "\n"
      # w.write set_arg.join("\n")
      # w.write "\n"
      # w.write set_this.join("\n")
      # w.write "\n"
      # w.write set_that.join("\n")
      # w.write "\n"
      Dir.each_child(@directory_path) do |file|
        if file.split('.')[-1] == 'vm'
          File.open(@directory_path + file, 'r') do |f|
            f.each_line do |line|
              formated_line = delete_comment_out(line) ## //**** を消す
              next if formated_line.empty?

              p = Parser.new(formated_line)
              puts p.command_type
              if p.command_type == 'C_ARITHMETIC'
                w.write writeArithmetic(p.arg1).join("\n")
                w.write "\n"
              elsif p.command_type == 'C_LABEL'
                w.write writeLabel(p.arg1).join("\n")
                w.write "\n"
              elsif p.command_type == 'C_GOTO'
                w.write writeGoTo(p.arg1).join("\n")
                w.write "\n"
              elsif p.command_type == 'C_IF'
                w.write writeIf(p.arg1).join("\n")
                w.write "\n"
              elsif %w[C_PUSH C_POP].include?(p.command_type)
                w.write writePushPop(p.command_type, p.arg1, p.arg2).join("\n")
                w.write "\n"
              elsif p.command_type == 'C_FUNCTION'
                w.write writeFunction(p.arg1, p.arg2).join("\n")
                w.write "\n"
              elsif p.command_type == 'C_RETURN'
                w.write writeReturn().join("\n")
                w.write "\n"
              elsif p.command_type == 'C_CALL'
                w.write writeCall(p.arg1, p.arg2).join("\n")
                w.write "\n"
              end
            end
          end
        end
      end
    end
  end

  def delete_comment_out(line)
    line.gsub(/\/\/.*/, '').strip()
  end
end

t = Translator.new(ARGV[0])
t.execute
