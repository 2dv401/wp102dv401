module ApplicationHelper

	# En hjälpmetod för att lägga till information i titeln
  def title(title = nil)
    if title.present?
      content_for :title, title
    else
      content_for?(:title) ? APP_CONFIG['default_title'] + ' | ' + content_for(:title) : APP_CONFIG['default_title']
    end
  end

  # En hjälpmetod för att lägga till meta-author
  def meta_author(authors = nil)
    if authors.present?
      content_for :meta_author, authors
    else
      content_for?(:meta_author) ? [content_for(:meta_author), APP_CONFIG['meta_author']].join(', ') : APP_CONFIG['meta_author']
    end
  end

  # En hjälpmetod för att lägga till meta-keywords
  def meta_keywords(tags = nil)
    if tags.present?
      content_for :meta_keywords, tags
    else
      content_for?(:meta_keywords) ? [content_for(:meta_keywords), APP_CONFIG['meta_keywords']].join(', ') : APP_CONFIG['meta_keywords']
    end
  end

  # En hjälpmetod för att lägga till meta-description
  def meta_description(desc = nil)
    if desc.present?
      content_for :meta_description, desc
    else
      content_for?(:meta_description) ? content_for(:meta_description) : APP_CONFIG['meta_description']
    end
  end
end