require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env, response)
      @env = env
      @response = response
    end

    def render(_binding)
      return render_erb(_binding) if template.is_a?(String) || template.nil?
      return render_hash if template.is_a?(Hash)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def render_erb(_binding)
      @response['Content-Type'] = 'text/html'

      template = File.read(template_path)

      ERB.new(template).result(_binding)
    end

    # it can be widened to other types of non-html renders
    def render_hash
      if template.has_key?(:plain)
        @response['Content-Type'] = 'text/plain'
        template[:plain]
      end
    end
  end
end
