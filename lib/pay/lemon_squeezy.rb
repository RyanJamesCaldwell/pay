module Pay
  module LemonSqueezy
    autoload :Billable, "pay/lemon_squeezy/billable"
    autoload :Charge, "pay/lemon_squeezy/charge"
    autoload :Error, "pay/lemon_squeezy/error"
    autoload :PaymentMethod, "pay/lemon_squeezy/payment_method"
    autoload :Subscription, "pay/lemon_squeezy/subscription"

    module Webhooks
      autoload :OrderCreated, "pay/lemon_squeezy/webhooks/order_created"
      autoload :SignatureVerifier, "pay/lemon_squeezy/webhooks/signature_verifier"
      autoload :SubscriptionCreated, "pay/lemon_squeezy/webhooks/subscription_created"
      autoload :SubscriptionPaymentSuccess, "pay/lemon_squeezy/webhooks/subscription_payment_success"
      autoload :SubscriptionUpdated, "pay/lemon_squeezy/webhooks/subscription_updated"
    end

    extend Env

    def self.enabled?
      Pay.enabled_processors.include?(:lemon_squeezy)
    end

    def self.setup
      # TODO
    end

    def self.signing_secret
      find_value_by_name(:lemon_squeezy, :signing_secret)
    end

    def self.environment
      find_value_by_name(:lemon_squeezy, :environment) || "production"
    end

    def self.api_key
      find_value_by_name(:lemon_squeezy, :api_key)
    end

    def self.configure_webhooks
      Pay::Webhooks.configure do |events|
        events.subscribe "lemon_squeezy.order_created", Pay::LemonSqueezy::Webhooks::OrderCreated.new
        events.subscribe "lemon_squeezy.subscription_created", Pay::LemonSqueezy::Webhooks::SubscriptionCreated.new
        events.subscribe "lemon_squeezy.subscription_payment_success", Pay::LemonSqueezy::Webhooks::SubscriptionPaymentSuccess.new
        events.subscribe "lemon_squeezy.subscription_updated", Pay::LemonSqueezy::Webhooks::SubscriptionUpdated.new
      end
    end
  end
end
