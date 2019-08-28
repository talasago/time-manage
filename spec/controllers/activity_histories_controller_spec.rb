require 'rails_helper'

RSpec.describe ActivityHistoriesController, type: :controller do
  #jsonで値を取得できるか
  describe "GET /act_historys" do
    before do
      user = FactoryBot.create(:user)
      act_history = FactoryBot.create(:activity_history)
      session[:user_id] = user.id
    end

    it "json eq activity_history data" do
      get act_history_path
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq act_history.activity_name
      expect(json["start"]).to eq act_history.from_time
      expect(json["end"]).to eq act_history.to_time
    end
  end

  #jsonのデータで正しく更新できているか
end
