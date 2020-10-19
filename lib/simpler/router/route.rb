module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(env)
        method = env['REQUEST_METHOD'].downcase.to_sym

        @method == method && parse_path(env)
      end

      def parse_path(env)
        path          = env['PATH_INFO']
        params        = {}
        router_slots  = @path.split('/')
        request_slots = path.split('/')

        return false unless router_slots.size == request_slots.size

        router_slots.each_index do |i|
          unless router_slots[i] == request_slots[i]
            match = router_slots[i].match(/^:(.+)/)

            return false if match.nil?

            params[match[1].to_sym] = request_slots[i]
          end
        end

        env['simpler.params'] = params
      end

    end
  end
end
