class CustomFilter
  def initialize start_date_params, end_date_params
    @start = DateSelector.new(start_date_params)
    @end = DateSelector.new(end_date_params)
  end

  def start_date
    @start_date ||= @start.date()
  end

  def end_date
    @end_date ||= @end.date()
  end
end
