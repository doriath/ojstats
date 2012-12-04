module ApplicationHelper
  def decimal_part number
    '.' + number.to_s.split(".").last
  end
  def gravatar_image_link email, options
    link_to gravatar_image_tag(email, options), "http://gravatar.com"
  end
end
