require 'rails_helper'

RSpec.describe ActivityHistoriesController, type: :controller do
  before do
    @act_history = FactoryBot.create(:activity_history)
    session[:user_id] = @act_history.user.id
  end

  describe "GET #show" do
    it "json eq activity_history data" do
      get :show, params: { id: @act_history.user.id }, format: :json
      expect(response).to have_http_status(:success)
      json_hash = JSON.parse(response.body)
      #テストデータを複数の場合を考慮する必要がある。
      expect(json_hash[0]["title"]).to eq @act_history.activity_name
      expect(json_hash[0]["start"]).to eq @act_history.from_time.strftime("%Y-%m-%dT%H:%M:%S.%L+09:00")
      expect(json_hash[0]["end"]).to eq @act_history.to_time.strftime("%Y-%m-%dT%H:%M:%S.%L+09:00")
    end
  end

  describe "POST #create" do
    context "save success" do
      it "redirect to 'ユーザーホーム画面'" do
        expect do
          post :create, params: { id: @act_history.user.id }, body: {
            activity_name: @act_history.activity_name,
            from_time: @act_history.from_time,
            to_time: @act_history.to_time,
            remarks: @act_history.remarks
          }.to_json, format: :json
        end.to change(ActivityHistory, :count).by(1)
      end
    end

    context "save faild" do
      it "not redirect" do
        expect do
          post :create, params: { id: @act_history.user.id }, body: {
            activity_name: nil,
            from_time: @act_history.from_time,
            to_time: @act_history.to_time,
            remarks: @act_history.remarks
          }.to_json, format: :json
        end.not_to change(ActivityHistory, :count)
      end
    end
  end

  describe "post #edit" do
    it "return json" do
      post :edit, params: { id: @act_history.user.id }, body: {
        title: @act_history.activity_name,
        start: @act_history.from_time,
        end: @act_history.to_time
      }.to_json, format: :json
      json_hash = JSON.parse(response.body)

      expect(json_hash[0]["activity_name"]).to eq @act_history.activity_name
      expect(json_hash[0]["from_ymd"]).to eq @act_history.from_time.strftime("%Y-%m-%d")
      expect(json_hash[0]["from_hm"]).to eq @act_history.from_time.strftime("%H:%M")
      expect(json_hash[0]["to_ymd"]).to eq @act_history.to_time.strftime("%Y-%m-%d")
      expect(json_hash[0]["to_hm"]).to eq @act_history.to_time.strftime("%H:%M")
      expect(json_hash[0]["remarks"]).to eq @act_history.remarks
    end
  end
end
