require 'logger'

class SimplerLogger
  def initialize(app)
    @app = app
    @logger = Logger.new(Simpler.root.join('log/app.log'))
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(log(env, status, headers))
    [status, headers, response]
  end

  private

  def log(env, status, headers)
    controller = env['simpler.controller']

    request_string = "Request:    #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"

    if controller
      <<~OUTPUT
        #{request_string}
        Handler:    #{controller.class}##{env['simpler.action']}
        Parameters: #{env['simpler.params']}
        Response:   #{status} [#{headers}] #{env['simpler.template']}
      OUTPUT
    else
      <<~OUTPUT
        #{request_string}
        Response:   404 [#{headers}] "Not Found"
      OUTPUT
    end
  end
end
