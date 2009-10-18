
class Threadless
  ENV_KEY = "rack.run_later"
  
  def initialize(app)
    @app = app
  end

  module InstanceMethods 
    def run_later
      request.env[ENV_KEY] ||= []
      request.env[ENV_KEY].push Proc.new
    end
  end
  
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
  
  def call(env)
    status, headers, body = *@app.call(env)
    
    body = Executor.new(body, env[ENV_KEY]) if env[ENV_KEY]
    
    [ status, headers, body ]
  end

  def self.init
    ActionController::Base.send(:include, Threadless::InstanceMethods)
    middleware = ActionController::MiddlewareStack::Middleware.new(self)
    ActionController::Dispatcher.middleware.push middleware
  end
end

# activate instance methods and middle ware
Threadless.init
