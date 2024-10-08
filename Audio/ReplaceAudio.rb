module AstiLib

  # # Audio
  # -------
  # This module contains methods for modifying audio.
  module Audio
    # Stores replacements for different types of audio (BGM, BGS, ME, SE).
    @replacements = {
      bgm: {},
      bgs: {},
      me: {},
      se: {}
    }
  
    # Replaces an audio file with a new one for a specified type.
    #
    # @param [Symbol] type The type of audio (:bgm, :bgs, :me, :se).
    # @param [String, Symbol] original_name The original audio name or :all for replacing all.
    # @param [String] replacement_path The file path to the replacement audio.
    # @param [Integer, Symbol] volume The volume for the replacement audio, or :original to keep the same.
    # @param [Integer, Symbol] pitch The pitch for the replacement audio, or :original to keep the same.
    def self.replace_audio(type, original_name, replacement_path, volume = :original, pitch = :original)
      if original_name == :all
        # Replace all audio of the given type
        @replacements[type][:all] = { path: replacement_path, volume: volume, pitch: pitch }
      else
        # Replace a specific audio file
        @replacements[type][original_name] = { path: replacement_path, volume: volume, pitch: pitch }
      end
    end
  
    # Finds the replacement audio for a given original audio name and type.
    #
    # @param [Symbol] type The type of audio (:bgm, :bgs, :me, :se).
    # @param [String] original_name The original name of the audio.
    # @return [Array<String, Integer, Integer>] The replacement path, volume, and pitch. 
    #   If no replacement is found, returns the original name with :original for volume and pitch.
    def self.find_replacement(type, original_name)
      # Check if there is a replacement for all audio or for the specific name
      replacement = @replacements[type][original_name] || @replacements[type][:all]
      
      if replacement
        return replacement[:path], replacement[:volume], replacement[:pitch]
      else
        # Return the original if no replacement is found
        return original_name, :original, :original
      end
    end

    #==============================================================================
    # Methods for replacing sound
    #==============================================================================
  
    # Replace background music (BGM) with a new file.
    #
    # @param [String, Symbol] original_name The original BGM name or :all to replace all.
    # @param [String] replacement_path The file path to the replacement BGM.
    # @param [Integer, Symbol] volume The volume for the replacement BGM, or :original to keep the same.
    # @param [Integer, Symbol] pitch The pitch for the replacement BGM, or :original to keep the same.
    def self.replace_bgm(original_name, replacement_path, volume = :original, pitch = :original)
      replace_audio(:bgm, original_name, replacement_path, volume, pitch)
    end
  
    # Replace background sound (BGS) with a new file.
    #
    # @param [String, Symbol] original_name The original BGS name or :all to replace all.
    # @param [String] replacement_path The file path to the replacement BGS.
    # @param [Integer, Symbol] volume The volume for the replacement BGS, or :original to keep the same.
    # @param [Integer, Symbol] pitch The pitch for the replacement BGS, or :original to keep the same.
    def self.replace_bgs(original_name, replacement_path, volume = :original, pitch = :original)
      replace_audio(:bgs, original_name, replacement_path, volume, pitch)
    end
  
    # Replace music effect (ME) with a new file.
    #
    # @param [String, Symbol] original_name The original ME name or :all to replace all.
    # @param [String] replacement_path The file path to the replacement ME.
    # @param [Integer, Symbol] volume The volume for the replacement ME, or :original to keep the same.
    # @param [Integer, Symbol] pitch The pitch for the replacement ME, or :original to keep the same.
    def self.replace_me(original_name, replacement_path, volume = :original, pitch = :original)
      replace_audio(:me, original_name, replacement_path, volume, pitch)
    end
  
    # Replace sound effect (SE) with a new file.
    #
    # @param [String, Symbol] original_name The original SE name or :all to replace all.
    # @param [String] replacement_path The file path to the replacement SE.
    # @param [Integer, Symbol] volume The volume for the replacement SE, or :original to keep the same.
    # @param [Integer, Symbol] pitch The pitch for the replacement SE, or :original to keep the same.
    def self.replace_se(original_name, replacement_path, volume = :original, pitch = :original)
      replace_audio(:se, original_name, replacement_path, volume, pitch)
    end
  end
end

class RPG::BGM < RPG::AudioFile
  alias_method :astilib_play, :play

  def play(pos = 0)
    replacement_path, replacement_volume, replacement_pitch = AstiLib::Audio.find_replacement(:bgm, @name)
    
    if replacement_path != @name && replacement_path.include?('/')
      volume = replacement_volume == :original ? @volume : replacement_volume
      pitch = replacement_pitch == :original ? @pitch : replacement_pitch
      Audio.bgm_play(replacement_path, volume, pitch, pos)
    else
      @name = replacement_path
      astilib_play(pos)
    end
  end
end

class RPG::BGS < RPG::AudioFile
  alias_method :astilib_play, :play

  def play(pos = 0)
    replacement_path, replacement_volume, replacement_pitch = AstiLib::Audio.find_replacement(:bgs, @name)
    
    if replacement_path != @name && replacement_path.include?('/')
      volume = replacement_volume == :original ? @volume : replacement_volume
      pitch = replacement_pitch == :original ? @pitch : replacement_pitch
      Audio.bgs_play(replacement_path, volume, pitch, pos)
    else
      @name = replacement_path
      astilib_play(pos)
    end
  end
end

class RPG::ME < RPG::AudioFile
  alias_method :astilib_play, :play

  def play
    replacement_path, replacement_volume, replacement_pitch = AstiLib::Audio.find_replacement(:me, @name)
    
    if replacement_path != @name && replacement_path.include?('/')
      volume = replacement_volume == :original ? @volume : replacement_volume
      pitch = replacement_pitch == :original ? @pitch : replacement_pitch
      Audio.me_play(replacement_path, volume, pitch)
    else
      @name = replacement_path
      astilib_play
    end
  end
end

class RPG::SE < RPG::AudioFile
  alias_method :astilib_play, :play

  def play
    replacement_path, replacement_volume, replacement_pitch = AstiLib::Audio.find_replacement(:se, @name)
    
    if replacement_path != @name && replacement_path.include?('/')
      volume = replacement_volume == :original ? @volume : replacement_volume
      pitch = replacement_pitch == :original ? @pitch : replacement_pitch
      Audio.se_play(replacement_path, volume, pitch)
    else
      @name = replacement_path
      astilib_play
    end
  end
end