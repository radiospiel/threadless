require 'rubygems'  
require 'rake'  
require 'echoe'  

Echoe.new('threadless', '0.1.2') do |p|  
  p.description     = "run_later without threads"  
  p.url             = "http://github.com/pboy/threadless"  
  p.author          = "pboy"  
  p.email           = "eno-pboy@open-lab.org"  
  p.ignore_pattern  = ["tmp/*", "script/*"]  
  p.development_dependencies = []  
end  

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
