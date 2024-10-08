module Language
  @translations = {}
  @current_language = "English"  # Default language

  def self.translations
    return @translations
  end

  def self.languages
    language_list = []
    @translations[AstiLib::LANGUAGE_FILE].keys.each do |language|
      next if language == :fallback
      language_list << language
    end
    return language_list
  end

  def self.language_names
    language_list = []
    @translations[AstiLib::LANGUAGE_FILE].each do |language, translation_texts|
      next if language == :fallback
      language_list << translation_texts[:language]
    end
    return language_list
  end

  # Set the current language
  def self.set_language(lang)
    @current_language = lang.capitalize
  end

  # Escape RPG Maker control characters
  def self.escape_control_characters(text)
    text.gsub(/(\\[V|N|P|G|C|I|{|}|$|\.|\||!|>|<|\^|\\])/, '\\\\\1')
  end

  # Parse a language file and load translations
  def self.parse_file(file_path)
    return unless File.exist?(file_path)

    content = File.read(file_path)
    lines = content.split(/\r?\n/)

    current_lang = nil
    fallback_lang = nil
    translations = {}
    in_hash = false
    hash_content = ""

    lines.each do |line|
      next if line.strip.start_with?("#")

      # Check for language section headers
      if line.strip =~ /^\[(.+?)\]$/
        if in_hash
          # Process the previous hash if we were inside one
          begin
            escaped_hash_content = escape_control_characters(hash_content)
            translations[current_lang] = eval("{#{escaped_hash_content}}")
          rescue SyntaxError => e
            puts "Error evaluating hash content for language '#{current_lang}': #{e.message}"
          end
          in_hash = false
        end
        current_lang = $1.capitalize
        fallback_lang ||= current_lang
        translations[current_lang] ||= {}
        next
      end

      # Detect the start of a hash block
      if line.strip == '{'
        in_hash = true
        hash_content = ""
        next
      elsif line.strip == '}'
        # End of a hash block
        begin
          escaped_hash_content = escape_control_characters(hash_content)
          translations[current_lang] = eval("{#{escaped_hash_content}}")
        rescue SyntaxError => e
          puts "Error evaluating hash content for language '#{current_lang}': #{e.message}"
        end
        in_hash = false
        next
      end

      # Collect hash content
      if in_hash
        hash_content += line.strip
        hash_content += "\n" unless line.strip.empty?
      end
    end

    # Process any remaining hash if file ends
    if in_hash
      begin
        escaped_hash_content = escape_control_characters(hash_content)
        translations[current_lang] = eval("{#{escaped_hash_content}}")
      rescue SyntaxError => e
        puts "Error evaluating hash content for language '#{current_lang}': #{e.message}"
      end
    end

    # Store the translations with their fallback language
    @translations[file_path] = translations.merge(:fallback => fallback_lang)
  end

  # Load translations from a specific file
  def self.load_translations(file_path)
    parse_file(file_path) unless @translations[file_path]
  end

  # Retrieve the text for a given key from a specific file
  def self.text(key, file_path, return_as_string = false)
    load_translations(file_path)
  
    get_text = lambda do
      file_translations = @translations[file_path] || []
  
      # Check current language
      if file_translations[@current_language] && file_translations[@current_language].key?(key.to_sym)
        return file_translations[@current_language][key.to_sym]
      end
  
      # Check fallback language
      fallback_lang = file_translations[:fallback]
      if fallback_lang && file_translations[fallback_lang] && file_translations[fallback_lang].key?(key.to_sym)
        return file_translations[fallback_lang][key.to_sym]
      end
  
      # If key not found in either language, return missing message
      "[MISSING-#{key}-#{@current_language}]"
    end

    return_as_string ? get_text.call : get_text
  end

  LANGUAGE_CHANGED_HOOK = lambda do |setting|

    if setting == "AstiLib.Language"
      Language.set_language(languages()[AstiLib::ModSettings.get_setting(setting)])
    end
  end
end

AstiLib::MethodHooks.add_listener(:setting_changed, Language::LANGUAGE_CHANGED_HOOK)