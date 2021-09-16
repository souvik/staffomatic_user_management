class CreateActivityLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_logs do |t|
      t.references :user, foreign_key: true
      t.string :performed_action, limit: 255, null: false, default: ''
      t.string :action_method, limit: 50, null: false, default: ''
      t.text :payload

      t.timestamps
    end
  end
end
