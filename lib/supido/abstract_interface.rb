module Supido
  module AbstractInterface

    class InterfaceNotImplementedError < NoMethodError; end
    
    def self.included(klass)
      klass.send(:include, AbstractInterface::Methods)
      klass.send(:extend, AbstractInterface::Methods)
    end
    
    module Methods
      
      def not_implemented(klass)
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
        error_message  = "#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!"
        raise AbstractInterface::InterfaceNotImplementedError.new(error_message)
      end
      
    end
    
  end
end