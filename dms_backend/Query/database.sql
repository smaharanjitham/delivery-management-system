-- ===========================================
-- DELIVERY MANAGEMENT SYSTEM DATABASE
-- ===========================================

DROP DATABASE IF EXISTS delivery_management;

CREATE DATABASE delivery_management;

USE delivery_management;

-- ===========================================
-- ROLES
-- ===========================================

CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO roles(role_name)
VALUES
('Admin'),
('Manager'),
('Delivery Boy'),
('Customer');

-- ===========================================
-- USERS
-- ===========================================

CREATE TABLE users (

    id INT AUTO_INCREMENT PRIMARY KEY,

    role_id INT NOT NULL,

    full_name VARCHAR(150) NOT NULL,

    email VARCHAR(150) UNIQUE NOT NULL,

    phone VARCHAR(20),

    password VARCHAR(255) NOT NULL,

    profile_image VARCHAR(255),

    address TEXT,

    latitude DECIMAL(10,7),

    longitude DECIMAL(10,7),

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY(role_id)
    REFERENCES roles(id)

);

-- ===========================================
-- REFRESH TOKENS
-- ===========================================

CREATE TABLE refresh_tokens (

    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    refresh_token TEXT NOT NULL,

    expires_at DATETIME,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE

);

-- ===========================================
-- FCM TOKENS
-- ===========================================

CREATE TABLE fcm_tokens (

    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    fcm_token TEXT NOT NULL,

    device_name VARCHAR(150),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE

);

-- ===========================================
-- CUSTOMERS
-- ===========================================

CREATE TABLE customers (

    id INT AUTO_INCREMENT PRIMARY KEY,

    customer_name VARCHAR(150),

    phone VARCHAR(20),

    email VARCHAR(150),

    address TEXT,

    latitude DECIMAL(10,7),

    longitude DECIMAL(10,7),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- ===========================================
-- DELIVERY ORDERS
-- ===========================================

CREATE TABLE delivery_orders (

    id INT AUTO_INCREMENT PRIMARY KEY,

    order_number VARCHAR(50) UNIQUE,

    customer_id INT,

    assigned_to INT,

    created_by INT,

    pickup_address TEXT,

    pickup_latitude DECIMAL(10,7),

    pickup_longitude DECIMAL(10,7),

    delivery_address TEXT,

    delivery_latitude DECIMAL(10,7),

    delivery_longitude DECIMAL(10,7),

    package_name VARCHAR(150),

    package_weight DECIMAL(10,2),

    delivery_fee DECIMAL(10,2),

    payment_mode ENUM(
        'Cash',
        'Card',
        'Online'
    ),

    payment_status ENUM(
        'Pending',
        'Paid'
    ) DEFAULT 'Pending',

    status ENUM(

        'Pending',
        'Assigned',
        'Picked Up',
        'Out For Delivery',
        'Delivered',
        'Cancelled',
        'Failed'

    ) DEFAULT 'Pending',

    expected_delivery DATETIME,

    delivered_at DATETIME,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY(customer_id)
    REFERENCES customers(id),

    FOREIGN KEY(assigned_to)
    REFERENCES users(id),

    FOREIGN KEY(created_by)
    REFERENCES users(id)

);

-- ===========================================
-- DELIVERY STATUS HISTORY
-- ===========================================

CREATE TABLE delivery_status_history (

    id INT AUTO_INCREMENT PRIMARY KEY,

    delivery_id INT,

    status VARCHAR(50),

    remarks TEXT,

    updated_by INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(delivery_id)
    REFERENCES delivery_orders(id)
    ON DELETE CASCADE,

    FOREIGN KEY(updated_by)
    REFERENCES users(id)

);

-- ===========================================
-- DELIVERY REMARKS
-- ===========================================

CREATE TABLE delivery_remarks (

    id INT AUTO_INCREMENT PRIMARY KEY,

    delivery_id INT,

    remark TEXT,

    created_by INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(delivery_id)
    REFERENCES delivery_orders(id)
    ON DELETE CASCADE,

    FOREIGN KEY(created_by)
    REFERENCES users(id)

);

-- ===========================================
-- DELIVERY IMAGES
-- ===========================================

CREATE TABLE delivery_images (

    id INT AUTO_INCREMENT PRIMARY KEY,

    delivery_id INT,

    image_type ENUM(

        'Pickup',
        'Delivery',
        'Signature',
        'Proof'

    ),

    image_path VARCHAR(255),

    uploaded_by INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(delivery_id)
    REFERENCES delivery_orders(id)
    ON DELETE CASCADE,

    FOREIGN KEY(uploaded_by)
    REFERENCES users(id)

);

-- ===========================================
-- NOTIFICATIONS
-- ===========================================

CREATE TABLE notifications (

    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT,

    title VARCHAR(255),

    message TEXT,

    is_read BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(user_id)
    REFERENCES users(id)
    ON DELETE CASCADE

);

-- ===========================================
-- LOGIN LOGS
-- ===========================================

CREATE TABLE login_logs (

    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT,

    login_time DATETIME,

    logout_time DATETIME,

    ip_address VARCHAR(100),

    device VARCHAR(255),

    FOREIGN KEY(user_id)
    REFERENCES users(id)

);

-- ===========================================
-- SAMPLE ADMIN
-- Password = Admin@123
-- Hash generated using bcrypt
-- ===========================================

INSERT INTO users
(
role_id,
full_name,
email,
phone,
password,
is_active
)
VALUES
(
1,
'System Admin',
'admin@delivery.com',
'9876543210',
'$2b$10$2b2W0TQ2Olr3vA2zL9dR5e0C2aYz6gL9X2G7n6v1W9V7J2M1aNQ4S',
TRUE
);

-- ===========================================
-- SAMPLE CUSTOMER
-- ===========================================

INSERT INTO customers
(
customer_name,
phone,
email,
address
)
VALUES
(
'John Doe',
'9999999999',
'john@gmail.com',
'Chennai'
);

-- ===========================================
-- SAMPLE DELIVERY
-- ===========================================

INSERT INTO delivery_orders
(
order_number,
customer_id,
assigned_to,
created_by,
pickup_address,
delivery_address,
package_name,
package_weight,
delivery_fee,
payment_mode
)
VALUES
(
'ORD1001',
1,
1,
1,
'Warehouse A',
'Anna Nagar',
'Electronics',
2.5,
250,
'Online'
);

-- ===========================================
-- INDEXES
-- ===========================================

CREATE INDEX idx_users_email
ON users(email);

CREATE INDEX idx_delivery_status
ON delivery_orders(status);

CREATE INDEX idx_delivery_assigned
ON delivery_orders(assigned_to);

CREATE INDEX idx_customer_phone
ON customers(phone);

CREATE INDEX idx_notification_user
ON notifications(user_id);
