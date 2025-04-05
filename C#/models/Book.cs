namespace Book_Cataloging_System.models;

public class Book
{
    public string Title { get; set; }
    public string Author { get; set; }
    public string Genre { get; set; }
    public int PublicationYear { get; set; }
    
    public override string ToString() 
    {
        return $"{Title} by {Author} ({PublicationYear})";
    }
}