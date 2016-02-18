class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    #@movies = Movie.released
    case params[:scope]
    when "hits"
      @movies = Movie.hits
    when "flops"
      @movies = Movie.flops
    when "upcoming"
      @movies = Movie.upcoming
    when "recent"
      @movies = Movie.recent(3)
    else
      @movies = Movie.released
    end
    @genres = Genre.all
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.recent_reviews
    @fans = @movie.fans
    if current_user
      @current_favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
    @genres = @movie.genres
  end
  
  def edit
    @movie = Movie.find(params[:id])
    @fans = @movie.fans
    @genres = @movie.genres
  end
  
  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params) 
      redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit
    end
  end

  def new
    @movie = Movie.new
    @fans = []
    @genres = []
  end
  
  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie was successfully created!"
    else
      render :new
    end
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_url, alert: "Movie successfully deleted!"
    #redirect_to movies_url, danger: "I'm sorry, Dave, I'm afraid I can't do that!"
  end
  
private

  def movie_params
  # Please note that genre_ids is not a symbol and it has to be initialized
  # with an empty array. 
    params.require(:movie).permit(:title, :description, :rating, :released_on, 
      :total_gross, :cast, :director, :duration, :image, genre_ids: [])
  end
end