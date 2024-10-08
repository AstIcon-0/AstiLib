module Graphics
  class << self
    alias_method :astilib_update_hook, :update
    alias_method :astilib_transition_hook, :transition
    
    def update
      return_data = astilib_update_hook()
      AstiLib::MethodHooks.trigger_hook(:on_graphics_update)
      return return_data
    end
    
    def transition(duration = 10, filename = "", vague = 40)
      AstiLib::MethodHooks.trigger_hook(:on_start_transition)
      return_data = astilib_transition_hook(duration, filename, vague)
      AstiLib::MethodHooks.trigger_hook(:on_end_transition)
      return return_data
    end
  end
end