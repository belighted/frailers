xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title("Frailers.net")
    xml.link("http://www.frailers.net/articles.rss")
    xml.description("Ressources Ruby on Rails en Français")
    xml.pubDate @articles.first.published_at.rfc822
    xml.lastBuildDate @articles.first.published_at.rfc822
    xml.language('fr')
    for article in @articles
      xml.item do
        xml.title article.title
        xml.description "#{article.summary} #{article.content_with_code}"
        xml.pubDate article.published_at.rfc822
        xml.link("http://www.frailers.net/articles/" + article.to_param)
        xml.guid("http://www.frailers.net/articles/" + article.to_param)
      end
    end
  end
end