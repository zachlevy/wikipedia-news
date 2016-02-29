class AddOngoingToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :ongoing, :boolean
  end
end
