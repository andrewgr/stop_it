# Middleware to block unwanted requests to a Rake app
class StopIt
  class << self
    def stop(&block)
      if block_given?
        @stop = block
      else
        @stop
      end
    end
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    should_be_stopped = request_should_be_stopped?(env)

    if should_be_stopped == true
      [200, { 'Content-Type' => 'text/html', 'Content-Length' => '0' }, []]
    elsif !should_be_stopped
      @app.call(env)
    else
      should_be_stopped
    end
  end

  private

  def request_should_be_stopped?(env)
    StopIt.stop && StopIt.stop.call(
      path_info:       env['PATH_INFO'],
      remote_addr:     env['REMOTE_ADDR'],
      query_string:    env['QUERY_STRING'],
      request_method:  env['REQUEST_METHOD'],
      http_user_agent: env['HTTP_USER_AGENT']
    )
  end
end
