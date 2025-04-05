# This repo is for Group 6 Residency Project.(Book Catalog System)
## 📚 Book Cataloging System (Ruby + GTK3) Implementation

There are total five files for the ruby implementation. Where,
- **book.rb** is Defines what a book is, what attributes it holds, and how it can be converted to/from JSON-friendly format.
- **book_manager.rb** loading and saving data from **books.json** as well as adding, removing and searching attributes.
- **cli.rb** is the CLI(Command Line Interface) of the program where user can pick a choice from the option.
- **gui.rb** is the implementation of graphical interface using The **GTK3** GUI App.

A GUI-based Book Cataloging System built with **Ruby** and **GTK3**, designed to help users manage a collection of books with features to add, remove, update, and search books by various attributes. The system also supports persistent storage and includes a visually enhanced interface.

---

## ✨ Features

- Add new books with title, author, genre, and year
- Remove or update existing books
- Search books by Title, Author, Genre, or Year
- Show all books
- Input validation (e.g., numeric year)
- Data persistence using file storage
- Scrollable book list display
- Visual enhancements with labels, icons, and organized layout

---

  

## 📚 Book Cataloging System C# Implementation
A GUI-based application built with **C# and Avalonia UI** to manage a personal or small library book catalog. It allows users to **add**, **remove**, **search**, and **list** books based on various attributes such as **title**, **author**, **genre**, and **publication year**.
---
## 🚀 Features
- Add new books with details: Title, Author, Genre, and Publication Year.
- Remove existing books from the catalog.
- Search for books by:
 - Title
 - Author
 - Genre
- View the full list of books.
- Display books grouped by author or genre for simple reporting.
- **Persistent storage** using a local text file to save and load the catalog.
---
## 🧠 Technologies Used
- **C#**: Core programming language
- **Avalonia UI**: Cross-platform GUI framework
- **LINQ**: For efficient and expressive data querying and filtering
- **.NET Core / .NET 6+**: Runtime environment
- **Text File Storage**: Simple file-based system for saving book data
---
## 💾 Book Storage
All book entries are stored in a plain text file (`books.txt`) located within the project directory or application data folder. Each line in the file represents a book in the following format:
