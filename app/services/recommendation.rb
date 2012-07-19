
class RecommendationService
  def find_next_articles(article, user, limit=nil)
    all_articles_for_event = article.main_event.get_all_articles
    all_articles_for_event.reject! {|art| art == article}
    all_articles_for_event = all_articles_for_event.take(limit) if limit
    all_articles_for_event
  end
end
