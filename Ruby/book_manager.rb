require 'json'                 # Load JSON library for reading/writing to the data file
require_relative 'book'        # Load the Book class from book.rb

class BookManager
  DATA_FILE = "books.json"     # File to store book data in JSON format

  attr_reader :books           # Allow external read-only access to @books

  def initialize
    @books = load_books        # When a new BookManager is created, load books from file
  end

  # Add a new book and save to file
  def add_book(book)
    @books << book             # Add the Book object to the in-memory list
    save_books                 # Save the updated list to the JSON file
  end

  # Remove a book by its title (case-insensitive)
  def remove_book_by_title(title)
    @books.reject! { |b| b.title.downcase == title.downcase }  # Remove all books matching the title
    save_books                 # Save changes to the JSON file
  end

  # Search books by any attribute (title, author, genre)
  def search_by(attribute, term)
    term = term.downcase       # Make search case-insensitive
    @books.select do |book|
      book.send(attribute).to_s.downcase.include?(term)  # Dynamically call the attribute (e.g., book.title)
    end
  end

  # Load books from the JSON file and convert each hash into a Book object
  def load_books
    return [] unless File.exist?(DATA_FILE)  # If file doesn't exist, return empty list
    JSON.parse(File.read(DATA_FILE), symbolize_names: true)
        .map { |h| Book.from_hash(h) }       # Convert each JSON hash back into a Book object
  rescue
    []                                       # In case of error (e.g., corrupted file), return empty list
  end

  # Save the current @books list to the JSON file
  def save_books
    File.write(DATA_FILE, JSON.pretty_generate(@books.map(&:to_hash)))  # Convert each Book to a hash, then to JSON
  end
end
