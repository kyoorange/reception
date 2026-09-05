require "test_helper"

class Api::V1::TagsControllerTest < ActionDispatch::IntegrationTest
  test "returns the active occupy for a tag number" do
    get api_v1_tag_occupy_url(tags(:one).number), as: :json
    assert_response :success
    assert_equal occupies(:one).id, response.parsed_body["id"]
    assert_equal "in_use", response.parsed_body["status"]
    assert_equal registrants(:one).number, response.parsed_body["registrant_number"]
  end

  test "returns not found when the tag has only returned occupies" do
    get api_v1_tag_occupy_url(tags(:two).number), as: :json
    assert_response :not_found
    assert_equal "No active occupy found for this tag", response.parsed_body["message"]
  end

  test "returns not found when the tag has no occupies" do
    tag = Tag.create!(number: "103", name: "Unused Tag")
    get api_v1_tag_occupy_url(tag.number), as: :json
    assert_response :not_found
  end

  test "returns the most recent active occupy" do
    latest = Occupy.create!(registrant: registrants(:two), tag: tags(:one), status: :in_use, created_at: 1.minute.from_now)
    get api_v1_tag_occupy_url(tags(:one).number), as: :json
    assert_response :success
    assert_equal latest.id, response.parsed_body["id"]
  end

  test "ignores newer returned occupies" do
    Occupy.create!(registrant: registrants(:two), tag: tags(:one), status: :returned, created_at: 1.minute.from_now)
    get api_v1_tag_occupy_url(tags(:one).number), as: :json
    assert_response :success
    assert_equal occupies(:one).id, response.parsed_body["id"]
  end
end
