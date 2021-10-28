class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.text :title, null: false
      t.references :user, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
