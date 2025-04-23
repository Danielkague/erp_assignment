-- E-Commerce Database Implementation

-- Create database
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- BRAND table
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PRODUCT_CATEGORY table with self-referencing foreign key
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id) ON DELETE SET NULL
);

-- PRODUCT table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT,
    category_id INT,
    base_price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE SET NULL
);

-- PRODUCT_IMAGE table
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);

-- COLOR table
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    color_code VARCHAR(20) NOT NULL, -- HEX code or other color representation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SIZE_CATEGORY table
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SIZE_OPTION table
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_name VARCHAR(50) NOT NULL,
    size_code VARCHAR(20) NOT NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id) ON DELETE CASCADE
);

-- ATTRIBUTE_CATEGORY table
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ATTRIBUTE_TYPE table
CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRODUCT_ATTRIBUTE table
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_category_id INT,
    attribute_type_id INT,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id) ON DELETE SET NULL,
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id) ON DELETE SET NULL
);

-- PRODUCT_VARIATION table
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size_id INT,
    color_id INT,
    price_adjustment DECIMAL(10, 2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (size_id) REFERENCES size_option(size_id) ON DELETE SET NULL,
    FOREIGN KEY (color_id) REFERENCES color(color_id) ON DELETE SET NULL
);

-- PRODUCT_ITEM table
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    variation_id INT,
    sku VARCHAR(100) NOT NULL UNIQUE,
    stock_quantity INT NOT NULL DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id) ON DELETE SET NULL
);

-- Create some indexes for better performance
CREATE INDEX idx_product_brand ON product(brand_id);
CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_variation_product ON product_variation(product_id);
CREATE INDEX idx_product_item_product ON product_item(product_id);
CREATE INDEX idx_product_item_variation ON product_item(variation_id);

-- Sample data for Apple products in the e-commerce database
USE ecommerce;

-- Insert Brand data
INSERT INTO brand (brand_name, description, logo_url) VALUES 
('Apple', 'American multinational technology company that designs, develops, and sells consumer electronics, computer software, and online services.', 'https://example.com/images/brands/apple_logo.png');

-- Insert Product Categories
INSERT INTO product_category (category_name, description, parent_category_id) VALUES 
('Electronics', 'Electronic devices and gadgets', NULL);

INSERT INTO product_category (category_name, description, parent_category_id) VALUES 
('Smartphones', 'Mobile communication devices', 1),
('Laptops', 'Portable computers', 1),
('Tablets', 'Touchscreen mobile computers', 1),
('Smartwatches', 'Wearable computing devices', 1),
('Audio', 'Sound and music devices', 1);

-- Insert Colors
INSERT INTO color (color_name, color_code) VALUES 
('Space Gray', '#2E2E2E'),
('Silver', '#C0C0C0'),
('Gold', '#FFD700'),
('Midnight', '#191970'),
('Starlight', '#E8E8E8'),
('Blue', '#0066CC'),
('Purple', '#800080'),
('Red', '#FF0000'),
('Green', '#008000'),
('Pink', '#FFC0CB');

-- Insert Size Categories
INSERT INTO size_category (category_name, description) VALUES 
('iPhone Sizes', 'Different screen sizes for iPhone models'),
('MacBook Sizes', 'Different screen sizes for MacBook models'),
('iPad Sizes', 'Different screen sizes for iPad models'),
('Watch Sizes', 'Different case sizes for Apple Watch');

-- Insert Size Options
INSERT INTO size_option (size_category_id, size_name, size_code, display_order) VALUES 
-- iPhone Sizes
(1, '5.4 inch', 'IP-5.4', 1),
(1, '6.1 inch', 'IP-6.1', 2),
(1, '6.7 inch', 'IP-6.7', 3),
-- MacBook Sizes
(2, '13 inch', 'MB-13', 1),
(2, '14 inch', 'MB-14', 2),
(2, '16 inch', 'MB-16', 3),
-- iPad Sizes
(3, '8.3 inch', 'IPD-8.3', 1),
(3, '10.9 inch', 'IPD-10.9', 2),
(3, '11 inch', 'IPD-11', 3),
(3, '12.9 inch', 'IPD-12.9', 4),
-- Watch Sizes
(4, '40mm', 'AW-40', 1),
(4, '41mm', 'AW-41', 2),
(4, '44mm', 'AW-44', 3),
(4, '45mm', 'AW-45', 4),
(4, '49mm', 'AW-49', 5);

-- Insert Attribute Categories
INSERT INTO attribute_category (category_name, description) VALUES 
('Technical', 'Technical specifications of the product'),
('Physical', 'Physical attributes of the product'),
('Features', 'Special features of the product');

-- Insert Attribute Types
INSERT INTO attribute_type (type_name, description) VALUES 
('Storage', 'Storage capacity of the device'),
('RAM', 'Random Access Memory of the device'),
('Display', 'Display technology and specifications'),
('Processor', 'CPU information'),
('Camera', 'Camera specifications'),
('Battery', 'Battery information and life'),
('Connectivity', 'Available connection types'),
('Material', 'Physical materials used');

-- Insert Products
INSERT INTO product (product_name, brand_id, category_id, base_price, description, is_active) VALUES 
-- iPhones
('iPhone 15', 1, 2, 799.00, 'Apple iPhone 15 with A16 Bionic chip, improved camera system, and iOS 17', TRUE),
('iPhone 15 Pro', 1, 2, 999.00, 'Apple iPhone 15 Pro with A17 Pro chip, ProMotion display, and advanced camera system', TRUE),
('iPhone 15 Pro Max', 1, 2, 1199.00, 'Apple iPhone 15 Pro Max with larger display, A17 Pro chip, and enhanced camera capabilities', TRUE),
('iPhone SE', 1, 2, 429.00, 'Affordable iPhone with A15 Bionic chip and classic design', TRUE),

-- MacBooks
('MacBook Air M2', 1, 3, 999.00, '13-inch MacBook Air with M2 chip, 8-core CPU, up to 10-core GPU', TRUE),
('MacBook Air M3', 1, 3, 1199.00, '13-inch and 15-inch MacBook Air with M3 chip, 8-core CPU, 10-core GPU', TRUE),
('MacBook Pro 14-inch', 1, 3, 1599.00, '14-inch MacBook Pro with M3 Pro or M3 Max chip options', TRUE),
('MacBook Pro 16-inch', 1, 3, 2499.00, '16-inch MacBook Pro with M3 Pro or M3 Max chip options', TRUE),

-- iPads
('iPad (10th generation)', 1, 4, 449.00, '10.9-inch Liquid Retina display, A14 Bionic chip, and USB-C', TRUE),
('iPad Air', 1, 4, 599.00, '10.9-inch iPad Air with M1 chip and 5G capability', TRUE),
('iPad Pro 11-inch', 1, 4, 799.00, '11-inch iPad Pro with M3 chip, ProMotion technology, and Thunderbolt', TRUE),
('iPad Pro 12.9-inch', 1, 4, 1099.00, '12.9-inch iPad Pro with M3 chip, Liquid Retina XDR display, and Thunderbolt', TRUE),

-- Apple Watches
('Apple Watch Series 9', 1, 5, 399.00, 'Apple Watch with S9 chip, always-on Retina display, and health monitoring features', TRUE),
('Apple Watch Ultra 2', 1, 5, 799.00, 'Rugged Apple Watch with extended battery life, precision dual-frequency GPS, and customizable Action button', TRUE),
('Apple Watch SE', 1, 5, 249.00, 'Affordable Apple Watch with essential features and S8 chip', TRUE),

-- Audio Products
('AirPods Pro (2nd generation)', 1, 6, 249.00, 'Wireless earbuds with Active Noise Cancellation, Transparency mode, and Personalized Spatial Audio', TRUE),
('AirPods (3rd generation)', 1, 6, 179.00, 'Wireless earbuds with Spatial Audio and Adaptive EQ', TRUE),
('AirPods Max', 1, 6, 549.00, 'Over-ear headphones with Active Noise Cancellation, Transparency mode, and Spatial Audio', TRUE);

-- Insert Product Images
INSERT INTO product_image (product_id, image_url, is_primary, display_order) VALUES 
-- iPhone 15 Images
(1, 'https://example.com/images/products/iphone15_front.png', TRUE, 1),
(1, 'https://example.com/images/products/iphone15_back.png', FALSE, 2),
(1, 'https://example.com/images/products/iphone15_side.png', FALSE, 3),

-- iPhone 15 Pro Images
(2, 'https://example.com/images/products/iphone15pro_front.png', TRUE, 1),
(2, 'https://example.com/images/products/iphone15pro_back.png', FALSE, 2),
(2, 'https://example.com/images/products/iphone15pro_side.png', FALSE, 3),

-- MacBook Air Images
(5, 'https://example.com/images/products/macbookair_m2_front.png', TRUE, 1),
(5, 'https://example.com/images/products/macbookair_m2_side.png', FALSE, 2),
(5, 'https://example.com/images/products/macbookair_m2_keyboard.png', FALSE, 3);

-- Insert Product Attributes
INSERT INTO product_attribute (product_id, attribute_category_id, attribute_type_id, attribute_name, attribute_value) VALUES 
-- iPhone 15 Attributes
(1, 1, 1, 'Storage Options', '128GB, 256GB, 512GB'),
(1, 1, 4, 'Processor', 'A16 Bionic chip with 6-core CPU, 5-core GPU'),
(1, 1, 3, 'Display', '6.1-inch Super Retina XDR display'),
(1, 1, 5, 'Camera', '48MP Main, 12MP Ultra Wide'),
(1, 1, 6, 'Battery', 'Up to 20 hours video playback'),
(1, 1, 7, 'Connectivity', '5G, Wi-Fi 6E, Bluetooth 5.3, NFC'),
(1, 2, 8, 'Material', 'Aluminum and glass'),

-- iPhone 15 Pro Attributes
(2, 1, 1, 'Storage Options', '128GB, 256GB, 512GB, 1TB'),
(2, 1, 4, 'Processor', 'A17 Pro chip with 6-core CPU, 6-core GPU'),
(2, 1, 3, 'Display', '6.1-inch ProMotion Super Retina XDR display'),
(2, 1, 5, 'Camera', '48MP Main, 12MP Ultra Wide, 12MP Telephoto'),
(2, 1, 6, 'Battery', 'Up to 23 hours video playback'),
(2, 1, 7, 'Connectivity', '5G, Wi-Fi 6E, Bluetooth 5.3, NFC'),
(2, 2, 8, 'Material', 'Titanium and Ceramic Shield front'),

-- MacBook Air M2 Attributes
(5, 1, 1, 'Storage Options', '256GB, 512GB, 1TB, 2TB'),
(5, 1, 2, 'RAM', '8GB, 16GB, 24GB'),
(5, 1, 4, 'Processor', 'Apple M2 chip with 8-core CPU, up to 10-core GPU'),
(5, 1, 3, 'Display', '13.6-inch Liquid Retina display with P3 wide color'),
(5, 1, 6, 'Battery', 'Up to 18 hours of web browsing'),
(5, 1, 7, 'Connectivity', 'Wi-Fi 6, Bluetooth 5.3, 2 Thunderbolt ports'),
(5, 2, 8, 'Material', 'Aluminum unibody'),

-- iPad Pro 12.9-inch Attributes
(12, 1, 1, 'Storage Options', '128GB, 256GB, 512GB, 1TB, 2TB'),
(12, 1, 2, 'RAM', '8GB (128GB-512GB models), 16GB (1TB-2TB models)'),
(12, 1, 4, 'Processor', 'Apple M3 chip with 8-core CPU, 10-core GPU'),
(12, 1, 3, 'Display', '12.9-inch Liquid Retina XDR display with ProMotion and P3 wide color'),
(12, 1, 5, 'Camera', '12MP Wide, 10MP Ultra Wide, LiDAR Scanner'),
(12, 1, 6, 'Battery', 'Up to 10 hours of web browsing'),
(12, 1, 7, 'Connectivity', '5G (cellular models), Wi-Fi 6E, Bluetooth 5.3, Thunderbolt / USB 4'),
(12, 2, 8, 'Material', 'Aluminum unibody');

-- Insert Product Variations
INSERT INTO product_variation (product_id, size_id, color_id, price_adjustment) VALUES 
-- iPhone 15 Variations
(1, 2, 1, 0.00),  -- 6.1 inch, Space Gray
(1, 2, 2, 0.00),  -- 6.1 inch, Silver
(1, 2, 3, 0.00),  -- 6.1 inch, Gold
(1, 2, 6, 0.00),  -- 6.1 inch, Blue
(1, 2, 7, 0.00),  -- 6.1 inch, Purple

-- iPhone 15 Pro Variations
(2, 2, 1, 0.00),  -- 6.1 inch, Space Gray
(2, 2, 2, 0.00),  -- 6.1 inch, Silver
(2, 2, 4, 0.00),  -- 6.1 inch, Midnight
(2, 2, 8, 0.00),  -- 6.1 inch, Red

-- iPhone 15 Pro Max Variations
(3, 3, 1, 0.00),  -- 6.7 inch, Space Gray
(3, 3, 2, 0.00),  -- 6.7 inch, Silver
(3, 3, 4, 0.00),  -- 6.7 inch, Midnight
(3, 3, 8, 0.00),  -- 6.7 inch, Red

-- MacBook Air M2 Variations
(5, 4, 1, 0.00),  -- 13 inch, Space Gray
(5, 4, 2, 0.00),  -- 13 inch, Silver
(5, 4, 3, 0.00),  -- 13 inch, Gold

-- MacBook Pro 14-inch Variations
(7, 5, 1, 0.00),  -- 14 inch, Space Gray
(7, 5, 2, 0.00),  -- 14 inch, Silver

-- MacBook Pro 16-inch Variations
(8, 6, 1, 0.00),  -- 16 inch, Space Gray
(8, 6, 2, 0.00),  -- 16 inch, Silver

-- iPad Pro 11-inch Variations
(11, 9, 1, 0.00),  -- 11 inch, Space Gray
(11, 9, 2, 0.00),  -- 11 inch, Silver

-- iPad Pro 12.9-inch Variations
(12, 10, 1, 0.00),  -- 12.9 inch, Space Gray
(12, 10, 2, 0.00),  -- 12.9 inch, Silver

-- Apple Watch Series 9 Variations
(13, 12, 1, 0.00),  -- 41mm, Space Gray
(13, 12, 2, 0.00),  -- 41mm, Silver
(13, 12, 3, 0.00),  -- 41mm, Gold
(13, 14, 1, 50.00),  -- 45mm, Space Gray (+$50)
(13, 14, 2, 50.00),  -- 45mm, Silver (+$50)
(13, 14, 3, 50.00);  -- 45mm, Gold (+$50)

-- Insert Product Items (SKUs)
INSERT INTO product_item (product_id, variation_id, sku, stock_quantity, price, is_active) VALUES 
-- iPhone 15 Items
(1, 1, 'APPL-IP15-128-SG', 150, 799.00, TRUE),  -- iPhone 15, 128GB, Space Gray
(1, 1, 'APPL-IP15-256-SG', 120, 899.00, TRUE),  -- iPhone 15, 256GB, Space Gray
(1, 1, 'APPL-IP15-512-SG', 80, 1099.00, TRUE),  -- iPhone 15, 512GB, Space Gray
(1, 2, 'APPL-IP15-128-SL', 145, 799.00, TRUE),  -- iPhone 15, 128GB, Silver
(1, 2, 'APPL-IP15-256-SL', 115, 899.00, TRUE),  -- iPhone 15, 256GB, Silver
(1, 2, 'APPL-IP15-512-SL', 75, 1099.00, TRUE),  -- iPhone 15, 512GB, Silver

-- iPhone 15 Pro Items
(2, 6, 'APPL-IP15PRO-128-SG', 100, 999.00, TRUE),   -- iPhone 15 Pro, 128GB, Space Gray
(2, 6, 'APPL-IP15PRO-256-SG', 90, 1099.00, TRUE),   -- iPhone 15 Pro, 256GB, Space Gray
(2, 6, 'APPL-IP15PRO-512-SG', 75, 1299.00, TRUE),   -- iPhone 15 Pro, 512GB, Space Gray
(2, 6, 'APPL-IP15PRO-1TB-SG', 40, 1499.00, TRUE),   -- iPhone 15 Pro, 1TB, Space Gray

-- MacBook Air M2 Items
(5, 14, 'APPL-MBA-M2-256-8-SG', 65, 999.00, TRUE),   -- MacBook Air M2, 256GB, 8GB RAM, Space Gray
(5, 14, 'APPL-MBA-M2-512-8-SG', 55, 1199.00, TRUE),  -- MacBook Air M2, 512GB, 8GB RAM, Space Gray
(5, 14, 'APPL-MBA-M2-256-16-SG', 45, 1199.00, TRUE), -- MacBook Air M2, 256GB, 16GB RAM, Space Gray
(5, 14, 'APPL-MBA-M2-512-16-SG', 40, 1399.00, TRUE), -- MacBook Air M2, 512GB, 16GB RAM, Space Gray
(5, 15, 'APPL-MBA-M2-256-8-SL', 60, 999.00, TRUE),   -- MacBook Air M2, 256GB, 8GB RAM, Silver
(5, 15, 'APPL-MBA-M2-512-8-SL', 50, 1199.00, TRUE),  -- MacBook Air M2, 512GB, 8GB RAM, Silver

-- iPad Pro 12.9-inch Items
(12, 24, 'APPL-IPADPRO-129-128-SG', 55, 1099.00, TRUE),  -- iPad Pro 12.9", 128GB, Space Gray
(12, 24, 'APPL-IPADPRO-129-256-SG', 45, 1199.00, TRUE),  -- iPad Pro 12.9", 256GB, Space Gray
(12, 24, 'APPL-IPADPRO-129-512-SG', 35, 1399.00, TRUE),  -- iPad Pro 12.9", 512GB, Space Gray
(12, 24, 'APPL-IPADPRO-129-1TB-SG', 25, 1799.00, TRUE),  -- iPad Pro 12.9", 1TB, Space Gray
(12, 25, 'APPL-IPADPRO-129-128-SL', 50, 1099.00, TRUE),  -- iPad Pro 12.9", 128GB, Silver
(12, 25, 'APPL-IPADPRO-129-256-SL', 40, 1199.00, TRUE),  -- iPad Pro 12.9", 256GB, Silver

-- Apple Watch Series 9 Items
(13, 26, 'APPL-WATCH-S9-41-SG-GPS', 80, 399.00, TRUE),       -- Apple Watch S9, 41mm, Space Gray, GPS
(13, 26, 'APPL-WATCH-S9-41-SG-CELL', 65, 499.00, TRUE),      -- Apple Watch S9, 41mm, Space Gray, Cellular
(13, 29, 'APPL-WATCH-S9-45-SG-GPS', 75, 429.00, TRUE),       -- Apple Watch S9, 45mm, Space Gray, GPS
(13, 29, 'APPL-WATCH-S9-45-SG-CELL', 60, 529.00, TRUE),      -- Apple Watch S9, 45mm, Space Gray, Cellular

-- AirPods Items (no variations, direct product items)
(16, NULL, 'APPL-AIRPODS-PRO-2', 100, 249.00, TRUE),         -- AirPods Pro (2nd gen)
(17, NULL, 'APPL-AIRPODS-3', 120, 179.00, TRUE),             -- AirPods (3rd gen)
(18, NULL, 'APPL-AIRPODS-MAX-SG', 50, 549.00, TRUE),         -- AirPods Max, Space Gray
(18, NULL, 'APPL-AIRPODS-MAX-SL', 45, 549.00, TRUE);         -- AirPods Max, Silver