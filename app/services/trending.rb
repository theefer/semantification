class TrendingService
  def get_top_items(limit)
    avalanche = Event.get_by_id('mont-blanc-avalanche')
    [avalanche]
  end

  def popular_articles(not_this_article, user, limit)
    all_articles = [
      Article.get_by_id('death-in-the-alps-in-the-high-places'),
      Article.get_by_id('david-cameron-daughter-pub-normal-sun'),
      Article.get_by_id('rebekah-brooks-milly-dowler-phone-hacking')
    ]
    filtered_articles = all_articles.reject {|a| a.id == not_this_article.id}
    filtered_articles = filtered_articles.take(limit) if limit
    filtered_articles
  end
end

