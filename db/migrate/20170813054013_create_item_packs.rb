class CreateItemPacks < ActiveRecord::Migration[5.2]
  def change
    create_table :item_packs do |t|
      t.references :item, index: true, foreign_key: true
      t.integer :quantity
      t.float :price

      t.timestamps null: false
    end
  end
end
