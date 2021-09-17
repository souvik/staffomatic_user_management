module SUM
  class SelfStatusUpdateError < StandardError
    def initialize(action_name)
      super("Cannot #{action_name} yourself")
    end
  end

  class DesireStatusError < StandardError
    def initialize(desire_status)
      @desire_status = desire_status
      super("Provided user is not in #{desire_status} state")
    end
  end
end
