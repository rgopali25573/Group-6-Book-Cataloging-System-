using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Book_Cataloging_System.core;
using Book_Cataloging_System.models;
using MsBox.Avalonia;
using MsBox.Avalonia.Enums;

namespace Book_Cataloging_System.ui
{
    public partial class MainWindow : Window
    {
        private readonly BookCatalog _catalog;

        private TextBox _titleTextBox;
        private TextBox _authorTextBox;
        private TextBox _genreTextBox;
        private TextBox _yearTextBox;
        private TextBox _searchTextBox;
        private ListBox _booksListBox;

        public MainWindow()
        {
            InitializeComponent();
            _catalog = new BookCatalog();
            InitializeControls();
            UpdateBookList();
        }

        private void InitializeComponent()
        {
            AvaloniaXamlLoader.Load(this);
        }

        private void InitializeControls()
        {
            _titleTextBox = this.FindControl<TextBox>("TitleTextBox")!;
            _authorTextBox = this.FindControl<TextBox>("AuthorTextBox")!;
            _genreTextBox = this.FindControl<TextBox>("GenreTextBox")!;
            _yearTextBox = this.FindControl<TextBox>("YearTextBox")!;
            _searchTextBox = this.FindControl<TextBox>("SearchTextBox")!;
            _booksListBox = this.FindControl<ListBox>("BooksListBox")!;
        }

        private void AddBookButton_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
        {
            if (!Validate()) return;

            var book = new Book
            {
                Title = _titleTextBox.Text,
                Author = _authorTextBox.Text,
                Genre = _genreTextBox.Text,
                PublicationYear = int.Parse(_yearTextBox.Text)
            };

            _catalog.AddBook(book);
            ShowMessage("Success", "Book added successfully.", MsBox.Avalonia.Enums.Icon.Success);
            UpdateBookList();
        }

        private bool Validate()
        {
            if (!IsValidInput(_titleTextBox, "Please enter a title")) return false;
            if (!IsValidInput(_authorTextBox, "Please enter an Author")) return false;
            if (!IsValidInput(_genreTextBox, "Please enter a Genre")) return false;

            string yearText = _yearTextBox.Text;
            if (!IsValidInput(_yearTextBox, "Please enter a Year")) return false;
            if (!int.TryParse(yearText, out int year))
            {
                ShowMessage("Error", "Please enter a valid Year", MsBox.Avalonia.Enums.Icon.Error);
                return false;
            }

            return true;
        }

        private bool IsValidInput(TextBox textBox, string errorMessage)
        {
            if (string.IsNullOrEmpty(textBox.Text))
            {
                ShowMessage("Error", errorMessage, MsBox.Avalonia.Enums.Icon.Error);
                return false;
            }

            return true;
        }

        private async void ShowMessage(string title, string message, Icon icon)
        {
            var messageBox = MessageBoxManager.GetMessageBoxStandard(title, message, ButtonEnum.Ok, icon);
            await messageBox.ShowWindowAsync();
        }

        private async void RemoveBookButton_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
        {
            var selectedBook = _booksListBox.SelectedItem as Book;

            if (selectedBook != null)
            {
                var result = await MessageBoxManager.GetMessageBoxStandard(
                    "Confirmation",
                    "Are you sure you want to remove this book?",
                    ButtonEnum.YesNo,
                    MsBox.Avalonia.Enums.Icon.Question).ShowWindowAsync();
                if (result == ButtonResult.Yes)
                {
                    _catalog.RemoveBook(selectedBook);
                    UpdateBookList();
                    ShowMessage("Success", "Book removed successfully.", MsBox.Avalonia.Enums.Icon.Success);
                }
            }
            else
            {
                ShowMessage("Error", "Please select a Book", MsBox.Avalonia.Enums.Icon.Error);
            }
        }

        private void SearchButton_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
        {
            string searchTerm = _searchTextBox.Text;
            if (string.IsNullOrEmpty(searchTerm))
            {
                ShowMessage("Error", "Please enter a search term", MsBox.Avalonia.Enums.Icon.Error);
                return;
            }

            var results = _catalog.SearchByTitle(searchTerm);

            if (results.Count == 0)
                results = _catalog.SearchByAuthor(searchTerm);

            if (results.Count == 0)
                results = _catalog.SearchByGenre(searchTerm);

            if (results.Count == 0)
            {
                ShowMessage("No Results", "No books found matching your search.", MsBox.Avalonia.Enums.Icon.Info);
            }

            UpdateBookList(results);
        }

        private void ShowAllBooksButton_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
        {
            UpdateBookList();
        }

        private void UpdateBookList(System.Collections.Generic.List<Book>? books = null)
        {
            books ??= _catalog.GetAllBooks();
            _booksListBox.ItemsSource = books;
        }
    }
}