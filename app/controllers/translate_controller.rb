class TranslateController < ApplicationController

  def translate
    # flash.keep
    redirect_to login_path, :ssl => true
  end
end
