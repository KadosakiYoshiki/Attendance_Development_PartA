require 'test_helper'

class CentersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get centers_index_url
    assert_response :success
  end

end
