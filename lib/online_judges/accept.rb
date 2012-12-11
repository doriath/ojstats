module OnlineJudges
  # @param [Time] accepted_at
  # @param [String] problem the name of the problem that was accepted
  # @param [String] points the number of points this accept received; null if
  #                 the problem is just accepted (most common case)
  Accept = Struct.new(:accepted_at, :problem, :points)
end
