class ActivityHistory < ApplicationRecord
  # アクセサ
  attr_accessor :action, :current_user
  # リレーション
  belongs_to :user
  # バリデーション
  validates :activity_name, presence: true, length: {maximum: 50}
  validates :from_time, presence: true
  validates :to_time, presence: true
  validates :remarks, length: {maximum: 255}
  validate :check_time

  private

  def check_time
    begin
      unless from_time < to_time
        errors.add(:from_time, ": 終了日時は開始日時より遅い時間である必要があります")
        errors.add(:to_time, ": 終了日時は開始日時より遅い時間である必要があります")
      end
    rescue
      if datetime_valid?(from_time)
        errors.add(:from_time, ": 開始日時が不正です")
      elsif datetime_valid?(to_time)
        errors.add(:to_time, ": 終了日時が不正です")
      end
    end
    same_time_zone_exists
  end

  # 日付時間に変換できる時にtrueを返す
  def datetime_valid?(datetime)
    Time.parse(datetime) rescue false
  end

  # 画面から受け取った開始時間、終了時間をもとにすでにDBに存在しているか検証する
  def same_time_zone_exists
    return true if current_user.nil? #RSpecでこのクラスのインスタンス生成時にnilとなってエラーになるため
    exists_act_historys = current_user.activity_historys.where(
      "(from_time < ? AND ? < to_time OR from_time < ? AND ? < to_time) OR
       (? < from_time AND to_time < ?)",
      from_time,
      from_time,
      to_time,
      to_time,
      from_time,
      to_time
    )

    if action == "create" && exists_act_historys.count > 0
      errors.add(:from_time, ": 同一時間帯の登録はできません")
      errors.add(:to_time, ": 同一時間帯の登録はできません")
    elsif action == "update" && exists_act_historys.count > 0
      exists_act_historys.pluck(:id).each do |exists_ids|
        if exists_ids != id
          errors.add(:from_time, ": 同一時間帯の登録はできません")
          errors.add(:to_time, ": 同一時間帯の登録はできません")
        end
      end
    end
  end
end
