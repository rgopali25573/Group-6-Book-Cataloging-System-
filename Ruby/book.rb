class Book
  # Allow reading and writing of title, author, genre, and year attributes from outside the class
  attr_accessor :title, :author, :genre, :year

  # Constructor: initializes a new Book object with given attributes
  def initialize(title, author, genre, year)
    @title = title     # Title of the book (String)
    @author = author   # Author of the book (String)
    @genre = genre     # Genre/category of the book (String)
    @year = year       # Publication year (could be String or Integer)
  end

  # Converts the Book object into a Hash for saving to a JSON file
  def to_hash
    {
      title: @title,
      author: @author,
      genre: @genre,
      year: @year
    }
  end

  # Class method: creates a Book object from a hash (used when loading from file)
  def self.from_hash(hash)
    new(hash[:title], hash[:author], hash[:genre], hash[:year])
  end

  # Provides a human-readable string representation of the Book object
  def to_s
    "#{title} by #{author} (#{genre}, #{year})"
  end
end
