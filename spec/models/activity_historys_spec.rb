require 'rails_helper'

RSpec.describe ActivityHistorys, type: :model do
  #users.id = acitity_historys.user_idが紐づいていること
  #notnull制約　user_id,activity_name,from_time,to_time
  #activity_nameは改行NG
  #桁数activity_name 50
  #桁数remarks 255
  #1：Nの関係。act_history消してもuserは消えないこと

end
