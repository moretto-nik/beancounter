class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :username_beancounter
      t.string :password_beancounter
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :sex
      t.integer :click

      t.timestamps
    end
  end
end
