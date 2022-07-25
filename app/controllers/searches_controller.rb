class SearchesController < ApplicationController
  before_action :authenticate_user!

    def search
        @model = params[:model]
        @content = params[:content]
        @method = params[:method]
        @records = Tag.search_books_for(@content, @method)
    end

end