class GenresController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  def index
    @genres = Genre.all.order(:name)
  end

  def show
    # Moved to set_genre
    #@genre = Genre.find(params[:id])
    @movies = @genre.movies
  end

  def edit
    # Moved to set_genre
    #@genre = Genre.find(params[:id])
  end

  def update
    # Moved to set_genre
    #@genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to @genre, notice: "Genre successfully updated!"
    else
      render :edit
    end
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to @genre, notice: "Genre was successfully created!"
    else
      render :new
    end
  end

  def destroy
    # Moved to set_genre
    #@genre = Genre.find(params[:id])
    @genre.destroy
    redirect_to genres_url, alert: "Genre successfully deleted!"
  end

  private

    def genre_params
      params.require(:genre).permit(:name, :slug)
    end

    def set_genre
      @genre = Genre.find_by(slug: params[:id])
    end
end
