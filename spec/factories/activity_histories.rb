FactoryBot.define do
  factory :activity_history do
    association :user
    activity_name { "activitynametest" }
    from_time { DateTime.parse("2019/08/25 11:00:00") }
    to_time { DateTime.parse("2019/08/26 11:00:00") }
    remarks { "RemarksTest" }
  end
end
