class AddLongitudeToComment < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :longitude_with_index, :float
    add_column :comments, :latitude_with_index, :float
  end
end
