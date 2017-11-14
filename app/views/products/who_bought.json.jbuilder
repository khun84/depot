json.title "Who bought #{@product.title}"
json.last_updated @latest_order
                          .updated_at.in_time_zone(ActiveSupport::TimeZone.new("Kuala Lumpur"))
                          .strftime("%Y-%m-%d %H:%M") \
                          if @latest_order.present?
  json.orders @product.orders.includes(:line_items) do |order|
    json.detail do
      json.array! order.line_items do |item|
        json.product item.product.title
        json.quantity item.quantity
        json.total_price item.total_price
      end
    end
    json.bought_by order.name
    json.total_price order.line_items.map(&:total_price).sum
  end


