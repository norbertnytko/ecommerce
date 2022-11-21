module ClientOrders
  class CancelOrder < Infra::EventHandler
    def call(event)
      order = Order.find_by(order_uid: event.data.fetch(:order_id))
      unless order.nil?
        order.state = "Cancelled"
        order.save!
      end
    end
  end
end