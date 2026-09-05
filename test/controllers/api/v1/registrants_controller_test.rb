require "test_helper"

class Api::V1::RegistrantsControllerTest < ActionDispatch::IntegrationTest
  test "lists registrants" do
    get api_v1_registrants_url, as: :json
    assert_response :success
    assert_equal Registrant.order(:id).pluck(:id), response.parsed_body.map { |row| row["id"] }.sort
  end

  test "finds a registrant by membership number" do
    registrant = registrants(:one)
    get api_v1_registrant_url(registrant.number), as: :json
    assert_response :success
    assert_equal registrant.id, response.parsed_body["id"]
  end

  test "creates a registrant" do
    assert_difference "Registrant.count", 1 do
      post api_v1_registrants_url, params: { registrant: { name: "New Member", number: "1003" } }, as: :json
    end
    assert_response :created
    assert_equal "1003", Registrant.find(response.parsed_body["id"]).number
  end

  test "updates a registrant by membership number" do
    registrant = registrants(:one)
    patch api_v1_registrant_url(registrant.number), params: { registrant: { name: "Updated Member" } }, as: :json
    assert_response :success
    assert_equal "Updated Member", registrant.reload.name
  end

  test "deletes a registrant without occupies" do
    registrant = Registrant.create!(name: "Unused Member", number: "1003")
    assert_difference "Registrant.count", -1 do
      delete api_v1_registrant_url(registrant.number), as: :json
    end
    assert_response :success
    assert_not Registrant.exists?(registrant.id)
  end
end
