module SUM
  class SelfArchiveError < StandardError
    def message
      'Cannot archive/unarchive yourself'
    end
  end

  class DesireStatusError < StandardError
    def initialize(desire_status)
      @desire_status = desire_status
      super("Provided user is not in #{desire_status} state")
    end
  end
end
