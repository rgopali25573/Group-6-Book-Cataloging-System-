# This repo is for the Group 6 Residency Project - Book Catalog System
## 📚 Book Cataloging System (Ruby + GTK3) Implementation

There are a total of five files for the ruby implementation. Where,
- **book.rb** Defines what a book is, its attributes, and how it can be converted to/from JSON-friendly format.
- **book_manager.rb** loading and saving data from **books.json** and adding, removing, and searching attributes.
- **cli.rb** is the CLI(Command Line Interface) of the program where the user can choose from the options.
- **gui.rb** is the implementation of graphical interface using The **GTK3** GUI App.
- **books.json** is the data storage file for the books.

A GUI-based Book Cataloging System built with **Ruby** and **GTK3**, designed to help users manage a collection of books with features to add, remove, update, and search books by various attributes. The system also supports persistent storage and includes a visually enhanced interface.

---
### How To Run
- For CLI implementation, run the bash command **ruby cli.rb**. After running the command, the user needs to select an option from the list and can add, remove, or search from it. 
- For GUI implementation, run the bash command **ruby gui.rb**. After running the code, a GUI window for the book cataloging system will pop up.
---

### ✨ Features

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
A GUI-based application built with **C# and Avalonia UI** to manage a personal or small library book catalog. It allows users to **add**, **remove**, **search**, and **list** books based on attributes such as **title**, **author**, **genre**, and **publication year**.
---
### 🚀 Features
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
### 🧠 Technologies Used
- **C#**: Core programming language
- **Avalonia UI**: Cross-platform GUI framework
- **LINQ**: For efficient and expressive data querying and filtering
- **.NET Core / .NET 6+**: Runtime environment
- **Text File Storage**: Simple file-based system for saving book data
---
### 💾 Book Storage
All book entries are stored in a plain text file (`books.txt`) located within the project directory or application data folder. Each line in the file represents a book in the following format:

# Running C# Avalonia UI Project with JetBrains Rider

This guide will walk you through setting up and running a C# Avalonia UI project in JetBrains Rider.

## Prerequisites

Before starting, ensure you have the following installed on your system:

- **JetBrains Rider** - The IDE used for C# development.
- **.NET SDK** - You can download it from [here](https://dotnet.microsoft.com/download/dotnet).
- **Avalonia** - Avalonia is a cross-platform UI framework for .NET.

## Steps to Run the Project

**Clone the Repository (If applicable)**
Clone the project using:
- git clone https://github.com/rgopali25573/Group-6-Book-Cataloging-System-
- cd your-project-folder
- open it in JetBrains Rider
- click on Run
