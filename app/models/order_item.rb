class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item
  has_many :order_item_histories, autosave: true, dependent: :destroy
  before_create :build_order_item_histories

  validates_numericality_of :quantity
  
  default_scope { includes(:item) }

  
  def build_order_item_histories
    return if item.nil?

    denominations = item.item_packs.pluck(:quantity).sort!.reverse

    quantities = Hash.new(0)
    real_evalucation(quantity, denominations).each do |q|
      quantities[q] += 1
    end

    item.item_packs.order("quantity DESC").each do |pack|
      params = {
        item_pack_id: pack.id,
        quantity: quantities[pack.quantity],
        price_per_pack: pack.price
      }
      order_item_histories << OrderItemHistory.new(params) if quantities[pack.quantity] > 0
    end
    
    errors.add(:quantity, "needs to fit packs of #{denominations.join(" or ")}") if quantities.empty?
  end

  def sub_totalal
    order_item_histories.map{|h| h.sub_totalal}.inject(0){|sum,v| sum + v }
  end

private

  def real_evalucation(a, list = [25, 10, 5, 1])
    return [] if a < 0
    return [] if a != a.floor

    get_initial = Array.new(a + 1)
    get_initial[0] = 0
    real_arr = [[0, 0]]
    while get_initial[a].nil? && !real_arr.empty? do
      base, starting_index = real_arr.shift
      starting_index.upto(list.size - 1) do |index|
        denomination = list[index]
        _total = base + denomination
        if _total <= a && get_initial[_total].nil?
          get_initial[_total] = base
          real_arr << [_total, index]
        end
      end
    end

    return [] if get_initial[a].nil?
    result = []
    while a > 0 do
      pre_stage = get_initial[a]
      result << a - pre_stage
      a = pre_stage
    end
    result.sort!.reverse!
  end
end
