#
# A single threaded runlater implementation
class Threadless
  ENV_KEY = "rack.threadless.run_later"
  
  module InstanceMethods 
    def threadless
      @threadless ||= Adapter.new(request)
    end
  end
  
  #
  # The adapter; use it as
  #
  #     threadless.run_later do ... end
  #
  # from within a controller or a view. 
  #
  class Adapter
    def initialize(request)
      @request = request
    end
    
    def run_later(run_later = true)
      if run_later
        @request.env[ENV_KEY] ||= []
        @request.env[ENV_KEY].push Proc.new
      else
        yield 
      end
    end
  end
  
  #
  # This replaces the metal body piece. It intercepts all messages and
  # adjusts "close" in such a way that close closes the original body, 
  # and then executes all the procs that are passed into the c'tor.
  class Executor
    def method_missing(sym, *args, &block)
      @body.__send__ sym, *args, &block
    end
    
    def initialize(body, procs)
      @body, @procs = body, procs
    end
    
    def close
      return if @closed
      @closed = true
      
      @body.close if @body.respond_to?(:close)

      @procs.each do |proc| 
        proc.call
      end
    end
  end
  
  #
  # The metal interface: initializing
  def initialize(app)
    @app = app
  end

  #
  # The metal interface: call
  def call(env)
    status, headers, body = *@app.call(env)
    
    body = Executor.new(body, env[ENV_KEY]) if env[ENV_KEY]
    
    [ status, headers, body ]
  end
end

#
# -- activate instance methods and middleware, on Rails

if defined?(ActionController)
  ActionController::Base.send(:include, Threadless::InstanceMethods)
  ActionController::Base.send(:helper, Threadless::InstanceMethods)

  middleware = ActionController::MiddlewareStack::Middleware.new(self)
  ActionController::Dispatcher.middleware.push middleware
end
