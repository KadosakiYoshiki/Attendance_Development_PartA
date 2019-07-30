require 'test_helper'

class AttendancelogsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get attendancelogs_create_url
    assert_response :success
  end

end
