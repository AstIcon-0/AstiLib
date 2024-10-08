module AstiLib

  # # Window Utils
  # --------------
  # Has utility methods for interacting with windows.
  module WindowUtils
    FIND_WINDOW = Win32API.new('user32', 'FindWindow', 'pp', 'l')
    SET_WINDOW_POS = Win32API.new('user32', 'SetWindowPos', 'iilliii', 'i')
    GET_WINDOW_RECT = Win32API.new('user32', 'GetWindowRect', 'lp', 'i')
    GET_SYSTEM_METRICS = Win32API.new('user32', 'GetSystemMetrics', 'i', 'i')

    SWP_NOSIZE = 0x0001
    SWP_NOMOVE = 0x0002

    # System metrics indices for border and title bar sizes
    SM_CXFRAME = 32    # Width of the window border
    SM_CYFRAME = 31    # Height of the window border
    SM_CYCAPTION = 4   # Height of the window title bar/caption

    # Handle for the RGSS Player window
    HWND = FIND_WINDOW.call('RGSS Player', nil)

    # Get the window handle (HWND)
    #
    # @return [Integer] The handle for the RGSS Player window.
    def self.hwnd
      return HWND
    end

    # Get a system metric value
    #
    # @param [Integer] metric The system metric index.
    # @return [Integer] The value of the specified system metric.
    def self.get_system_metric(metric)
      return GET_SYSTEM_METRICS.call(metric)
    end

    # Get the size of the window border
    #
    # @param [Integer] hwnd The window handle (optional).
    # @return [Array<Integer[2]>] The width and height of the window border.
    def self.get_border_size(hwnd = self.hwnd)
      border_x = get_system_metric(SM_CXFRAME)
      border_y = get_system_metric(SM_CYFRAME)
      return [border_x, border_y]
    end

    # Get the height of the window title bar
    #
    # @param [Integer] hwnd The window handle (optional).
    # @return [Integer] The height of the window title bar.
    def self.get_caption_height(hwnd = self.hwnd)
      return get_system_metric(SM_CYCAPTION)
    end

    # Get the window's rectangle (position and size)
    #
    # @param [Integer] hwnd The window handle (optional).
    # @return [Array<Integer[4]>] The window's rectangle coordinates [left, top, right, bottom].
    def self.get_window_rect(hwnd = self.hwnd)
      rect = [0, 0, 0, 0].pack('l*')
      GET_WINDOW_RECT.call(hwnd, rect)
      return rect.unpack('l*')
    end

    # Get the size of the window
    #
    # @param [Boolean] include_border Whether to include the border size in the calculation.
    # @param [Integer] hwnd The window handle (optional).
    # @return [Array<Integer[2]>] The width and height of the window.
    def self.get_window_size(include_border = false, hwnd = self.hwnd)
      rect = get_window_rect(hwnd)
      width = rect[2] - rect[0]
      height = rect[3] - rect[1]

      unless include_border
        border_size = get_border_size(hwnd)
        caption_height = get_caption_height(hwnd)
        width -= (border_size[0] * 2) - 10  # Adjust for border width
        height -= (border_size[1] + caption_height) - 16  # Adjust for border height
      end

      return [width, height]
    end

    # Set the position of the window
    #
    # @param [Integer] x The x-coordinate for the new position.
    # @param [Integer] y The y-coordinate for the new position.
    # @param [Integer] hwnd The window handle (optional).
    # @return [void]
    def self.set_window_pos(x, y, hwnd = self.hwnd)
      raise ArgumentError, "x and y must be integers" unless x.is_a?(Integer) && y.is_a?(Integer)
      
      result = SET_WINDOW_POS.call(hwnd, 0, x, y, 0, 0, SWP_NOSIZE)
      raise "SetWindowPos failed" if result == 0
    end

    # Set the size of the window
    #
    # @param [Integer] width The new width of the window.
    # @param [Integer] height The new height of the window.
    # @param [Boolean] include_border Whether to adjust for the window border.
    # @param [Integer] hwnd The window handle (optional).
    # @return [void]
    def self.set_window_size(width, height, include_border = false, hwnd = self.hwnd)
      raise ArgumentError, "width and height must be integers" unless width.is_a?(Integer) && height.is_a?(Integer)

      unless include_border
        border_size = get_border_size(hwnd)
        caption_height = get_caption_height(hwnd)
        width += (border_size[0] * 2) - 10  # Adjust for border width
        height += (border_size[1] + caption_height) - 16  # Adjust for border height
      end

      result = SET_WINDOW_POS.call(hwnd, 0, 0, 0, width, height, SWP_NOMOVE)
      raise "SetWindowPos (size) failed" if result == 0
    end
  end
end