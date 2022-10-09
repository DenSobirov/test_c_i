class AddLogitudeToComment < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :longitude, :float
    add_column :comments, :latitude, :float
  end
end
