require "test_helper"

class Pay::LemonSqueezy::Webhooks::SignatureVerifierTest < ActiveSupport::TestCase
  setup do
    order_created_fixture = "test/support/fixtures/lemon_squeezy/order_created.json"
    @request_signature = lemon_squeezy_request_signature_for(order_created_fixture)
    @request_body = File.read(order_created_fixture)
  end

  test "webhook signature is verified correctly when signing secrets match" do
    verifier = Pay::LemonSqueezy::Webhooks::SignatureVerifier.new(@request_body, @request_signature)
    assert verifier.verify
  end

  test "webhook signature is not verified when signing secrets differ" do
    ENV["LEMON_SQUEEZY_SIGNING_SECRET"] = "non_matching_signing_secret"
    verifier = Pay::LemonSqueezy::Webhooks::SignatureVerifier.new(@request_body, @request_signature)
    refute verifier.verify
  end

  test "returns false if provided request signature is nil" do
    verifier = Pay::LemonSqueezy::Webhooks::SignatureVerifier.new(@request_body, nil)
    refute verifier.verify
  end
end
