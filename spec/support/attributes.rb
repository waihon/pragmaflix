def movie_attributes(overrides = {})
  {
    title: "Iron Man",
    rating: "PG-13",
    total_gross: 318_412_101.00,
    description: "Tony Stark builds an armored suit to fight the throes of evil",
    released_on: "2008-05-02",
    cast: "Robert Downey Jr., Gwyneth Paltrow and Terrence Howard",
    director: "Jon Favreau",
    duration: "126 min",
    #image_file_name: "ironman.jpg"
    image: open("#{Rails.root}/app/assets/images/ironman.jpg")
  }.merge(overrides)
end

def review_attributes(overrides = {})
  {
    # The name is part of the signed in user
    #name: "Roger Ebert",
    stars: 3,
    comment: "I laughed, I cried, I spilled my popcorn!",
    location: "Dallas, TX"
  }.merge(overrides)
end

def user_attributes(overrides = {})
  {
    name: "Example User", 
    username: "example48",
    email: "user@example.com",
    password: "secretgarden",
    password_confirmation: "secretgarden"
  }.merge(overrides)
end

def genre_attributes(overrides = {})
  {
    name: "Action"
  }.merge(overrides)
end