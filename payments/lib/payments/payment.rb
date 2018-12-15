module Payments
  AlreadyAuthorized = Class.new(StandardError)
  NotAuthorized = Class.new(StandardError)

  class Payment
    include AggregateRoot

    def authorize(transaction_id, order_id)
      raise AlreadyAuthorized if authorized?
      apply(PaymentAuthorized.new(data: {
        transaction_id: transaction_id,
        order_id: order_id
      }))
    end

    def capture
      raise NotAuthorized unless authorized?
      apply(PaymentCaptured.new(data: {
        transaction_id: @transaction_id,
        order_id: @order_id
      }))
    end

    private

    on PaymentAuthorized do |event|
      @state = :authorized
      @transaction_id = event.data.fetch(:transaction_id)
      @order_id = event.data.fetch(:order_id)
    end

    on PaymentCaptured do |event|
    end

    def authorized?
      @state == :authorized
    end
  end
end

