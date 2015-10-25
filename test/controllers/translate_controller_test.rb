require 'test_helper'

class TranslateControllerTest < ActionController::TestCase
  test "should get translate" do
    get :translate
    assert_response :success
  end

end
