class AddGistIndexToCoordinatesWithIndex < ActiveRecord::Migration[6.1]
  def change
    def up
      execute 'CREATE INDEX location_idx ON comments USING gist (ll_to_earth(latitude_with_index, longitude_with_index));'
    end

    def down
      execute 'DROP INDEX location_idx;'
    end
  end
end
