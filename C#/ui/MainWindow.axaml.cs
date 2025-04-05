using System;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Book_Cataloging_System.core;
using Book_Cataloging_System.models;
namespace Book_Cataloging_System.ui;

public partial class MainWindow : Window
{
    private BookCatalog _catalog;

    public MainWindow()
    {
        InitializeComponent();
        _catalog = new BookCatalog();
    }

    private void InitializeComponent()
    {
        AvaloniaXamlLoader.Load(this);
    }

    private void AddBookButton_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        string title = this.FindControl<TextBox>("TitleTextBox").Text;
        string author = this.FindControl<TextBox>("AuthorTextBox").Text;
        string genre = this.FindControl<TextBox>("GenreTextBox").Text;
        int year = int.Parse(this.FindControl<TextBox>("YearTextBox").Text);

        var book = new Book
        {
            Title = title,
            Author = author,
            Genre = genre,
            PublicationYear = year
        };

        _catalog.AddBook(book);
        UpdateBookList(_catalog.GetAllBooks());
    }

    private void RemoveBookButton_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        var selectedIndex = this.FindControl<ListBox>("BooksListBox").SelectedIndex;
        if (selectedIndex != -1)
        {
            var selectedBook = this.FindControl<ListBox>("BooksListBox").SelectedItem as Book;
            if (selectedBook != null)
            {
                _catalog.RemoveBook(selectedBook);
                UpdateBookList();
            }
        }
        else
        {
            Console.WriteLine("Book not found");
        }
    }

    private void SearchButton_Click(object sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        string searchTerm = this.FindControl<TextBox>("SearchTextBox").Text;
        var results = _catalog.SearchByTitle(searchTerm);
        if (results.Count == 0)
        {
            results = _catalog.SearchByAuthor(searchTerm);
        }

        if (results.Count == 0)
        {
            results = _catalog.SearchByGenre(searchTerm);
        }

        UpdateBookList(results);
    }

    private void UpdateBookList(System.Collections.Generic.List<Book> books = null)
    {
        books = books ?? _catalog.GetBooksByGenre(string.Empty);
        var listBox = this.FindControl<ListBox>("BooksListBox");
        listBox.ItemsSource = books;
    }
}