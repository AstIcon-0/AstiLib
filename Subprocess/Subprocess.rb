module AstiLib

  # # Subprocess
  # ------------
  # This class can run other apps as part of this RPGMaker game.
  # 
  # `AstiLib::Subprocess.new(file, allow_writing = false)`
  # When `allow_writing` is false, the game can only receive data from the subprocess.
  # If true, you can write to the subprocess using `write()`
  # 
  # **WRITING DATA TO A SUB-PROCESS WHILE THE RPGMAKER CONSOLE IS DISABLED WILL NOT WORK**
  # **WRITING DATA THUS ALSO WON'T WORK WHEN THE GAME IS RUN OUTSIDE OF THE EDITOR**
  # **THIS IS SOMETHING I WILL TRY TO FIX AS SOON AS POSSIBLE**
  class Subprocess
    def initialize(file, allow_writing = false)
      @file = file
      @process = IO.popen(@file, allow_writing ? "r+" : "r")
      Process.detach(@process.pid)
      @closed = false
    end

    # Write a string to the subprocess.
    # **Requires** `allow_writing` **to be true.**
    # 
    # @param [String] data
    # @return [Nil]
    def write(data)
      # Ensure the process is ready for writing to avoid pipe overflow
      if IO.select(nil, [@process], nil, 1)
        @process.puts(data)
      else
        puts "External console not ready for writing."
      end
    end

    # Pauses the game and waits for a message from the subprocess.
    # Has a time out to avoid permanently freezing the game in case receiving a message fails.
    # 
    # @param [Float] time_out How long to wait for a message, in seconds.
    # @return [String] The message from the subprocess, if one was received.
    def read(time_out = 1)
      if IO.select([@process], nil, nil, time_out)
        return @process.gets
      end
    end

    # Close the process.
    # A process can be reopened using `reopen()`.
    # Try to close a process before the user closes the game,
    # else the user needs to close the subprocess manually.
    def close
      unless @process
        puts "Process already closed"
        return
      end

      begin
        Process.kill("KILL", @process.pid)
        @process.close
        @process = nil
        @closed = true
      rescue Errno::EINVAL, Errno::ESRCH
        msgbox("Process already closed or invalid")
      end
    end

    def reopen(allow_writing)
      @process = IO.popen(@file, allow_writing ? "r+" : "r")
      @closed = false
    end

    def closed?
      return @closed
    end
  end
end