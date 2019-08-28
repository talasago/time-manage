FactoryBot.define do
  factory :activity_history_test, :class => 'ActivityHistorys' do
    association :user
    activity_name { "activitynametest" }
    #start_time { "2019/08/25 11:00:00".to_date }
    #end_time { "2019/08/25 11:00:00".to_date }}
    remarks { "RemarksTest" }
  end
end
