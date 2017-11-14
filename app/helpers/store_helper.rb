module StoreHelper


  private

  def set_store_visit_count
    if session[:count].present?
      session[:count]+=1
    else
      session[:count]=1
    end
  end

  def reset_store_visit_count
    session[:count]=nil
  end

end
