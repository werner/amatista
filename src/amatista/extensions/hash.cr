module Amatista
  module HashExtensions(K, V)
    def select(&block : K, V -> U)
      inject({} of K => V) do |memo, k, v|
        yield(k, v) ? memo.merge!({k => v}) : memo
      end
    end

    def select!(&block : K, V -> U)
      delete_if{|k, v| !yield k, v }
    end

    def reject(&block : K, V -> U)
      inject({} of K => V) do |memo, k, v|
        yield(k, v) ? memo : memo.merge!({k => v})
      end
    end

    def reject!(&block : K, V -> U)
      delete_if{|k, v| yield k, v }
    end
  end
end

class Hash(K, V)
  include Amatista::HashExtensions(K, V)
end
