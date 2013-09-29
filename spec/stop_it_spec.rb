require 'spec_helper'

describe StopIt do
  let!(:app) { app = double("App", call: nil) }

  subject(:middleware) { StopIt.new(app) }

  shared_examples_for "blocker" do |env|
    specify do
      middleware.call(env)
      expect(app).not_to have_received(:call)
    end
  end

  shared_examples_for "non-blocker" do |env|
    specify do
      middleware.call(env)
      expect(app).to have_received(:call)
    end
  end

  describe "does not stop request if stop block returns false" do
    before { StopIt.stop { |path_info, remote_addr, query_string, request_method, user_agent| false } }
    it_should_behave_like "non-blocker", {}
  end

  describe "stops request if stop block returns true" do
    before { StopIt.stop { |path_info, remote_addr, query_string, request_method, user_agent| true } }
    it_should_behave_like "blocker", {}
  end

  describe "filter requests by PATH_INFO env variable" do
    before do
      StopIt.stop do |path_info, remote_addr, query_string, request_method, user_agent|
        path_info == "/forbidden"
      end
    end

    it_should_behave_like "blocker", "PATH_INFO" => "/forbidden"
    it_should_behave_like "non-blocker", "PATH_INFO" => "/public"
  end

  describe "filter requests by REMOTE_ADDR env variable" do
    before do
      StopIt.stop do |path_info, remote_addr, query_string, request_method, user_agent|
        remote_addr == "192.168.0.1"
      end
    end

    it_should_behave_like "blocker", "REMOTE_ADDR" => "192.168.0.1"
    it_should_behave_like "non-blocker", "REMOTE_ADDR" => "127.0.0.1"
  end

  describe "filter requests by QUERY_STRING env variable" do
    before do
      StopIt.stop do |path_info, remote_addr, query_string, request_method, user_agent|
        query_string == "?block"
      end
    end

    it_should_behave_like "blocker", "QUERY_STRING" => "?block"
    it_should_behave_like "non-blocker", "QUERY_STRING" => ""
  end

  describe "filter requests by REQUEST_METHOD env variable" do
    before do
      StopIt.stop do |path_info, remote_addr, query_string, request_method, user_agent|
        request_method == "POST"
      end
    end

    it_should_behave_like "blocker", "REQUEST_METHOD" => "POST"
    it_should_behave_like "non-blocker", "REQUEST_METHOD" => "GET"
  end

  describe "filter requests by HTTP_USER_AGENT env variable" do
    before do
      StopIt.stop do |path_info, remote_addr, query_string, request_method, user_agent|
        user_agent == "evil robot"
      end
    end

    it_should_behave_like "blocker", "HTTP_USER_AGENT" => "evil robot"
    it_should_behave_like "non-blocker", "HTTP_USER_AGENT" => "IE"
  end
end
