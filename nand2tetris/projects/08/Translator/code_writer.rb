module CodeWriter
  # Opens the output file/stream and gets ready to write into it
  # def initialize()
  # end

  # Informs the code writer that the translation of a new VM file is started
  # PARAMETER fileName(string)
  # RETURN void
  def set_sp
    [
      '@256', # A = 256
      'D=A',  # D = A = 256
      '@SP',  # A = 0
      'M=D'   # M[0] = 256
    ]
  end

  def set_local
    [
      '@300',
      'D=A',
      '@LCL',
      'M=D'
    ]
  end

  def set_arg
    [
      '@400',
      'D=A',
      '@ARG',
      'M=D'
    ]
  end

  def set_this
    [
      '@3000',
      'D=A',
      '@THIS',
      'M=D'
    ]
  end

  def set_that
    [
      '@3010',
      'D=A',
      '@THAT',
      'M=D'
    ]
  end

  # Writes the assembly code that is the translation of the given arithmetic command
  # PARAMETER command(string)
  # RETURN void
  def writeArithmetic(command)
    assembly_builder = []
    # Add
    if command == 'add'
      assembly_builder.push(
        '@SP',# A=0
        'AM=M-1',# A=RAM[0]=M[0]-1
        'D=M',# D=RAM[257]
        'A=A-1',# A=257-1=256
        'M=M+D'# RAM[256]=RAM[256]+D
      )

    elsif command == 'sub'
      assembly_builder.push(
        '@SP',
        'AM=M-1',
        'D=M',
        'A=A-1',
        'M=M-D'
      )

    # y = -y
    elsif command == 'neg'
      assembly_builder.push(
        '@SP',
        'A=M-1',
        'M=-M',
      )

    # x == y ? -1 : 0
    elsif command == 'eq'
      assembly_builder.push(
        '@SP',
        'AM=M-1', # M = 257
        'D=M', # D = 4
        'A=A-1', # @256
        'D=M-D', # D = 5 - 4 = 1
        'M=-1',  # M[256] = -1
        '@EQEND', # if D == 0 → EQEND
        'D;JEQ', #
        '@SP',
        'A=M-1',
        'M=0',
        '(EQEND)'
      )

    # x > y ? -1 : 0
    elsif command == 'gt'
      assembly_builder.push(
        '@SP',
        'AM=M-1', # M = 257
        'D=M', # D = 4
        'A=A-1', # @256
        'D=M-D', # D = 5 - 4 = 1
        'M=-1',  # M[256] = -1
        '@GTEND', # if D == 0 → EQEND
        'D;JGT', #
        '@SP',
        'A=M-1',
        'M=0',
        '(GTEND)'
      )
    # x < y ? -1 : 0
    elsif command == 'lt'
      assembly_builder.push(
        '@SP',
        'AM=M-1', # M = 257
        'D=M', # D = 4
        'A=A-1', # @256
        'D=M-D', # D = 5 - 4 = 1
        'M=-1',  # M[256] = -1
        '@LTEND', # if D == 0 → EQEND
        'D;JLT', #
        '@SP',
        'A=M-1',
        'M=0',
        '(LTEND)'
      )
    # x & y
    elsif command == 'and'
      assembly_builder.push(
        '@SP',
        'AM=M-1', # M = 257
        'D=M', # D = 4
        'A=A-1', # @256
        'M=D&M'
      )
    # x | y
    elsif command == 'or'
      assembly_builder.push(
        '@SP',
        'AM=M-1', # M = 257
        'D=M', # D = 4
        'A=A-1', # @256
        'M=D|M'
      )
    # not y
    elsif command == 'not'
      assembly_builder.push(
        '@SP',
        'A=M-1', # M = 257
        'M=!M'
      )
    end
    return assembly_builder
  end

  def writeLabel(label)
    ["(#{label})"]
  end

  def writeGoTo(label)
    [
      "@#{label}",
      "0;JMP"
    ]
  end

  def writeIf(label)
    [
      "@SP",
      "AM=M-1",
      "D=M",
      "@#{label}",
      "D;JNE"
    ]
  end

  # Writes the assembly code that is the translation of the given command , where
  # command is either C_PUSH or C_POP
  # PARAMETER command(C_PUSH or C_POP), segment(string), index(int)
  # RETURN void
  def writePushPop(command, segment, index)
    assembly_builder = []
    # Push
    if command == 'C_PUSH'
      if segment == 'constant'
        assembly_builder.push(
          "@#{index}",
          'D=A',
          '@SP',
          'A=M',
          'M=D',
          '@SP',
          'M=M+1'
        )
      elsif segment == 'temp'
        assembly_builder.push(
          "@#{5 + index.to_i}", # A = 10
          'D=M',           # D = M[10]
          '@SP',           # A = 0
          'A=M',           # A = M[0] = 258
          'M=D',           # M[258] = D
          '@SP',           # A = 0
          'M=M+1'          # M[0] = 258 + 1
        )
      elsif segment == 'pointer'
        assembly_builder.push(
          "@#{3 + index.to_i}", # A = 10
          'D=M',           # D = M[10]
          '@SP',           # A = 0
          'A=M',           # A = M[0] = 258
          'M=D',           # M[258] = D
          '@SP',           # A = 0
          'M=M+1'          # M[0] = 258 + 1
        )
      elsif segment == 'static'
        assembly_builder.push(
          "@#{file_name_without_ext}.#{index}", # A = 10
          'D=M',           # D = M[10]
          '@SP',           # A = 0
          'A=M',           # A = M[0] = 258
          'M=D',           # M[258] = D
          '@SP',           # A = 0
          'M=M+1'          # M[0] = 258 + 1
        )
      else
        segment_symbol = case segment
        when 'local'
          'LCL'
        when 'argument'
          'ARG'
        when 'this'
          'THIS'
        when 'that'
          'THAT'
        end

        assembly_builder.push(
          "@#{index}",
          'D=A',
          "@#{segment_symbol}", # A = THAT = 4
          'A=M',
          'A=A+D', # A = 3010 + 5
          'D=M', # D = M[3015]
          '@SP', # A = 0
          'A=M', # A = M[0] = 257
          'M=D', # M[257] = D = M[3015]
          '@SP', # A = 0
          'M=M+1' # M[0] = 257 + 1
        )
      end
    # Pop
    elsif command == 'C_POP'
      if segment == 'temp'
        assembly_builder.push(
          '@SP', # A = 0
          'AM=M-1', # A = M[0] - 1, M[0] = M[0] - 1
          'D=M', # D = M[257]
          "@#{5 + index.to_i}", # A = 5 + index
          'M=D'
        )
      elsif segment == 'pointer'
        assembly_builder.push(
          '@SP', # A = 0
          'AM=M-1', # A = M[0] - 1, M[0] = M[0] - 1
          'D=M', # D = M[257]
          "@#{3 + index.to_i}", # A = 5 + index
          'M=D'
        )
      elsif segment == 'static'
        assembly_builder.push(
          '@SP', # A = 0
          'AM=M-1', # A = M[0] - 1, M[0] = M[0] - 1
          'D=M', # D = M[257]
          "@#{file_name_without_ext}.#{index}", # A = 6 + index
          'M=D'
        )
      else
        segment_symbol = case segment
          when 'local'
            'LCL'
          when 'argument'
            'ARG'
          when 'this'
            'THIS'
          when 'that'
            'THAT'
          end

          assembly_builder.push(
            # RAM[RAM[SP]] -> RAM[RAM[segment]]
            "@#{index}",          # A = 3
            'D=A',                # D = 3
            "@#{segment_symbol}", # A = 1
            'D=M+D',              # D = M[1] + 3 = 300 + 3
            'M=D',                # M[1] = 303
            '@SP',                # A = 0
            'AM=M-1',             # A = M[0] - 1 = 258 -1
            'D=M',                # D = M[257]
            "@#{segment_symbol}", # A = 1
            'A=M',                # A = M[1] = 303
            'M=D',                # M[303] = M[257]
            "@#{index}",          # A = 3
            'D=A',                # D = 3
            "@#{segment_symbol}", # A = 1
            'M=M-D'               # M[1] = M[1] - 3 = 303 - 3
          )
      end
    end

    return assembly_builder
  end

  def writeCall(function_name, num_args)
    assembly_builder = []
    assembly_builder.push(
      
    )

    return assembly_builder

    # push return-address
    # push LCL
    # push ARG
    # push THIS
    # push THAT
    # ARG = SP-n-5
    # LCL = SP
    # got f
    # (return address)
  end

  def writeFunction(function_name, num_locals)
    assembly_builder = []
    assembly_builder.push(
      "(#{function_name})", # Declare a label for the function entry
    )

    num_locals.to_i.times do |i|
      puts i
      assembly_builder.concat writePushPop('C_PUSH', 'argument', i)
    end

    # function f k
    # (f)
    # repeat k times
    # push 0
    return assembly_builder
  end

  def writeReturn
    assembly_builder = []

    # Exp
    # M[300] = 258

    # FRAME = LCL
    assembly_builder.push(
      '@LCL',          # A = 1
      'A=M',           # A = 300 
      'D=M',           # D = M[300]
      '@6',            # A = 6
      'M=D'            # M[6] = 258
    )

    # RET = *(FRAME - 5)
    assembly_builder.push(
      '@6',            # A = 1
      'D=M-1',         # D = M[300] - 5
      'D=D-1',         # D = M[300] - 5
      'D=D-1',         # D = M[300] - 5
      'D=D-1',         # D = M[300] - 5
      'D=D-1',         # D = M[300] - 5
      '@7',             # A = 7
      'M=D'            # M[7] = 253
    )

    # *ARG = pop()
    assembly_builder.concat(
      writePushPop('C_POP', 'argument', 0)
    )

    # SP = ARG + 1
    assembly_builder.push(
      '@ARG',    # A=ARG,
      'D=M+1',  # D=M[ARG] + 1
      '@SP',    # A=0
      'M=D'     # M[0]=D 
    )

    # THAT = *(FRAME-1)
    assembly_builder.push(
      '@6',      # A=6,
      'D=M-1',  # D=M[6] - 1
      '@THAT',  # A=0
      'M=D'     # M[0]=D 
    )
    # THIS = *(FRAME - 2)
    assembly_builder.push(
      '@THAT',     # A=THAT,
      'D=M-1',    # D=M[THAT] - 1
      '@THIS',    # A=THIS
      'M=D'       # M[THIS]=D 
    )

    # ARG = *(FRAME - 3)
    assembly_builder.push(
      '@THIS',     # A=THIS,
      'D=M-1',    # D=M[THIS] - 1
      '@ARG',     # A=ARG
      'M=D'       # M[ARG]=D 
    )

    # LCL = *(FRAME - 4)
    assembly_builder.push(
      '@ARG',     # A=ARG,
      'D=M-1',    # D=M[ARG] - 1
      '@LCL',    # A=LCL
      'M=D'       # M[LCL]=D 
    )
    
    # goto RET
    assembly_builder.push(
      '@LCL',
      'D=M-1',
      'A=D',
      '0;JMP'
    )

    return assembly_builder
  end

  # Closes the output file
  # PARAMETER void
  # RETURN void
  def Close
  end
end
