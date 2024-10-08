module AstiLib; module Database
  # # Learnings
  # -----------
  # Has methods for manipulating the learnings of classes.
  module Learnings
    def add_learning(level = 1, skill_id = 1, note = "")
      learning = RPG::Class::Learning.new
      learning.level = level
      learning.skill_id = skill_id
      learning.note = note

      @learnings.push(learning)
    end

    def clear_learnings
      @learnings = []
    end
  end
end; end