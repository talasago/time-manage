class ActivityHistoriesController < ApplicationController
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
