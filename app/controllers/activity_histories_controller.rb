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
        format.json { render json: act_history.to_json, status: :created } #無意味なrender。js側でリロードしているため
      else
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

  def edit
    json_str  = request.body.read     # リクエストのJSON
    json_hash = JSON.parse(json_str,symbolize_names: true)

    act_history = current_user.activity_historys.select(
      "activity_name,
       to_char(from_time, 'YYYY-MM-DD') AS from_ymd,
       to_char(from_time, 'HH24:MI')      AS from_hm,
       to_char(to_time, 'YYYY-MM-DD')   AS to_ymd,
       to_char(to_time, 'HH24:MI')      AS to_hm,
       remarks"
    ).where(
      "activity_name = ? and from_time = ? and to_time = ?",
      json_hash[:title],
      DateTime.parse(json_hash[:start]),
      DateTime.parse(json_hash[:end])
    ).as_json(only: [:activity_name, :from_ymd, :from_hm, :toYMD, :to_ymd, :to_hm, :remarks])

    respond_to do |format|
      format.json {
        render json: act_history.to_json
      }
    end
  end
end
