module Pay
  module LemonSqueezy
    class Billable
      attr_reader :pay_customer

      delegate :processor_id,
        :processor_id?,
        :email,
        :customer_name,
        :card_token,
        to: :pay_customer

      def initialize(pay_customer)
        @pay_customer = pay_customer
      end

      def customer
        # pass
      end

      def update_customer!
        # pass
      end

      def charge(amount, options = {})
      end

      def subscribe(name: Pay.default_product_name, plan: Pay.default_plan_name, **options)
      end

      def add_payment_method(payment_method_id, default: false)
      end

      def processor_subscription(subscription_id, options = {})
      end

      def trial_end_date(subscription)
      end
    end
  end
end
