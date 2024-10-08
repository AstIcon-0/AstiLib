module AstiLib

  # # File Data
  # -----------
  # This module contains methods for manipulating files.
  # Including saving variables to and loading from them.
  module FileData

    # Saves a variable to a file.
    # Creates the file if it doesn't exist as long as the folder it is in does.
    # 
    # @param [Any] variable_name The key at which you store the value.
    # @param [Any] variable_value The value of the variable.
    # @param [String] filename The file you want to save the variable to.
    # @param [Boolean] use_compression Any variable that is saved using compression must be loaded using compression.
    # @return [Nil]
    def self.save_var_to_file(variable_name, variable_value, filename, use_compression = false)
      if variable_name.nil?
        raise ArgumentError, "Error: 'variable_name' is nil. Please provide a valid variable name."
      elsif variable_value.nil?
        raise ArgumentError, "Error: 'variable_value' is nil. Please provide a valid variable value."
      end
    
      if File.exist?(filename) && !File.zero?(filename)
        data = load_all_vars_from_file(filename, use_compression) || {}
      else
        data = {}
      end
      data[variable_name] = variable_value
      File.open(filename, 'wb') do |file|
        serialized_data = Marshal.dump(data)
        if use_compression
          file.write(Zlib::Deflate.deflate(serialized_data))
        else
          file.write(serialized_data)
        end
      end
    rescue => e
      msgbox("Failed to save variable to file: #{e.message}")
    end
    
    # Load a single variable from a file.
    # 
    # @param [Any] variable_name The key you want to load the variable from.
    # @param [String] filename The file you want to load the variable from.
    # @param [Boolean] use_compression Can only be used on files that are saved with compression.
    # @return [Any] The variable value.
    def self.load_var_from_file(variable_name, filename, use_compression = false)
      data = load_all_vars_from_file(filename, use_compression)
      return data[variable_name] if data && data.key?(variable_name)
      return nil
    end
    
    # Load all variables from a file
    # 
    # @param [String] filename The file you want to load the variables from.
    # @param [Boolean] use_compression Can only be used on files that are saved with compression.
    # @return [Hash] A hashing containing the variable names with their values.
    def self.load_all_vars_from_file(filename, use_compression = false)
      return {} unless File.exist?(filename) && !File.zero?(filename)
      File.open(filename, 'rb') do |file|
        file_data = file.read
        if use_compression
          decompressed_data = Zlib::Inflate.inflate(file_data)
          return Marshal.load(decompressed_data)
        else
          return Marshal.load(file_data)
        end
      end
    end

    # Read a file as plain text.
    # 
    # @param [String] filename The file you want to read from.
    # @return [String] The text from the file.
    def self.read_text_file(filename)
      return nil unless File.exist?(filename) && !File.zero?(filename)
      content = File.read(filename)
      return nil if content.empty?
      return content
    end

    # Write plain text to a file.
    # 
    # @param [String] filename The file you want to write to.
    # @param [String] content What you want to write to the file.
    # @return [Nil]
    def self.write_text_file(filename, content)
      File.open(filename, 'a') do |file|
        file.puts(content)
      end
    rescue => e
      msgbox("Failed to write to file: #{e.message}")
    end

    # Empty a file.
    # 
    # @param [String] filename The file you want to clear.
    # @return [Nil]
    def self.clear_file(filename)
      File.open(filename, 'w') {}
    rescue => e
      msgbox("Failed to clear file: #{e.message}")
    end
  end
end