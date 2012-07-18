class CreateApplications < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.string :api_name
      t.string :api_value

      t.timestamps
    end
  end
end
