class ActivityHistoriesController < ApplicationController
  include SessionsHelper
  before_action :json_body_read, only: %i[create edit update destroy]
  before_action :logged_in_user_json, only: %i[create edit update destroy]
  before_action :accessed_user_logged_in_diff, only: %i[create update destroy]

  def initialize
    @json_hash = ""
    @accessed_user = ""
  end

  def create
    act_history = current_user.activity_historys.build(
      activity_name:      @json_hash[:activity_name],
      from_time:          @json_hash[:from_time],
      to_time:            @json_hash[:to_time],
      remarks:            @json_hash[:remarks],
      action:             "create",
      current_user:       current_user
    )

    respond_to do |format|
      if act_history.save
        flash[:success] = "登録しました"
        format.json { render json: act_history.to_json, status: :created } # 無意味なrender。js側でリロードしているため
      else
        format.json { render json: act_history.errors.full_messages.to_json, status: :unprocessable_entity }
      end
    end
  end

  def show
    accessed_user = User.find_by(id: params[:id])
    user = accessed_user_logged_in?(accessed_user) ? current_user : accessed_user

    act_histories = user.activity_historys.select(
      "activity_name AS title,
      from_time AS start,
      to_time   AS end"
    ).as_json(only: %i[title start end])

    respond_to do |format|
      format.json { render json: act_histories.to_json }
    end
  end

  def edit
    accessed_user = User.find_by(id: params[:id])
    user = accessed_user_logged_in?(accessed_user) ? current_user : accessed_user

    act_history = user.activity_historys.select(
      "activity_name,
       to_char(from_time, 'YYYY-MM-DD') AS from_ymd,
       to_char(from_time, 'HH24:MI')    AS from_hm,
       to_char(to_time, 'YYYY-MM-DD')   AS to_ymd,
       to_char(to_time, 'HH24:MI')      AS to_hm,
       remarks"
    ).where(
      "activity_name = ? and from_time = ? and to_time = ?",
      @json_hash[:title],
      Time.parse(@json_hash[:start]),
      Time.parse(@json_hash[:end])
    ).as_json(only: %i[activity_name from_ymd from_hm to_ymd to_hm remarks])

    respond_to do |format|
      format.json {
        render json: act_history.to_json
      }
    end
  end

  def update
    act_history = current_user.activity_historys.find_by(
      "activity_name = ? and from_time = ? and to_time = ?",
      @json_hash[:before_act_name],
      Time.parse(@json_hash[:before_from_time]),
      Time.parse(@json_hash[:before_to_time])
    )

    respond_to do |format|
      if act_history.update(
          activity_name:      @json_hash[:activity_name],
          from_time:          @json_hash[:from_time],
          to_time:            @json_hash[:to_time],
          remarks:            @json_hash[:remarks],
          action:             "update",
          current_user:       current_user
        )
        flash[:success] = "更新しました"
        format.json {
          render json: act_history.to_json, status: :created
        } # 無意味なrender。js側でリロードしているため
      else
        format.json {
          render json: act_history.errors.full_messages.to_json, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    act_history = current_user.activity_historys.find_by(
      "activity_name = ? and from_time = ? and to_time = ?",
      @json_hash[:before_act_name],
      Time.parse(@json_hash[:before_from_time]),
      Time.parse(@json_hash[:before_to_time])
    )

    act_history.destroy
    flash[:success] = "削除しました"
    # js側でリロードしているため、何も返却しない。ステータスは204
  end

  private

  def json_body_read
    json_str = request.body.read # リクエストのJSON
    @json_hash = JSON.parse(json_str, symbolize_names: true)
  end

  # ユーザーのログインを確認する
  def logged_in_user_json
    unless logged_in?
      flash[:danger] = "ログインしてください"
      error = "ログインしてください"

      respond_to do |format|
        format.json {
          render json: error.to_json, status: :unprocessable_entity
          # ログイン画面遷移はJS側
        }
      end
    end
  end

  # アクセスされたユーザーがログインしているユーザが異なる場合、js側で画面遷移する
  def accessed_user_logged_in_diff
    unless accessed_user_logged_in?
      error = "意図しない操作が行われました。"

      respond_to do |format|
        format.json {
          render json: error.to_json, status: :unprocessable_entity
          # ログイン画面遷移はJS側
        }
      end
    end
  end
end
