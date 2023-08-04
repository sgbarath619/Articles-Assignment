require "razorpay"
class PaymentController < ApplicationController
  def create
    begin
      Razorpay.setup("rzp_test_hexb77iBAzbcUW", "Qm4oleMueXxmEpzwCvnR1oJb")

      @order = Razorpay::Order.create amount: params[:amount].to_i, currency: 'INR', receipt: 'TEST'
      
      render json: { order_id: @order.id, order_amount: @order.amount , key: "rzp_test_hexb77iBAzbcUW"}
    rescue Razorpay::Error => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def verify
    # paymentId = params[:razorpay_payment_id]

    # para_attr = {
    #     "amount"=> 500,
    #     "currency" => "INR"
    # }
    # begin
      # p = Razorpay::Payment.capture(params[:razorpay_payment_id], para_attr)
      # render json: p.to_json
    # rescue Razorpay::Error => e
    #   render json: { error: e.message }, status: :unprocessable_entity
    # end

    render json: params.as_json.merge(verification: "successfull")
  end

end
