class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :votable, null: false, polymorphic: true
      t.index %i[user_id votable_id], unique: true
      t.boolean :liked

      t.timestamps
    end
  end
end
