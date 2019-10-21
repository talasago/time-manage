class AddAgeBirthCheckflgToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :age_birth_checkflg, :char, default: "2", null: false
  end
end
