require 'rails_helper'

RSpec.describe ActivityHistorysController, type: :controller do
  #jsonで値を取得できるか
  describe "GET /act_historys" do
    it "json eq activity_history data" do
      before do
        user = FactoryBot.create(:user)
        act_history = FactoryBot.create(:activity_history_test)
        session[:user_id] = user.id
      end

      get act_history_path
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq act_history.activity_name
    end
  end

  #jsonのデータで正しく更新できているか
end
