class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :post, null: false, foreign_key: true
      # b-tree
      # b-tree - without

      # hash
      # hash- without

      # gin
      # gin- without

      # gist
      # gist- without
      # можно добавить координаты

      # sp-gist
      # sp-gist- without

      # brin
      # brin- without

      t.timestamps
    end
  end
end
