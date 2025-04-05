require 'json'
require_relative 'book'
require_relative 'book_manager'

manager = BookManager.new

# Menu function to display the CLI options to the user
def menu
  puts "\n📚 Book Catalog CLI"
  puts "1. Add Book"
  puts "2. Remove Book"
  puts "3. Search Books"
  puts "4. List All Books"
  puts "5. Exit"
  print "Choose an option: "
end

# Function to handle the year input, ensuring it's a numeric value
def get_year_input
  print "Year: "
  year = gets.chomp
  if year =~ /\A\d+\z/  # Ensure the year is numeric using a regex
    return year
  else
    puts "❌ Invalid year! Please enter a valid number."
    return get_year_input  # Recursively ask for valid input
  end
end

# Function to get non-empty input for fields like title, author, and genre
def get_non_empty_input(field_name)
  print "#{field_name}: "
  input = gets.chomp.strip
  if input.empty?  # Check if the input is empty
    puts "❌ #{field_name} cannot be empty!"  # Notify user of invalid input
    return get_non_empty_input(field_name)  # Recursively ask for valid input
  end
  input
end

loop do
  menu  # Display the menu to the user
  choice = gets.chomp  # Get user choice

  case choice
  when "1"  # Option 1: Add Book
    title = get_non_empty_input("Title")  # Ensure title is not empty
    author = get_non_empty_input("Author")  # Ensure author is not empty
    genre = get_non_empty_input("Genre")  # Ensure genre is not empty
    year = get_year_input  # Get and validate the year input

    # Create a new book object with the provided details
    book = Book.new(title, author, genre, year)
    manager.add_book(book)  # Add the book to the manager
    puts "✅ Book added successfully!"  # Confirm the addition

  when "2"  # Option 2: Remove Book
    title = get_non_empty_input("Enter the title to remove")  # Ensure title is not empty
    manager.remove_book_by_title(title)  # Remove the book by title
    puts "🗑️ Book removed if it existed."  # Confirm the removal

  when "3"  # Option 3: Search Books
    print "Search by (title/author/genre/year): "
    attr = gets.chomp.downcase  # Get search attribute and convert to lowercase

    unless %w[title author genre year].include?(attr)  # Validate the search attribute
      puts "❌ Invalid search attribute. Please choose from: title, author, genre, year."
      next  # Skip the rest of the loop and prompt for input again
    end

    term = get_non_empty_input("Search term")  # Ensure search term is not empty
    results = manager.search_by(attr, term)  # Perform the search

    # If no results are found, notify the user
    if results.empty?
      puts "❌ No results found."
    else
      # Display the search results
      puts "\n🔎 Results:"
      results.each_with_index do |book, i|
        puts "#{i+1}. #{book}"  # Display each book in the results
      end
    end

  when "4"  # Option 4: List All Books
    puts "\n📚 All Books:"
    if manager.books.empty?  # If no books are in the catalog, notify the user
      puts "❌ No books in the catalog."
    else
      # Display all the books in the catalog
      manager.books.each_with_index do |book, i|
        puts "#{i+1}. #{book}"
      end
    end

  when "5"  # Option 5: Exit
    puts "Exiting CLI. Bye!"  # Confirm exit and end the loop
    break  # Exit the loop, terminating the program

  else  # Invalid option handling
    puts "❌ Invalid option. Try again."  # Notify the user of invalid input
  end
end
