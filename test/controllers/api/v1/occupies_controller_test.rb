require "test_helper"

class Api::V1::OccupiesControllerTest < ActionDispatch::IntegrationTest
  test "lists occupies filtered by status" do
    get api_v1_occupies_url, params: { status: "in_use" }, as: :json
    assert_response :success
    assert_equal [occupies(:one).id], response.parsed_body.map { |row| row["id"] }
  end

  test "creates an occupy using membership and tag numbers" do
    assert_difference "Occupy.count", 1 do
      post api_v1_occupies_url, params: { occupy: {
        registrant_id: registrants(:one).number, tag_id: tags(:two).number, time_length: 60
      } }, as: :json
    end
    assert_response :created
    occupy = Occupy.find(response.parsed_body["id"])
    assert_equal registrants(:one), occupy.registrant
    assert_equal tags(:two), occupy.tag
    assert_equal "in_use", occupy.status
  end

  test "marks an occupy returned" do
    occupy = occupies(:one)
    patch api_v1_occupy_url(occupy), params: { occupy: { time_length: 90 } }, as: :json
    assert_response :success
    assert_equal "returned", occupy.reload.status
    assert_equal 90, occupy.time_length
  end

  test "deletes an occupy" do
    occupy = occupies(:one)
    assert_difference "Occupy.count", -1 do
      delete api_v1_occupy_url(occupy), as: :json
    end
    assert_response :success
    assert_not Occupy.exists?(occupy.id)
  end
end
