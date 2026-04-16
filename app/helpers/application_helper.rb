module ApplicationHelper
  def avatar(user, size: 40)
    if user.avatar.attached?
      image_tag(user.avatar, class: "rounded-full object-cover", style: "width: #{size}px; height: #{size}px;")
    else
      content_tag(:div, class: "rounded-full bg-gray-300 flex items-center justify-center text-gray-600 font-bold", style: "width: #{size}px; height: #{size}px;") do
        (user.username || user.email).first(1).upcase
      end
    end
  end

  def online_indicator(user)
    content_tag(:span, "", class: "w-3 h-3 bg-green-500 rounded-full border-2 border-white absolute bottom-0 right-0")
  end
end
