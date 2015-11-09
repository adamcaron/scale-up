class CategoriesController < ApplicationController
  def index
    @categories = Category.paginate(:page => params[:page], :per_page => 9)
  end

  def show
    @category = Category.find(params[:id])
    @loan_requests = LoanRequest.joins(:categories)
      .where(categories: { id: @category.id } )
      .paginate(:page => params[:page], :per_page => 9)
  end
end
