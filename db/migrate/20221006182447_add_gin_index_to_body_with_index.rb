class AddGinIndexToBodyWithIndex < ActiveRecord::Migration[6.1]
  def up
    enable_extension("pg_trgm");
    add_index(:comments, :body, using: 'gin', opclass: :gin_trgm_ops)
  end

  def down
    remove_index(:comments, :body)
  end
end
