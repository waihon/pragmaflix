describe FavoritesController do
  before do
    @movie = Movie.create!(movie_attributes)
  end

  context "when not signed in" do
    before do
      session[:user_id] = nil
    end

    it "cannot access create" do
      post :create, movie_id: @movie

      expect(response).to redirect_to(signin_url)
    end

    it "cannot access destroy" do
      delete :destroy, movie_id: @movie, id: 1

      expect(response).to redirect_to(signin_url)
    end    
  end
end