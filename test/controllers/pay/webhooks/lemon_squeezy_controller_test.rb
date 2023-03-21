require "test_helper"

module Pay
  class LemonSqueezyControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "should handle post requests" do
      post webhooks_paddle_path
      assert_response :bad_request
    end

    test "should parse a lemon_squeezy webhook" do
      user = User.create!
      params = fake_event "lemon_squeezy/order_created"

      assert_difference("Pay::Webhook.count") do
        assert_enqueued_with(job: Pay::Webhooks::ProcessJob) do
          post webhooks_lemon_squeezy_path,
            params: params,
            headers: {
              "X-Signature" => lemon_squeezy_request_signature_for(
                "test/support/fixtures/lemon_squeezy/order_created.json"
              ),
              "X-Event-Name" => "order_created"
            },
            as: :json
          assert_response :success
        end
      end
    end
  end
end
