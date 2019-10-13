class AddOtherInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :char, default: "0"
    add_column :users, :birth_date, :date
    add_column :users, :age, :integer, limit: 2
    add_column :users, :user_icon, :string
    add_column :users, :employment, :string
    add_column :users, :hobby, :string
    add_column :users, :remarks, :string
  end
end
