class TutorialController < ApplicationController

  def tutorial_evaluation_other
    if current_user.tutorial == 0 or current_user.tutorial == 1 then
      current_user.tutorial = 1
      current_user.save
    else
      current_user.tutorial = 3
      current_user.save
    end
  end

  def tutorial_insert_other
    if current_user.tutorial == 0 or current_user.tutorial == 2 then
      current_user.tutorial = 2
      current_user.save
    else
      current_user.tutorial = 3
      current_user.save
    end
  end

end
