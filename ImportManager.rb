module AstiLib

  # # Import Manager
  # ----------------
  # This module has methods for checking if script or other mods are imported.
  # And comparing versions.
  module ImportManager

    # Check if a script exists in `$imported`
    # 
    # @param [String] script_name
    # @return [Boolean]
    def self.imported?(script_name)
      return $imported.key?(script_name)
    end

    # Get the version of an imported script
    # 
    # @param [String] script_name
    # @return [Any]
    def self.version(script_name)
      return nil unless imported?(script_name)
      return $imported[script_name]
    end

    # Compare two version strings
    # They strings don't need to have the same amount of segments:
    # E.g. `compare("0.4.15", "1.3")` will work fine.
    # As long as the strings are integers seperated by dots.
    # 
    # Returns 1 if version1 is bigger. -1 if version2 is bigger.
    # And 0 if they are the same.
    # 
    # @param [String] version1
    # @param [String] version2
    # 
    # @return [Integer]
    def self.compare(version1, version2)
      v1_segments = version1.split(".").map(&:to_i)
      v2_segments = version2.split(".").map(&:to_i)
      max_length = [v1_segments.length, v2_segments.length].max
      max_length.times do |i|
        v1 = v1_segments[i] || 0
        v2 = v2_segments[i] || 0
        return 1 if v1 > v2
        return -1 if v1 < v2
      end
      return 0
    end

    # Check if an imported script's version is at least a specified version
    # 
    # @param [String] script_name
    # @param [String] version
    # @return [Boolean]
    def self.at_least?(script_name, version)
      return nil unless imported?(script_name)
      return compare(version(script_name), version) >= 0
    end

    # Check if an imported script's version is less than a specified version
    # 
    # @param [String] script_name
    # @param [String] version
    # @return [Boolean]
    def self.less_than?(script_name, version)
      return nil unless imported?(script_name)
      return compare(version(script_name), version) < 0
    end
  end
end