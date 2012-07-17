class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :api_key

      t.timestamps
    end
  end
end
