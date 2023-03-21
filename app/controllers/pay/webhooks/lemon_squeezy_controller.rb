module Pay
  module Webhooks
    class LemonSqueezyController < Pay::ApplicationController
      if Rails.application.config.action_controller.default_protect_from_forgery
        skip_before_action :verify_authenticity_token
      end

      EVENT_TYPE_HEADER = "HTTP_X_EVENT_NAME"
      SIGNATURE_HEADER = "HTTP_X_SIGNATURE"

      def create
        queue_event(verified_event)
        head :ok
      rescue Pay::LemonSqueezy::Error
        head :bad_request
      end

      private

      def queue_event(event)
        return unless Pay::Webhooks.delegator.listening?("lemon_squeezy.#{event_type}")

        record = Pay::Webhook.create!(processor: :lemon_squeezy, event_type: event_type, event: event)
        Pay::Webhooks::ProcessJob.perform_later(record)
      end

      def verified_event
        event = verify_params.as_json
        verifier = Pay::LemonSqueezy::Webhooks::SignatureVerifier.new(request.body.read, request_signature)
        return event if verifier.verify
        raise Pay::LemonSqueezy::Error, "Unable to verify LemonSqueezy webhook event"
      end

      def event_type
        @event_type ||= request.env[EVENT_TYPE_HEADER]
      end

      def request_signature
        request_signature ||= request.env[SIGNATURE_HEADER]
      end

      def verify_params
        params.except(:action, :controller).permit!
      end
    end
  end
end
