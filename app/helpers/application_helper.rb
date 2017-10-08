module ApplicationHelper

  # Set title
  def full_title(page_title = '')
    base_title = "ProfRate - Rate your professors"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # Set active class in navbar
  def is_active?(link_path)
    current_page?(link_path) ? "active" : ""
  end
end
