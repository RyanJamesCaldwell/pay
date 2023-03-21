require 'openssl'

module Pay
  module LemonSqueezy
    module Webhooks
      class SignatureVerifier
        def initialize(request_body, request_signature)
          @request_body = request_body
          @request_signature = request_signature
          @signing_secret = Pay::LemonSqueezy.signing_secret
        end

        # LemonSqueezy utilizes a signing secret (defined by the user) in order to allow the
        # webhook recipient to validate that webhook requests are coming from LemonSqueezy.
        #
        # For more information, see https://docs.lemonsqueezy.com/api/webhooks#signing-requests
        def verify
          return false if @request_signature.nil?

          hmac = OpenSSL::HMAC.new(@signing_secret, OpenSSL::Digest::SHA256.new)
          digest = hmac.update(@request_body).hexdigest

          ActiveSupport::SecurityUtils.secure_compare(digest, @request_signature)
        end
      end
    end
  end
end
