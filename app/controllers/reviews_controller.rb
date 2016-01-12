class ReviewsController < ApplicationController
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def edit
    @review = Review.find(params[:id])
  end

  def create
    @review = @movie.reviews.new(review_params)
    respond_to do |format|
      if @review.save
        format.html { redirect_to movie_reviews_path(@movie), notice: "Thanks for your review!" }
        format.js # render views/reviews/create.js.erb by default
      else
        format.html { render :new }
        format.js { render 'errors.js.erb' }
      end
    end
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to movie_reviews_path(@movie), notice: "Review successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to movie_reviews_path(@movie), alert: "Review successfully deleted!"
  end

  private
    def review_params
      params.require(:review).permit(:name, :location, :stars, :comment)
    end

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end
end
