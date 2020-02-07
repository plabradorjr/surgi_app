class AddTopicToNotesTable < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :topics, :string
  end
end
