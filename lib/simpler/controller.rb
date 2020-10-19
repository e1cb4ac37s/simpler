require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name     = extract_name
      @request  = Rack::Request.new(env)
      @request.params.merge!(env['simpler.params'])

      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      send(action)
      write_response

      @response.finish
    end

    protected

    def status(code)
      @response.status = code
    end

    def headers
      @response.headers
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env, @response).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
