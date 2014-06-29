class ApplicationController < ActionController::Base
  protect_from_forgery

  def index

  end

  def recent

  end

  def chart
    if params[:start_date]
      @from = params[:start_date]+" 00:00:01"
      @to = params[:end_date]+" 23:59:59"
    end
  end

end
