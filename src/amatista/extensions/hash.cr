module Amatista
  module HashExtensions(K, V)
    def select(&block : K, V -> U)
      inject({} of K => V) do |memo, k, v|
        yield(k, v) ? memo.merge!({k => v}) : memo
      end
    end
  end
end

class Hash(K, V)
  include Amatista::HashExtensions(K, V)
end
