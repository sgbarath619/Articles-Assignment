require "razorpay"
require "openssl"
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

      
      def webhook

        if params[:razorpay_signature].present?
          render json: params.as_json.merge(verification: "successfull"), status: :ok
        else
          render json: params.as_json.merge(verification: "unsuccessfull"), status: :unprocessable_entity
        end
      end
end
