using System.IO;
using Book_Cataloging_System.models;

namespace Book_Cataloging_System.core;

using System;
using System.Collections.Generic;
using System.Linq;

public class BookCatalog
{
    private List<Book> _books;
    private static readonly string FilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Data", "books.txt");
    
    public BookCatalog()
    {
        _books = new List<Book>();
        LoadFromFile();
    }

    public void AddBook(Book book)
    {
        _books.Add(book);
        SaveToFile();
    }

    public void RemoveBook(Book book)
    {
        _books.Remove(book);
        SaveToFile();
    }

    public List<Book> SearchByTitle(string title)
    {
        return _books.Where(b => b.Title.Contains(title, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public List<Book> SearchByAuthor(string author)
    {
        return _books.Where(b => b.Author.Contains(author, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public List<Book> GetAllBooks()
    {
        return _books.Select(b => b).ToList();
    }

    public List<Book> SearchByGenre(string genre)
    {
        return _books.Where(b => b.Genre.Contains(genre, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public List<Book> GetBooksByAuthor(string author)
    {
        return _books.Where(b => b.Author.Equals(author, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public List<Book> GetBooksByGenre(string genre)
    {
        return _books.Where(b => b.Genre.Equals(genre, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    private void SaveToFile()
    {
        Directory.CreateDirectory(Path.GetDirectoryName(FilePath)!); // Ensure directory exists
        using StreamWriter writer = new StreamWriter(FilePath);
        foreach (var book in _books)
        {
            writer.WriteLine(book.Title + "," + book.Author + "," + book.Genre + "," + book.PublicationYear);
        }
    }

    private void LoadFromFile()
    {
        if (!File.Exists(FilePath))
            return;

        _books.Clear();
        foreach (var line in File.ReadLines(FilePath))
        {
            var parts = line.Split(",");
            if (parts.Length == 4)
            {
                var book = new Book
                {
                    Title = parts[0],
                    Author = parts[1],
                    Genre = parts[2],
                    PublicationYear = Convert.ToInt32(parts[3])
                };
                _books.Add(book);
            }
        }
    }

    
}
