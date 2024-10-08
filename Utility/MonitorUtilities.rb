module AstiLib

  # # Monitor Utils
  # --------------
  # Has utility methods for interacting with monitor.
  module MonitorUtils
    GetSystemMetrics = Win32API.new('user32', 'GetSystemMetrics', 'I', 'I')

    SM_CXSCREEN = 0
    SM_CYSCREEN = 1

    # Get the width and height of the primary monitor in pixels.
    # 
    # @return [Array<Integer[2]>] The width and the height.
    def self.get_screen_size
      width = GetSystemMetrics.call(SM_CXSCREEN)
      height = GetSystemMetrics.call(SM_CYSCREEN)
      return [width, height]
    end
  end
end