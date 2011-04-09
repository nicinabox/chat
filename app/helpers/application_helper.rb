module ApplicationHelper
  def auto_image msg
    unless msg.blank?
      img_url = /(^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png))/
      msg.gsub img_url, link_to('<img src="\\1" alt="image" />'.html_safe, '\\1', :target => "_blank")
    end
  end
end
