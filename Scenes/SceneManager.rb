# This will get many more method hooks later
module SceneManager
  class << self
    alias_method :astilib_exit, :exit

    def exit
      AstiLib::MethodHooks.trigger_hook(:on_exit)

      astilib_exit
    end
  end
end