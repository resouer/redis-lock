require 'redis'

module RedisLock
  class << self
    
    def initialize(name. opts = {})
      @name = name
      @redis = Redis.new(opts) # opts is for redis connection
    end

    def lock(timeout)
      @success = false
      @value = current_time + timeout + 1
      acquired = @redis.setnx(@name, @value.to_s)
      if acquired == 1
        sucess = true
      else
        old_value = @redis.get(@name).to_s
        if old_value < current_time
          get_value = @redis.getset(@name, @value)
          if get_value == old_value
            sucess = true
          else
            sucess = false
          end
        else
          sucess = false
        end
      end

      return sucess
    end

    def unlock
      if current_time < @redis.get(@name)
        @redis.del(@name)
      end
    end

    private

    def current_time
      begin
        instant = @redis.time
        Time.at(instant[0], instant[1])
      rescue
        Time.new # if failed to get redis time, use loal time instead
      end
    end

  end
end
