module Amatista
  module HashExtensions::ObjectExtensions(K, V)
    def select(&block : K, V -> U)
      inject({} of K => V) do |memo, k, v|
        yield(k, v) ? memo.merge!({k => v}) : memo
      end
    end
  end
end

class Hash(K, V)
  include Amatista::HashExtensions::ObjectExtensions(K, V)
end
