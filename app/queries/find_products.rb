class FindProducts
  attr_reader :products

  def initialize(products = nil)
    @products = products || initial_scope
  end

  def call(params = {})
    scoped = products
    scoped = filter_by_category_id(scoped, params[:category_id])
    scoped = filter_by_min_price(scoped, params[:min_price])
    scoped = filter_by_max_price(scoped, params[:max_price])
    scoped = filter_by_query_text(scoped, params[:query_text])

    sort(scoped, params[:order_by])
  end

  private

  def initial_scope
    Product.with_attached_image
  end

  def filter_by_category_id(scoped, category_id)
    return scoped unless category_id.present?

    scoped.where(category_id:)
  end

  def filter_by_min_price(scoped, min_price)
    return scoped unless min_price.present?

    scoped.where('price >= ?', min_price)
  end

  def filter_by_max_price(scoped, max_price)
    return scoped unless max_price.present?

    scoped.where('price <= ?', max_price)
  end

  def filter_by_query_text(scoped, query_text)
    return scoped unless query_text.present?

    scoped.where('title LIKE ?', "%#{query_text}%")
  end

  def sort(scoped, order_by)
    order_by_query = {
      newest: 'created_at DESC',
      expensive: 'price DESC',
      cheapest: 'price ASC'
    }.fetch(order_by&.to_sym, 'created_at DESC')

    scoped.order(order_by_query)
  end
end
