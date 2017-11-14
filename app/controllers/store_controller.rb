class StoreController < ApplicationController
  include StoreHelper
  include CurrentCart
  before_action :set_cart
  before_action :set_store_visit_count, only: :index

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
    @count = session[:count]
  end
end
