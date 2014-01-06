require 'redis'

class Redis
  class RedisLock
    
    def initialize(name. opts = {})
      @name = name
      @redis = Redis.new(opts)
    end

    def lock(timeout)
      @success = false
      @value = current_time + timeout + 1
      acquired = @redis.setnx(@name, @value.to_s)
      # TODO if...else...
    end

    private

    def current_time
      begin
        instant = @redis.time
        Time.at(instant[0], instant[1])
      rescue
        Time.new # failed to get redis time, use loal time instead
      end
    end

  end
end
