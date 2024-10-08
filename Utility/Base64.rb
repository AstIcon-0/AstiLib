module AstiLib

  # # Base 64
  # ---------
  # This module has methods for encoding strings to and decoding from Base64.
  module Base64
    # List of characters that appear in Base64
    BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
  
    # Encodes a string to Base64.
    # 
    # @param [String] string The string you want to encode to Base64.
    # @return [String] A Base64 encoded string.
    def self.encode(string)
      begin
        result = ""
        bitstring = string.each_byte.map { |byte| byte.to_s(2).rjust(8, "0") }.join
  
        until bitstring.empty?
          chunk = bitstring.slice!(0, 6).ljust(6, "0")
          result << BASE64_CHARS[chunk.to_i(2)]
        end
  
        result << "=" * (4 - result.length % 4) if result.length % 4 != 0
  
        return result
      rescue => e
        msgbox("Encoding error: #{e.message}")
        return nil
      end
    end
  
    # Decodes a string from Base64
    # 
    # @param [String] base64_string The string you want to decode.
    # @return [String] A decoded string.
    def self.decode(base64_str)
      begin
        result = ""
        bitstring = ""
  
        base64_str.each_char do |char|
          next if char == "="
          index = BASE64_CHARS.index(char)
          if index.nil?
            raise ArgumentError, "Invalid character in Base64 string"
          end
          chunk = index.to_s(2).rjust(6, "0")
          bitstring << chunk
        end
  
        until bitstring.empty?
          result << bitstring.slice!(0, 8).to_i(2).chr
        end
  
        return result
      rescue ArgumentError => e
        msgbox(e.message)
        return nil
      rescue => e
        msgbox("Decoding error: #{e.message}")
        return nil
      end
    end
  end
end