class AddBodyWithIndexToComment < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :body_with_index, :text
  end
end
