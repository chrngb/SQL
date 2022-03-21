CREATE TYPE banned_type AS enum ('Yes', 'No');

CREATE TYPE role_type AS enum('client', 'driver', 'partner');


CREATE TABLE users(
    user_id int PRIMARY KEY,
    banned banned_type,
    ROLE role_type
);

INSERT INTO users VALUES
(1, 'No', 'client'),
(2, 'Yes', 'client'),
(3, 'No', 'client'),
(4, 'No', 'driver'),
(10, 'No', 'driver'),
(11, 'No', 'driver'),
(12, 'No', 'driver'),
(13, 'No', 'driver');


CREATE TYPE status_type AS enum('completed', 'cancelled_by_driver', 'cancelled_by_client');

CREATE TABLE trips(
    id int PRIMARY KEY,
    client_id int,
	driver_id int,
    city_id int,
    status status_type,
    request_at DATE,
    FOREIGN key(client_id) REFERENCES users(user_id),
    FOREIGN key(driver_id) REFERENCES users(user_id)
);


INSERT INTO trips VALUES
(1,1,10,1,'completed','2013-10-01'),
(2,2,11,1,'cancelled_by_driver','2013-10-01'),
(3,3,12,6,'completed','2013-10-01'),
(4,4,13,6,'cancelled_by_client','2013-10-01'),
(5,1,10,1,'completed','2013-10-02'),
(6,2,11,6,'completed','2013-10-02'),
(7,3,12,6,'completed','2013-10-02'),
(8,2,12,12,'completed','2013-10-03'),
(9,3,10,12,'completed','2013-10-03'),
(10,4,13,12,'cancelled_by_driver','2013-10-03');

