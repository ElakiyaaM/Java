create database VirtualArtGallery;
use VirtualArtGallery;

create table Artist (
    ArtistID int primary key auto_increment ,
    Name varchar(100),
    Biography text,
    BirthDate date,
    Nationality varchar(100),
    Website varchar(255),
    ContactInformation varchar(255)
);
create table Artwork (
    ArtworkID int primary key auto_increment,
    Title varchar(255),
    Description text,
    CreationDate date,
    Medium varchar(100),
    ImageURL varchar(255),
    ArtistID int,
    foreign key (ArtistID) references Artist(ArtistID)
);
create table User (
    UserID int primary key auto_increment ,
    Username varchar(100),
    Password  varchar(255),
    Email varchar(100),
    FirstName varchar(100),
    LastName varchar(100),
    DateOfBirth date,
    ProfilePicture varchar(255)
);
create table User_Favorite_Artwork (
    UserID int,
    ArtworkID int,
    primary key (UserID, ArtworkID),
    foreign key (UserID) references user(UserID),
    foreign key (ArtworkID) references Artwork(ArtworkID)
);
create table Gallery (
    GalleryID int primary key auto_increment,
    Name varchar(100),
    Description text,
    Location varchar(100),
    Curator int,
    OpeningHours varchar(100),
    foreign key (Curator) references Artist(ArtistID)
);
create table Artwork_Gallery (
    ArtworkID int,
    GalleryID int,
    primary key (ArtworkID, GalleryID),
    foreign key (ArtworkID) references Artwork(ArtworkID),
    foreign key (GalleryID) references Gallery(GalleryID)
);
insert into Artist (Name, Biography, BirthDate, Nationality, Website, ContactInformation)values 
('Leonardo da Vinci', 'Italian painter.', '2000-04-15', 'Italian', 'https://davinci.example.com', 'contact@davinci.com'),
('Pablo Picasso', 'Spanish painter r.', '1995-10-25', 'Spanish', 'https://picasso.example.com', 'contact@picasso.com');

insert into User (Username, Password, Email, FirstName, LastName, DateOfBirth)values
('artlover101', 'password1', 'artlover101@example.com', 'John', 'Doe', '1990-01-01'),
('galleryqueen', 'password2', 'galleryqueen@example.com', 'Jane', 'Smith', '1985-05-05');

insert into Artwork (Title, Description, CreationDate, Medium, ImageURL, ArtistID)values 
('Mona Lisa', 'Portrait by Leonardo da Vinci.', '2003-06-01', 'Oil on poplar', 'https://image.monalisa.com', 1),
('Guernica', ' Picasso.', '2001-06-01', 'Oil on canvas', 'https://image.guernica.com', 2);

insert into Gallery (Name, Description, Location, Curator, OpeningHours)values
('Renaissance Masterpieces', ' Renaissance art.', 'Florence, Italy', 1, '9 AM - 5 PM'),
('Modern Art Wonders', 'Modern artworks.', 'Madrid, Spain', 2, '10 AM - 6 PM');

insert into Artwork_Gallery (ArtworkID, GalleryID)values
(1, 1), 
(2, 2); 

insert into User_Favorite_Artwork (UserID, ArtworkID)values
(1, 1), 
(2, 2); 


delete from Artwork_Gallery where (ArtworkID, GalleryID) in ((1,1), (2,2));


insert into Artwork_Gallery (ArtworkID, GalleryID) values
(1, 1),
(2, 2);

delete from User_Favorite_Artwork where (UserID, ArtworkID) in ((1,1), (2,2));

insert into User_Favorite_Artwork (UserID, ArtworkID)
values (1, 1), (2, 2);


select* from Artist;
select* from Artwork;
select* from User;
select* from Gallery;
select* from Artwork_Gallery;
select* from User_Favorite_Artwork;