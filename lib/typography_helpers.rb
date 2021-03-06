require "redcarpet"
require "lib/redcarpet_renderers"

module TypographyHelpers
  def md(text)
    text = text.to_s

    renderer = Redcarpet::Render::HTML.new

    markdown = Redcarpet::Markdown.new(
      renderer,
      no_intra_emphasis: true
    )

    markdown.render(text)
  end

  def md_line(text)
    text = text.to_s

    renderer = Redcarpet::Render::HTMLWithoutBlockElements.new(filter_html: true)

    markdown = Redcarpet::Markdown.new(
      renderer,
      no_intra_emphasis: true,
    )

    markdown.render(text)
  end

  def underscore(word)
    word = word.to_s.dup
    word.gsub!('::', '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.gsub!(/-/, "_")
    word.downcase!
    word
  end

  def dasherize(word)
    word = underscore(word)
    word.gsub!(/_/, "-")
  end

  def format_date_string(string, format)
    if string.match(/\d{2}\/\d{2}\/\d{4}/)
      date = DateTime.strptime(string, "%d/%m/%Y")
      date.strftime(format)
    else
      string
    end
  end

  def widont(text)
    # Only make the final space non-breaking if the final
    # two words fit within 20 characters.
    if text.length > 20 && text[-20..-1][/\s+\S+\s+\S+$/].nil?
      text
    else
      text.gsub /\s+(?=\S+$)/, "&nbsp;"
    end
  end

  def sanitize(html, allow_tags = "p i em strong br code", allow_attributes = {})
    Sanitize.fragment(html, Sanitize::Config.merge(Sanitize::Config::RESTRICTED,
      :elements => allow_tags.split(" "),
      :attributes => allow_attributes
    ))
  end
end
