module Obscura
  class MissionResult
    NO_ROLL = -1

    getter :roll
    getter :status

    def initialize(status : Symbol, roll = NO_ROLL)
      @roll = roll
      @status = status
    end
  end
end
