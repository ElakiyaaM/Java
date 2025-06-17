CREATE DATABASE VirtualGallery;
USE VirtualGallery;

-- Create the Artists table
CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Biography TEXT,
    Nationality VARCHAR(100)
);

-- Create the Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- Create the Artworks table
CREATE TABLE Artworks (
    ArtworkID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistID INT,
    CategoryID INT,
    Year INT,
    Description TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create the Exhibitions table
CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Description TEXT
);

-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
    ExhibitionID INT,
    ArtworkID INT,
    PRIMARY KEY (ExhibitionID, ArtworkID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions(ExhibitionID),
    FOREIGN KEY (ArtworkID) REFERENCES Artworks(ArtworkID)
);

-- Insert sample data into Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- Insert sample data into Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);

-- 1. Retrieve artists with the number of artworks they have, in descending order
select A.Name, COUNT(AR.ArtworkID) as NumOfArtworks
from Artists A
join Artworks AR on A.ArtistID = AR.ArtistID
group by  A.ArtistID, A.Name
order by NumOfArtworks desc;

-- 2. List titles of artworks by Spanish and Dutch artists ordered by year
select AR.Title, AR.Year, A.Nationality
from Artworks AR
join Artists A on AR.ArtistID = A.ArtistID
where A.Nationality in ('Spanish', 'Dutch')
order by AR.Year asc;

-- 3. Artists who have artworks in the 'Painting' category with artwork count
select A.Name, COUNT(AR.ArtworkID) as PaintingCount
from Artists A
join Artworks AR on A.ArtistID = AR.ArtistID
join Categories C on AR.CategoryID = C.CategoryID
where C.Name = 'Painting'
group by A.Name;

-- 4. Names of artworks from 'Modern Art Masterpieces' with their artists and categories
select AR.Title, A.Name as ArtistName, C.Name as Category
from ExhibitionArtworks EA
join Artworks AR on EA.ArtworkID = AR.ArtworkID
join Artists A on AR.ArtistID = A.ArtistID
join Categories C on AR.CategoryID = C.CategoryID
join Exhibitions E on EA.ExhibitionID = E.ExhibitionID
where E.Title = 'Modern Art Masterpieces';

-- 5. Find artists with more than 2 artworks
select A.Name, COUNT(AR.ArtworkID) as ArtworkCount
from Artists A
join Artworks AR on A.ArtistID = AR.ArtistID
group by A.ArtistID
having COUNT(AR.ArtworkID) > 2;

-- 6. Artworks exhibited in BOTH 'Modern Art Masterpieces' and 'Renaissance Art'
select AR.Title
from Artworks AR
join ExhibitionArtworks EA1 on AR.ArtworkID = EA1.ArtworkID
join Exhibitions E1 on EA1.ExhibitionID = E1.ExhibitionID and E1.Title = 'Modern Art Masterpieces'
join ExhibitionArtworks EA2 on AR.ArtworkID = EA2.ArtworkID
join Exhibitions E2 on EA2.ExhibitionID = E2.ExhibitionID and E2.Title = 'Renaissance Art';

-- 7. Total number of artworks in each category
select C.Name, COUNT(AR.ArtworkID) as TotalArtworks
from Categories C
left join Artworks AR on C.CategoryID = AR.CategoryID
group by C.Name;

-- 8. Artists who have more than 3 artworks
select A.Name, COUNT(AR.ArtworkID) as ArtworkCount
from Artists A
join Artworks AR on A.ArtistID = AR.ArtistID
group by A.ArtistID
having COUNT(AR.ArtworkID) > 3;

-- 9. Artworks created by artists of a specific nationality (e.g., 'Spanish')
select AR.Title
from Artworks AR
join Artists A on AR.ArtistID = A.ArtistID
where A.Nationality = 'Spanish';

-- 10. Exhibitions that feature artworks by BOTH Vincent van Gogh and Leonardo da Vinci
select distinct E.Title
from Exhibitions E
join ExhibitionArtworks EA on E.ExhibitionID = EA.ExhibitionID
join Artworks AR on EA.ArtworkID = AR.ArtworkID
join Artists A on AR.ArtistID = A.ArtistID
where A.Name in ('Vincent van Gogh', 'Leonardo da Vinci')
group by E.Title
having COUNT(distinct A.Name) = 2;

-- 11. Artworks not included in any exhibition
select AR.Title
from Artworks AR
left join ExhibitionArtworks EA on AR.ArtworkID = EA.ArtworkID
where EA.ExhibitionID is null;

-- 12. Artists who have created artworks in all available categories
select A.Name
from Artists A
join Artworks AR on A.ArtistID = AR.ArtistID
join Categories C on AR.CategoryID = C.CategoryID
group by A.ArtistID, A.Name
having COUNT(distinct C.CategoryID) = (select COUNT(*) from Categories);

-- 13. Total number of artworks in each category
select C.Name, COUNT(AR.ArtworkID) as ArtworkCount
from Categories C
left join Artworks AR on C.CategoryID = AR.CategoryID
group by C.Name;

-- 14. Artists who have more than 2 artworks in the gallery
select A.Name, COUNT(AR.ArtworkID) as ArtworkCount
from Artists A
join Artworks AR on A.ArtistID = AR.ArtistID
group by A.ArtistID
having COUNT(AR.ArtworkID) > 2;

-- 15. Categories with the average year of their artworks (only if more than 1 artwork)
select C.Name, avg(AR.Year) as AvgYear
from Categories C
join Artworks AR on C.CategoryID = AR.CategoryID
group by C.CategoryID, C.Name
having COUNT(AR.ArtworkID) > 1;

-- 16. Artworks exhibited in 'Modern Art Masterpieces'
select AR.Title
from Artworks AR
join ExhibitionArtworks EA on AR.ArtworkID = EA.ArtworkID
join Exhibitions E on EA.ExhibitionID = E.ExhibitionID
where E.Title = 'Modern Art Masterpieces';

-- 17. Categories where average artwork year is greater than average of all artworks
select C.Name, avg(AR.Year) as CategoryAvgYear
from Categories C
join Artworks AR on C.CategoryID = AR.CategoryID
group by C.CategoryID, C.Name
having avg(AR.Year) > (select avg(Year) from Artworks);

