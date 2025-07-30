CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

CREATE TABLE authors(
     author_id INT AUTO_INCREMENT PRIMARY KEY,
     author_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    genre_id INT NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    publication_year YEAR,
    total_copies INT NOT NULL,
    available_copies INT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
    CONSTRAINT CHK_available_copies CHECK(available_copies <= total_copies AND available_copies >= 0)
);

CREATE TABLE Members (
    Member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address VARCHAR (255),
    phone_nomber VARCHAR (15),
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE DEFAULT(CURRENT_DATE)
);

 INSERT INTO authors (author_name) VALUES
 ('J.K. Rowling'),
 ('George Orwell'),
 ('Stephen King'),
 ('Agatha Christie'),
 ('Isaac Asimov');
 
INSERT INTO genres (genre_name) VALUES
('Fantasy'),
('Dystopian'),
('Horror'),
('Mystery'),
('Science Fiction'),
('Thriller');

-- SELECT * FROM genres;
INSERT INTO Books (title, author_id, genre_id, isbn, publication_year, total_copies, available_copies) VALUES
('Harry Potter and the Sorcerer''s Stone', 1, 1, '978-0590353403', 1997, 5, 5),
('1984', 2, 2, '978-0451524935', 1949, 3, 3),
('It', 3, 3, '978-0450029806', 1986, 2, 2),
('And Then There Were None', 4, 4, '978-0062073488', 1939, 4, 4),
('I, Robot', 5, 5, '978-0553803700', 1950, 3, 3),
('Harry Potter and the Chamber of Secrets', 1, 1, '978-0439064873', 1998, 5, 5);    

INSERT INTO Members (first_name, last_name, address, phone_nomber, email) VALUES
('naveen', 'Sharma', '123 Main St', '555-1111', 'naveen.s@example.com'),
('mirtunjay', 'singh', '456 Oak Ave', '555-2222', 'mirtunjay.s@example.com'),
('pankaj', 'paswan', '789 Pine Ln', '555-3333', 'pankaj.p@example.com');

INSERT INTO Loans (book_id, member_id, loan_date, due_date, return_date) VALUES
(1, 1, '2025-07-10', '2025-07-24', '2025-07-20');

INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
(2, 2, '2025-07-25', '2025-08-08');

INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
(3, 3, '2025-07-15', '2025-07-28');

INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
(4, 1, '2025-07-28', '2025-08-11');

INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
(6, 2, '2025-07-29', '2025-08-12'); 

-- SELECT * FROM  Members;
SELECT available_copies FROM Books WHERE book_id = 5;

INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
    (5, 3, '2025-07-29', '2025-08-12');

UPDATE Books
    SET available_copies = available_copies - 1
    WHERE book_id = 5;

COMMIT;

SELECT * FROM Loans ORDER BY loan_id DESC LIMIT 1;
SELECT title, total_copies, available_copies FROM Books WHERE book_id = 5;
SELECT loan_id FROM Loans WHERE book_id = 2 AND member_id = 2 AND return_date IS NULL;

UPDATE Loans
    SET return_date = '2025-07-29' -- Setting return date to current date
    WHERE book_id = 2 AND member_id = 2 AND return_date IS NULL;

UPDATE Books
    SET available_copies = available_copies + 0
    WHERE book_id = 2;

COMMIT;

SELECT * FROM Loans WHERE book_id = 2 AND member_id = 2; -- Should now have a return_date.
SELECT title, total_copies, available_copies FROM Books WHERE book_id = 2;

SELECT
    B.title,
    A.author_name,
    M.first_name,
    M.last_name,
    L.loan_date,
    L.due_date
FROM
    Loans L
JOIN
    Books B ON L.book_id = B.book_id
JOIN
    Authors A ON B.author_id = A.author_id
JOIN
    Members M ON L.member_id = M.member_id
WHERE
    L.return_date IS NULL;

SELECT
    B.title,
    A.author_name,
    M.first_name,
    M.last_name,
    L.loan_date,
    L.due_date
FROM
    Loans L
JOIN
    Books B ON L.book_id = B.book_id
JOIN
    Authors A ON B.author_id = A.author_id
JOIN
    Members M ON L.member_id = M.member_id
WHERE
    L.return_date IS NULL
    AND L.due_date < CURRENT_DATE();
    
SELECT
    M.first_name,
    M.last_name,
    COUNT(DISTINCT L.book_id) AS total_unique_books_loaned
FROM
    Members M
LEFT JOIN
    Loans L ON M.member_id = L.member_id
GROUP BY
    M.member_id, M.first_name, M.last_name
ORDER BY
    total_unique_books_loaned DESC;


SELECT
    G.genre_name,
    COUNT(L.loan_id) AS total_loans
FROM
    Loans L
JOIN
    Books B ON L.book_id = B.book_id
JOIN
    Genres G ON B.genre_id = G.genre_id
GROUP BY
    G.genre_name
ORDER BY
    total_loans DESC
LIMIT 5;

SELECT
    B.title,
    A.author_name,
    AVG(DATEDIFF(L.return_date, L.loan_date)) AS average_loan_days
FROM
    Loans L
JOIN
    Books B ON L.book_id = B.book_id
JOIN
    Authors A ON B.author_id = A.author_id
WHERE
    L.return_date IS NOT NULL
GROUP BY
    B.book_id, B.title, A.author_name
ORDER BY average_loan_days DESC;


SELECT
    B.title,
    A.author_name,
    B.total_copies,
    B.available_copies
FROM
    Books B
JOIN
    Authors A ON B.author_id = A.author_id
WHERE
    B.available_copies = 0;


SELECT
    M.first_name,
    M.last_name,
    M.email,
    M.registration_date
FROM
    Members M
LEFT JOIN
    Loans L ON M.member_id = L.member_id
WHERE
    L.loan_id IS NULL;