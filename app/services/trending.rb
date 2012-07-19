class TrendingService
  def get_top_items(limit)
  end

  def popular_articles(not_this_article, user, limit)
    all_articles = Article.filter({})
    filtered_articles = all_articles.reject {|a| a.id == not_this_article.id}
    filtered_articles = filtered_articles.take(limit) if limit
    filtered_articles
  end
end

