class AddItemPackReferenceToOrderItemHistory < ActiveRecord::Migration[5.2]
  def change
  	add_reference :order_item_histories, :item_pack, index: true, foreign_key: true
  end
end
