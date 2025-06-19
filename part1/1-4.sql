-- 1. Create the database and switch to it
CREATE DATABASE IF NOT EXISTS textbook_marketplace
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE textbook_marketplace;

-- 2. Create Users table
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(60)  NOT NULL UNIQUE,
    email         VARCHAR(120) NOT NULL UNIQUE,
    password_hash CHAR(60)     NOT NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Create Books table
CREATE TABLE books (
    book_id  INT AUTO_INCREMENT PRIMARY KEY,
    title    VARCHAR(255) NOT NULL,
    author   VARCHAR(255) NOT NULL,
    isbn     CHAR(13)     NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 4. Create Listings table
CREATE TABLE listings (
    listing_id   INT AUTO_INCREMENT PRIMARY KEY,
    book_id      INT NOT NULL,
    seller_id    INT NOT NULL,
    city         VARCHAR(80),
    state_region VARCHAR(80),
    postcode     VARCHAR(10),
    price        DECIMAL(8,2) NOT NULL,
    `condition`  ENUM('New','Like New','Good','Acceptable') NOT NULL DEFAULT 'Good',
    status       ENUM('Available','Sold')               NOT NULL DEFAULT 'Available',
    buyer_id     INT NULL,
    posted_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sold_at      TIMESTAMP NULL DEFAULT NULL,
    CONSTRAINT fk_listings_book   FOREIGN KEY (book_id)   REFERENCES books(book_id)
       ON UPDATE CASCADE
       ON DELETE RESTRICT,
    CONSTRAINT fk_listings_seller FOREIGN KEY (seller_id) REFERENCES users(user_id)
       ON UPDATE CASCADE
       ON DELETE CASCADE,
    CONSTRAINT fk_listings_buyer  FOREIGN KEY (buyer_id)  REFERENCES users(user_id)
       ON UPDATE CASCADE
       ON DELETE SET NULL
) ENGINE=InnoDB;

-- 5. (Optional) Helpful indexes for search performance
CREATE INDEX idx_books_title   ON books(title);
CREATE INDEX idx_books_author  ON books(author);
CREATE INDEX idx_listings_price ON listings(price);
CREATE INDEX idx_listings_city  ON listings(city);

-- 6. Insert test data into Users
-- Insert two users: one seller (Alice) and one buyer (Bob)
INSERT INTO users (username, email, password_hash)
VALUES
  ('alice_seller', 'alice@example.com', '$2b$12$examplehashforseller...'),
  ('bob_buyer',   'bob@example.com',   '$2b$12$examplehashforbuyer...');

-- 7. Insert test data into Books
-- Example textbook
INSERT INTO books (title, author, isbn)
VALUES ('Introduction to Algorithms', 'Thomas H. Cormen, et al.', '0262033844');

-- 8. Insert test data into Listings
-- a) An available listing by Alice
-- First, find IDs for clarity (in practice, you’d know or retrieve them):
--   SELECT user_id FROM users WHERE username='alice_seller';  -- suppose = 1
--   SELECT book_id FROM books WHERE isbn='0262033844';        -- suppose = 1
INSERT INTO listings (book_id, seller_id, city, state_region, postcode, price, `condition`, status)
VALUES (1, 1, 'Adelaide', 'SA', '5000', 49.99, 'Good', 'Available');

-- b) A sold listing by Alice to Bob
-- Suppose we want to show a sold listing example: insert another listing, then update buyer_id/status/sold_at
INSERT INTO listings (book_id, seller_id, city, state_region, postcode, price, `condition`, status, buyer_id, sold_at)
VALUES (1, 1, 'Adelaide', 'SA', '5000', 39.50, 'Acceptable', 'Sold', 2, NOW());

-- 9. Verify inserted data (for manual checking)
-- SELECT * FROM users;
-- SELECT * FROM books;
-- SELECT * FROM listings;
