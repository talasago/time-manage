class ActivityHistory < ApplicationRecord
  belongs_to :user
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
    end

    #日付時間に変換できる時にtrueを返す
    def datetime_valid?(datetime)
      DateTime.parse(datetime) rescue false
    end
end
