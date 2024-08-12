require "test_helper"

class EjemplosControllerTest < ActionDispatch::IntegrationTest
  test "should get inicio" do
    get ejemplos_inicio_url
    assert_response :success
  end
end
