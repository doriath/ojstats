class DateSelector
  def initialize params
    @type = params[:type]
    @fixed_date = params[:date]
    @unit = params[:unit]
    @amount = params[:amount]
    @relation = params[:relation]
    @direction = params[:direction]
  end

  def date
    @date ||= compute_date
  end

  private

  def compute_date
    return @fixed_date.to_date if @type == "fixed"
    return compute_relative_date
  end

  def compute_relative_date
    @relation_date = compute_relation_date
    @span = compute_span

    return @relation_date + @span if @direction == "after"
    return @relation_date - @span if @direction == "before"
  end

  def compute_span
    @amount = @amount == "" ? 0 : @amount.to_i
    return @amount.days   if @unit == "days"
    return @amount.weeks  if @unit == "weeks"
    return @amount.months if @unit == "months"
    return @amount.years  if @unit == "years"
  end

  def compute_relation_date
    today = Date.today
    return today.beginning_of_week  if @relation == "week_begin"
    return today.beginning_of_month if @relation == "month_begin"
    return today.beginning_of_year  if @relation == "year_begin"
    return today.end_of_week        if @relation == "week_end"
    return today.end_of_month       if @relation == "month_end"
    return today.end_of_year        if @relation == "year_end"
    return today
  end
end
