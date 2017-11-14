module ApplicationHelper
  def render_if(condition, &block)
    if condition
      yield
    end
  end
end
