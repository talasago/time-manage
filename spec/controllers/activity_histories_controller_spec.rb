require 'rails_helper'

RSpec.describe ActivityHistoriesController, type: :controller do
  before do
    @act_history = FactoryBot.create(:activity_history)
    session[:user_id] = @act_history.user.id
  end

  describe "GET /act_history.json" do
    it "json eq activity_history data" do
      get :show, format: :json
      expect(response).to have_http_status(:success)
      json_hash = JSON.parse(response.body)
      #テストデータを複数の場合を考慮する必要がある。
      expect(json_hash[0]["title"]).to eq @act_history.activity_name
      expect(json_hash[0]["start"]).to eq @act_history.from_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      expect(json_hash[0]["end"]).to eq @act_history.to_time.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    end
  end
end
