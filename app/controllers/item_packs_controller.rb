class ItemPacksController < ApplicationController
  before_action :set_item_pack, only: [:show, :edit, :update, :destroy]
  before_action :set_item

  def index
    @item_packs = ItemPack.all
  end

  def show
  end

  def new
    @item_pack = ItemPack.new(item_id: @item.id)
  end

  def edit
  end

  def create
    @item_pack = ItemPack.new(item_pack_params.merge(item_id: @item.id))

    respond_to do |format|
      if @item_pack.save
        format.html { redirect_to @item_pack.item, notice: 'Item pack was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @item_pack.update(item_pack_params)
        format.html { redirect_to @item_pack.item, notice: 'Item pack was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @item_pack.destroy
    respond_to do |format|
      format.html { redirect_to item_path(@item_pack.item), notice: 'Item pack was successfully destroyed.' }
    end
  end

  private
  
    def set_item
      @item = Item.find(params[:item_id]) if params[:item_id]
    end
    
    def set_item_pack
      @item_pack = ItemPack.find(params[:id])
    end

    def item_pack_params
      params.require(:item_pack).permit(:item_id, :quantity, :price)
    end
end
