module SUM
  class SelfArchiveError < StandardError
    def message
      'Cannot archive/unarchive yourself'
    end
  end
end
