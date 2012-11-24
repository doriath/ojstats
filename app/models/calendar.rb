class Calendar
  def initialize accepts
    create_history accepts
  end

  private

  def create_history accepts
    @history = {}
    accepts.each do |accept|
      year = accept.accepted_at.year
      month = accept.accepted_at.month
      day = accept.accepted_at.day

      initialize_data(year, month)

      @history[year][month][day] += 1
    end
  end

  def initialize_data year, month
    initialize_year(year) unless @history[year]
    initialize_month(year, month) unless @history[year][month]
  end

  def initialize_year year
    @history[year] = {}
  end

  def initialize_month year, month
    month_length = Date.new(year, month, 1).end_of_month - Date.new(year, month, 1) + 1
    @history[year][month] = []
    @history[year][month].fill(0, 0..month_length)
  end
end
