#require "spec_helper"

describe "Viewing an individual movie" do
  it "show the movie's details" do
    # Arrange
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
    expect(page).to have_selector("img[src$='#{movie.image.url(:small)}']")
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

  it "shows the movie's fans and genres in the side bar" do
    # Arrange
    movie = Movie.create!(movie_attributes)
    fan1 = User.create!(user_attributes(name: "Joe", username: "joe", email: "joe@example.com"))
    fan2 = User.create!(user_attributes(name: "Mary", username: "mary", email: "mary@example.com"))
    genre1 = Genre.create!(genre_attributes(name: "Action"))
    genre2 = Genre.create!(genre_attributes(name: "Comedy"))
    movie.fans << fan1
    movie.genres << genre1

    # Action
    visit movie_url(movie)

    # Assert
    within("aside#sidebar") do
      expect(page).to have_text(fan1.name)
      expect(page).not_to have_text(fan2.name)
      expect(page).to have_text(genre1.name)
      expect(page).not_to have_text(genre2.name)
    end
  end

  it "shows the movie's title in the page title" do
    # Arrange
    movie = Movie.create!(movie_attributes(title: "Iron Man"))

    # Action
    visit movie_url(movie)

    # Assert
    expect(page).to have_title("Flix - #{movie.title}")
  end

  it "has an SEO-friendly URL" do
    # Arrange
    movie = Movie.create!(movie_attributes(title: "X-Men: the Last Stand"))

    # Action
    visit movie_url(movie)

    # Assert
    expect(current_path).to eq("/movies/x-men-the-last-stand")
  end
end