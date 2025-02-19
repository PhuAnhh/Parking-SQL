CREATE TABLE card_groups(
	id int primary key,
	name varchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate()
)

CREATE TABLE customers(
	id int primary key,
	name varchar(255) not null,
	phone varchar(20) not null,
	room varchar(50),
	created_at datetime default getdate(),
	updated_at datetime default getdate()
)

CREATE TABLE cards(
	id int primary key,
	type varchar(20) not null check (type in ('monthly', 'regular')),
	group_id int,
	customer_id int,
	deleted bit not null default 0,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (group_id) references card_groups(id),
	foreign key (customer_id) references customers(id)
)

CREATE TABLE entry_logs(
	id int primary key,
	card_id int not null,
	plate_number varchar(50) not null,
	vehicle_type varchar(50) not null check (vehicle_type in ('car', 'motorbike', 'bicycle')),
	entry_time datetime default getdate(),
	entry_lane varchar(10) not null,
	image_url varchar(200) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (card_id) references cards(id)
)

CREATE TABLE exit_logs(
	id int primary key, 
	card_id int not null,
	entry_id int not null,
	plate_number varchar(50) not null,
	vehicle_type varchar(50) not null check (vehicle_type in ('car', 'motorbike', 'bicycle')),
	exit_time datetime default getdate(),	
	exit_lane varchar(10) not null,
	image_url varchar(200) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (card_id) references cards(id),
	foreign key (entry_id) references entry_logs(id)
)



CREATE TABLE gates(
	id varchar(50) primary key, 
	name varchar(255) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate()
)

CREATE TABLE computers(
	id varchar(50) primary key,
	name varchar(255) not null,
	ip_address varchar(255) not null,
	gate_id varchar(50),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (gate_id) references gates(id)
)

CREATE TABLE cameras(
	id varchar(50) primary key,
	name varchar(255),
	ip_address varchar(255),
	resolution varchar(50),
	type varchar(50) not null check (type in ('tiandy', 'dahua', 'enster')),
	username varchar(255),
	password varchar(255),
	computer_id varchar(50),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE control_units(
	id varchar(50) primary key,
	name varchar(255),
	username varchar(255), 
	password varchar(255),
	type varchar(50) not null check (type in ('E02.NET', 'SC200', 'Dahua',' Ingressus')),
	connection_protocol varchar(50) not null check (connection_protocol in ('TCP_IP', 'RS232')),
	computer_id varchar(50),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE lanes(
	id varchar(50) primary key,
	name varchar(255) not null,
	type varchar(50) not null check (type in ('lane_in', 'lane_out')),
	computer_id varchar(50),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE led(
	id varchar(50) primary key, 
	name varchar(50) not null,
	computer_id varchar(50),
	type varchar(50) not null check (type in ('P10Red', 'P10FullColor', 'Direction Led')),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE lane_cameras(
    lane_id varchar(50),
    camera_id varchar(50),
    purpose varchar(50) not null check (purpose in ('Motorbike Plate', 'Overview', 'Car Plate')),
	camera_type char(1) not null check (camera_type in ('0', '1', '2', '3')),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
    primary key (lane_id, camera_id),
    foreign key (lane_id) references lanes(id),
    foreign key (camera_id) references cameras(id),
)

CREATE TABLE lane_controllers(
	lane_id varchar(50),
	control_unit_id varchar(50),
	input char(1) not null check (input in ('0', '1', '2', '3', '4', '5')),
	barrier char(1) not null check (barrier in ('0', '1', '2', '3', '4', '5')),
	alarm char(1) not null check (alarm in ('0', '1', '2', '3', '4', '5')),
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	primary key (lane_id, control_unit_id),
    foreign key (lane_id) references lanes(id),
    foreign key (control_unit_id) references control_units(id)
)

INSERT INTO card_groups (id, name, created_at, updated_at) VALUES (1, 'VIP', getdate(), getdate());
INSERT INTO card_groups (id, name, created_at, updated_at) VALUES (2, 'Regular', getdate(), getdate());
INSERT INTO card_groups (id, name, created_at, updated_at) VALUES (3, 'Guest', getdate(), getdate());

INSERT INTO customers (id, name, phone, room, created_at, updated_at) VALUES (1, 'John Doe', '1234567890', '101', getdate(), getdate());
INSERT INTO customers (id, name, phone, room, created_at, updated_at) VALUES (2, 'Jane Smith', '0987654321', '102', getdate(), getdate());
INSERT INTO customers (id, name, phone, room, created_at, updated_at) VALUES (3, 'Bob Johnson', '1122334455', '103', getdate(), getdate());

INSERT INTO cards (id, type, group_id, customer_id, deleted, created_at, updated_at) VALUES (1, 'monthly', 2, 3, 1, getdate(), getdate());
INSERT INTO cards (id, type, group_id, customer_id, deleted, created_at, updated_at) VALUES (2, 'regular', 3, 1, 0, getdate(), getdate());
INSERT INTO cards (id, type, group_id, customer_id, deleted, created_at, updated_at) VALUES (3, 'regular', 1, 2, 0, getdate(), getdate());

INSERT INTO entry_logs (id, card_id, plate_number, vehicle_type, entry_time, entry_lane, image_url) VALUES (1, 3, 'AB123CD', 'car', getdate(), 'A1', 'https://example.com/entry1.jpg', getdate(), getdate());
INSERT INTO entry_logs (id, card_id, plate_number, vehicle_type, entry_time, entry_lane, image_url) VALUES (2, 1, 'XY456EF', 'motorbike', getdate(), 'B2', 'https://example.com/entry2.jpg', getdate(), getdate());
INSERT INTO entry_logs (id, card_id, plate_number, vehicle_type, entry_time, entry_lane, image_url) VALUES (3, 2, 'MN789GH', 'bicycle', getdate(), 'C3', 'https://example.com/entry3.jpg', getdate(), getdate());

INSERT INTO exit_logs (id, entry_id, exit_time, exit_lane) VALUES (1, 2, getdate(), 'B2', getdate(), getdate());
INSERT INTO exit_logs (id, entry_id, exit_time, exit_lane) VALUES (2, 1, getdate(), 'A1', getdate(), getdate());
INSERT INTO exit_logs (id, entry_id, exit_time, exit_lane) VALUES (3, 3, getdate(), 'C3', getdate(), getdate());

SELECT * 
FROM entry_logs
JOIN cards ON entry_logs.card_id = cards.id
WHERE cards.deleted IN (0,1)
