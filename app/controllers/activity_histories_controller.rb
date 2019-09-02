class ActivityHistoriesController < ApplicationController
  def create
    json_str  = request.body.read     # リクエストのJSON
    json_hash = JSON.parse(json_str,symbolize_names: true)

    act_history = current_user.activity_historys.build(
      activity_name:      json_hash[:activity_name],
      from_time:          json_hash[:from_time],
      to_time:            json_hash[:to_time],
      remarks:            json_hash[:remarks]
    )

    respond_to do |format|
      if act_history.save
        flash[:success] = "登録できました"
        format.json { render json: act_history.to_json, status: :created }
      else
        flash[:danger] = "登録することができませんでした"
        format.json {render json: act_history.errors.messages.to_json, status: :unprocessable_entity }
      end
    end
  end

  def show
    act_histories = current_user.activity_historys.select(
      "activity_name AS title,
      from_time AS start,
      to_time   AS end"
    ).as_json(only: [:title, :start, :end])

    respond_to do |format|
      format.json {
        render json: act_histories.to_json
      }
    end
  end
end
