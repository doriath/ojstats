module ApplicationHelper
  def decimal_part number
    '.' + number.to_s.split(".").last
  end
end
