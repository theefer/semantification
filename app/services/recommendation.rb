
class RecommendationService
  def initialize
  end

  def find_next_articles(article, user)
    all_articles_for_event = article.main_event.get_all_articles
    all_articles_for_event.reject {|art| art == article}
  end
end
