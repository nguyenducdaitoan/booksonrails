class BooksController < ApplicationController
  def index
    @books = Book.order(:last_sales_rank)
  end
end
