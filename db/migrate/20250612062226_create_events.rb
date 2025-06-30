class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.string :status
      t.integer :user_id
      
      t.timestamps
    end
  end
end
