#require "spec_helper"

describe "Viewing an individual movie" do
  it "show the movie's details" do
    # Arrange
    #movie = Movie.create(movie_attributes(total_gross: 300000000.00))    
    #movie = Movie.create(movie_attributes(image_file_name: "", total_gross: 300_000_000.00))
    movie = Movie.create(movie_attributes(image: open("#{Rails.root}/app/assets/images/movie.jpg"), 
        total_gross: 300_000_000.00))

    # Action
    visit movie_url(movie)

    # Assert
    expect(page).to have_text(movie.title)
    expect(page).to have_text(movie.description)
    expect(page).to have_text(movie.rating)
    expect(page).to have_text(movie.released_on)    
    expect(page).to have_text("$300,000,000.00")
    expect(page).to have_text(movie.cast)
    expect(page).to have_text(movie.director)
    expect(page).to have_text(movie.duration)
    #expect(page).to have_selector("img[src$='#{movie.image_file_name}']")
    expect(page).to have_selector("img[src$='#{movie.image.url}']")
  end

  it "shows a placeholder image when the movie image is not available" do
    movie = Movie.create(movie_attributes(image: nil))

    # Action
    visit movie_url(movie)

    # Assert
    expect(page).to have_text(movie.title)
    expect(page).to have_selector("img[src$='placeholder.png']")
    # src$='' somehow acts a wildcard for any img tag
    #expect(page).to have_selector("img[src$='']")
  end

  it "shows the total gross if the total gross is $50M or more" do
    # Arrange
    movie = Movie.create(movie_attributes(total_gross: 50_000_000))

    # Action
    visit movie_url(movie)

    # Assert
    expect(page).to have_text("$50,000,000.00")
  end

  it "shows 'Flop!' if the total gross is less than $50M" do
    # Arrange
    movie = Movie.create(movie_attributes(total_gross: 49_999_999.99))

    # Action
    visit movie_url(movie)

    # Assert
    expect(page).to have_text("Flop!")  
  end
end