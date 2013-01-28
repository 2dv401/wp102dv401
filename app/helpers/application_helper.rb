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

  # En hjälpmetod för att lägga till edit-länk i top-bar
  def top_bar_edit_map_link(map = nil)
    if map.present?
      link =  link_to "Edit karta...", edit_profile_map_path(map.user.slug, map.slug)
      content_for :edit_map_link, link
    else
      content_for?(:edit_map_link) ? raw('<li>' + content_for(:edit_map_link) + '</li>') : ''
    end
  end

  # En hjälpmetod för att lägga till destroy-länk i top-bar
  def top_bar_delete_map_link(map = nil)
    if map.present?
      link = link_to "Ta bort kartan", profile_map_path(@map.user.slug, @map.slug), :method=>:delete, :confirm=>"Vill du ta bort kartan?"
      content_for :delete_map_link, link
    else
      content_for?(:delete_map_link) ? raw('<li>' + content_for(:delete_map_link) + '</li>') : ''
    end
  end

  # DateTime formaterare
  def time_ago(time_format = nil)
    now = Time.now
    time = time_format
    months = ["Januari", "Februari", "Mars","April", "Maj", "Juni", "Juli", "Augusti", "September", "Oktober", "November", "December"]
    month = months[time.month - 1]

    # Är det idag?
    if time.today?
      time.strftime("idag kl. %H:%M")

    # Är det igar?
    elsif time.day == now.yesterday.day
      time.strftime("igar kl. %H:%M")

    # Är det iår?
    elsif time.year == now.year
      time.strftime("den %d "+ month +" kl. %H:%M")

    else
      time.strftime("den %d "+ month +" %Y kl. %H:%M")
    end
  end

  def format_text(text)
    text.gsub!(/\:\-?\)/, '<span class="emoticon smile"></span>')
    text.gsub!(/\;\-?\)/, '<span class="emoticon blink"></span>')
    text.gsub!(/\<\-?3/, '<span class="emoticon heart"></span>')
    text.html_safe
  end
end