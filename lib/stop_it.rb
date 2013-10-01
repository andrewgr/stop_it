class StopIt

  class << self
    def stop &block
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
    response = stop?(env)

    if response == true
      [200, { 'Content-Type' => 'text/html', 'Content-Length' => '0' }, []]
    elsif response == false
      @app.call(env)
    else
      response
    end
  end

  private

  def stop?(env)
    StopIt.stop && StopIt.stop.call(
      env["PATH_INFO"],
      env["REMOTE_ADDR"],
      env["QUERY_STRING"],
      env["REQUEST_METHOD"],
      env["HTTP_USER_AGENT"]
    )
  end
end
