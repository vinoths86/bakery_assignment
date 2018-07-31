class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]
  before_action :set_order

  def index
    @order_items = OrderItem.all
  end

  def show
    @order_item_histories = @order_item.order_item_histories
  end

  def new
    @order_item = OrderItem.new(order_id: @order.id, quantity: 1)
  end

  def edit
  end

  def create
    @order_item = OrderItem.new(order_item_params.merge(order_id: @order.id))
    respond_to do |format|
      if @order_item.save
        format.html { redirect_to order_path(@order_item.order), notice: 'Item added to order.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to order_path(@order_item.order), notice: 'Quantity updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to order_path(@order_item.order), notice: 'Item removed from order.' }
    end
  end

  private
  
    def set_order
      @order = Order.find(params[:order_id]) if params[:order_id]
    end

    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def order_item_params
      params.require(:order_item).permit(:order_id, :item_id, :quantity)
    end
end
