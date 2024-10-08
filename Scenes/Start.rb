class Scene_Map < Scene_Base
  alias_method :astilib_start, :start

  def start
    astilib_start

    AstiLib::MethodHooks.trigger_hook(:player_loaded)
  end
end