class CreateActivityHistorys < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_historys do |t|
      t.integer :user_id,        limit: 8, :null => false
      t.string :activity_name,   :null => false
      t.integer :category_id,    limit: 8
      t.datetime :from_time,     :null => false
      t.datetime :to_time,       :null => false
      t.string :remarks
      t.timestamps
    end
  end
end
