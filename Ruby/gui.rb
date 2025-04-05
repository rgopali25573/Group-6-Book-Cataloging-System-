require 'gtk3'
require_relative 'book'
require_relative 'book_manager'

class BookCatalogGUI
  def initialize
    @manager = BookManager.new  # Initialize BookManager to handle book data

    # Create main window for the application
    @window = Gtk::Window.new("📚 Book Catalog System")
    @window.set_size_request(800, 600)  # Set window size
    @window.signal_connect("destroy") { Gtk.main_quit }  # Close application on window close

    grid = Gtk::Grid.new
    grid.set_row_spacing(10)  # Set row spacing in the grid
    grid.set_column_spacing(10)  # Set column spacing in the grid
    grid.set_margin_top(10)  # Set margin at the top
    grid.set_margin_bottom(10)  # Set margin at the bottom
    grid.set_margin_start(140)  # Set left margin
    grid.set_margin_end(20)  # Set right margin

    # Create entry fields for book details
    @title_entry = Gtk::Entry.new; @title_entry.placeholder_text = "Title"
    @genre_entry = Gtk::Entry.new; @genre_entry.placeholder_text = "Genre"
    @author_entry = Gtk::Entry.new; @author_entry.placeholder_text = "Author"
    @year_entry = Gtk::Entry.new; @year_entry.placeholder_text = "Year"

    # Create buttons for adding, removing, and updating
    add_button = Gtk::Button.new(label: "➕  Add Book")
    add_button.signal_connect("clicked") { add_book }

    remove_button = Gtk::Button.new(label: "🗑️  Remove Book")
    remove_button.signal_connect("clicked") { remove_book }

    update_button = Gtk::Button.new(label: "✏️  Update Book")
    update_button.signal_connect("clicked") { update_book }

    # Create search entry and combo box for search by attribute
    @search_entry = Gtk::Entry.new
    @search_combo = Gtk::ComboBoxText.new
    %w[Title Author Genre Year].each { |attr| @search_combo.append_text(attr) }
    @search_combo.set_active(0)

    # Create search and clear buttons with icons
    search_button = Gtk::Button.new(label: "🔍  Search")
    search_button.signal_connect("clicked") { search_books }

    clear_button = Gtk::Button.new(label: "📄  Show All")
    clear_button.signal_connect("clicked") { update_display(@manager.books) }

    # Create a label for the "Book List"
    book_list_label = Gtk::Label.new
    book_list_label.set_markup("<span weight='bold' size='medium'>📚 Book List</span>")
    book_list_label.set_justify(:center)  # Center-align the label text

    # Create ListBox to display books in a list with selectable rows
    @list_box = Gtk::ListBox.new
    @list_box.signal_connect("row-selected") { |_, row| on_row_selected(row) }

    # Layout: Arrange elements on the grid
    grid.attach(@title_entry, 0, 0, 3, 1)
    grid.attach(@genre_entry, 0, 1, 3, 1)
    grid.attach(@author_entry, 0, 2, 3, 1)
    grid.attach(@year_entry, 0, 3, 3, 1)
    grid.attach(add_button, 0, 4, 1, 1)
    grid.attach(remove_button, 1, 4, 1, 1)
    grid.attach(update_button, 2, 4, 1, 1)
    grid.attach(Gtk::Label.new("Search:"), 0, 5, 1, 1)
    grid.attach(@search_entry, 1, 5, 1, 1)
    grid.attach(@search_combo, 2, 5, 1, 1)
    grid.attach(search_button, 1, 6, 1, 1)
    grid.attach(clear_button, 2, 6, 1, 1)
    grid.attach(Gtk::Label.new(" "), 0, 7, 3, 1)  # Empty row for spacing
    grid.attach(book_list_label, 0, 8, 3, 1)  # Attach label at grid position (0, 7), spanning 3 columns

    # Create a ScrolledWindow to display the ListBox
    scrolled = Gtk::ScrolledWindow.new
    scrolled.set_policy(:automatic, :automatic) # Set scroll policy to automatically show scrollbars when needed
    scrolled.set_size_request(500, 200) # Set the desired width and height for the book list display
    scrolled.add(@list_box) # Add the ListBox to the ScrolledWindow
    grid.attach(scrolled, 0, 9, 3, 5) # Attach the ScrolledWindow to the grid layout


    @window.add(grid)
    @window.show_all

    update_display(@manager.books)  # Initially load and display all books
  end

  # Method to add a new book to the catalog
  def add_book
    # Validate the year input to ensure it's numeric
    year = @year_entry.text.strip
    unless year.match?(/^\d+$/)
      show_error("Invalid year. Please enter a valid numeric year.")  # Display error if year is not valid
      return
    end

    # Create a new Book instance using data from the input fields
    book = Book.new(
      @title_entry.text.strip,
      @author_entry.text.strip,
      @genre_entry.text.strip,
      year
    )
    # Skip if title or author is empty
    return if book.title.empty? || book.author.empty?

    # Add the new book and update the display
    @manager.add_book(book)
    update_display(@manager.books)
    clear_entries
  end

  # Method to remove the selected book from the catalog
  def remove_book
    # Ensure a book is selected before removing
    return unless @selected_book

    # Remove the book from the manager and update the display
    @manager.remove_book_by_title(@selected_book.title)
    update_display(@manager.books)
    clear_entries
  end

  # Method to update the details of the selected book
  def update_book
    # Ensure a book is selected before updating
    return unless @selected_book

    # Validate the year input to ensure it's numeric
    year = @year_entry.text.strip
    unless year.match?(/^\d+$/)
      show_error("Invalid year. Please enter a valid numeric year.")  # Display error if year is not valid
      return
    end

    # Update the selected book with the new data from input fields
    @selected_book.title = @title_entry.text.strip
    @selected_book.author = @author_entry.text.strip
    @selected_book.genre = @genre_entry.text.strip
    @selected_book.year = year

    # Save the updated book data and refresh the display
    @manager.save_books
    update_display(@manager.books)
    clear_entries
  end

  # Method to search for books based on the selected attribute and search term
  def search_books
    attr = @search_combo.active_text.downcase  # Get the selected search attribute
    term = @search_entry.text.strip  # Get the search term
    results = @manager.search_by(attr, term)  # Get search results from manager
    update_display(results)  # Display the search results
  end

  # Method to update the displayed list of books in the ListBox
  def update_display(book_list)
    @list_box.each { |child| @list_box.remove(child) }  # Clear the existing list
    # Add each book as a row in the ListBox
    book_list.each_with_index do |book, i|
      row = Gtk::ListBoxRow.new
      label = Gtk::Label.new("#{i+1}. #{book}")
      label.set_xalign(0)  # Align label text to the left
      row.add(label)
      row.instance_variable_set(:@book_data, book)  # Store book data in the row
      @list_box.add(row)
    end
    @list_box.show_all  # Refresh the display
  end

  # Method to handle when a row (book) is selected in the ListBox
  def on_row_selected(row)
    return unless row

    # Retrieve the book associated with the selected row
    @selected_book = row.instance_variable_get(:@book_data)

    # Autofill the input fields with the selected book's data
    @title_entry.text = @selected_book.title
    @genre_entry.text = @selected_book.genre
    @author_entry.text = @selected_book.author
    @year_entry.text = @selected_book.year
  end

  # Method to display error messages in a dialog
  def show_error(message)
    dialog = Gtk::MessageDialog.new(
      @window,
      :modal,
      :error,
      :close,
      message
    )
    dialog.run
    dialog.destroy
  end

  # Method to clear the input fields
  def clear_entries
    @title_entry.text = ""
    @author_entry.text = ""
    @genre_entry.text = ""
    @year_entry.text = ""
  end
end

Gtk.init
BookCatalogGUI.new  # Create and run the BookCatalogGUI application
Gtk.main  # Start the GTK main loop
