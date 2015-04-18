require 'spec_helper'

describe StopIt do
  let!(:app) { double('App', call: nil) }

  subject(:middleware) { StopIt.new(app) }

  shared_examples_for 'blocker' do |env|
    before  { middleware.call(env) }
    specify { expect(app).not_to have_received(:call) }
  end

  shared_examples_for 'non-blocker' do |env|
    before  { middleware.call(env) }
    specify { expect(app).to have_received(:call) }
  end

  describe 'middleware response' do
    context 'stop block not specified' do
      before { StopIt.instance_variable_set('@stop', nil) }
      it_behaves_like 'non-blocker', {}
    end

    context 'stop block returns false' do
      before { StopIt.stop { false } }
      it_behaves_like 'non-blocker', {}
    end

    context 'stop block returns true' do
      before { StopIt.stop { true } }
      it_behaves_like 'blocker', {}
    end

    context 'stop block returns rake status' do
      let(:response) do
        [403, { 'Content-Type' => 'text/html', 'Content-Length' => '0' }, []]
      end

      before { StopIt.stop { response } }
      specify { expect(middleware.call({})) == response }
    end
  end

  describe 'filter requests by PATH_INFO env variable' do
    before { StopIt.stop { |env| env[:path_info] == '/forbidden' } }

    it_behaves_like 'blocker',     'PATH_INFO' => '/forbidden'
    it_behaves_like 'non-blocker', 'PATH_INFO' => '/public'
  end

  describe 'filter requests by REMOTE_ADDR env variable' do
    before { StopIt.stop { |env| env[:remote_addr] == '192.168.0.1' } }

    it_behaves_like 'blocker',     'REMOTE_ADDR' => '192.168.0.1'
    it_behaves_like 'non-blocker', 'REMOTE_ADDR' => '127.0.0.1'
  end

  describe 'filter requests by QUERY_STRING env variable' do
    before { StopIt.stop { |env| env[:query_string] == '?block' } }

    it_behaves_like 'blocker',     'QUERY_STRING' => '?block'
    it_behaves_like 'non-blocker', 'QUERY_STRING' => ''
  end

  describe 'filter requests by REQUEST_METHOD env variable' do
    before { StopIt.stop { |env| env[:request_method] == 'POST' } }

    it_behaves_like 'blocker',     'REQUEST_METHOD' => 'POST'
    it_behaves_like 'non-blocker', 'REQUEST_METHOD' => 'GET'
  end

  describe 'filter requests by HTTP_USER_AGENT env variable' do
    before { StopIt.stop { |env| env[:http_user_agent] == 'evil robot' } }

    it_behaves_like 'blocker',     'HTTP_USER_AGENT' => 'evil robot'
    it_behaves_like 'non-blocker', 'HTTP_USER_AGENT' => 'IE'
  end
end
