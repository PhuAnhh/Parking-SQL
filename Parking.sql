CREATE TABLE card_groups(
	id int identity(1, 1) primary key,
	name varchar(50) not null,
	created_at datetime default getdate(),
	updated_at datetime default getdate()
)

CREATE TABLE customers(
	id int identity(1, 1) primary key,
	name varchar(255) not null,
	phone varchar(20) not null,
	room varchar(50),
	created_at datetime default getdate(),
	updated_at datetime default getdate()
)

CREATE TABLE cards(
	id int identity(1, 1) primary key,
	type varchar(20) not null check (type in ('monthly', 'regular')),
	group_id int not null,
	customer_id int not null,
	deleted bit not null default 0,
	created_at datetime default getdate(),
	updated_at datetime default getdate(),
	foreign key (group_id) references card_groups(id),
	foreign key (customer_id) references customers(id)
)

CREATE TABLE entry_logs(
	id int identity(1, 1) primary key,
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
	id int identity(1, 1) primary key, 
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
	id int identity(1, 1) primary key, 
	name varchar(255) not null,
	created_at datetime default getdate() not null,
	updated_at datetime default getdate()
)

CREATE TABLE computers(
	id int identity(1, 1) primary key,
	name varchar(255) not null,
	ip_address varchar(255) not null,
	gate_id int not null,
	created_at datetime default getdate() not null,
	updated_at datetime default getdate(),
	foreign key (gate_id) references gates(id)
)

CREATE TABLE cameras(
	id int identity(1, 1) primary key,
	name varchar(255) not null,
	ip_address varchar(255) not null,
	resolution varchar(50) not null,
	type varchar(50) not null check (type in ('tiandy', 'dahua', 'enster')),
	username varchar(255) not null,
	password varchar(255) not null,
	computer_id int not null,
	created_at datetime default getdate() not null,
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE control_units(
	id int identity(1, 1) primary key,
	name varchar(255) not null,
	username varchar(255) not null,
	password varchar(255) not null,
	type varchar(50) not null check (type in ('E02.NET', 'SC200', 'Dahua',' Ingressus')),
	connection_protocol varchar(50) not null check (connection_protocol in ('TCP_IP', 'RS232')),
	computer_id int not null,
	created_at datetime default getdate() not null,
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE lanes(
	id int identity(1, 1) primary key,
	name varchar(255) not null,
	type varchar(50) not null check (type in ('lane_in', 'lane_out')),
	computer_id int not null,
	created_at datetime default getdate() not null,
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE led(
	id int identity(1, 1) primary key, 
	name varchar(50) not null,
	computer_id int not null,
	type varchar(50) not null check (type in ('P10Red', 'P10FullColor', 'Direction Led')),
	created_at datetime default getdate() not null,
	updated_at datetime default getdate(),
	foreign key (computer_id) references computers(id)
)

CREATE TABLE lane_cameras(
    lane_id int,
    camera_id int,
    purpose varchar(50) not null check (purpose in ('Motorbike Plate', 'Overview', 'Car Plate')),
	camera_type char(1) not null check (camera_type in ('0', '1', '2', '3')),
	created_at datetime default getdate() not null,
	updated_at datetime default getdate(),
    primary key (lane_id, camera_id),
    foreign key (lane_id) references lanes(id),
    foreign key (camera_id) references cameras(id),
)

CREATE TABLE lane_controllers(
	lane_id int,
	control_unit_id int,
	input char(1) not null check (input in ('0', '1', '2', '3', '4', '5')),
	barrier char(1) not null check (barrier in ('0', '1', '2', '3', '4', '5')),
	alarm char(1) not null check (alarm in ('0', '1', '2', '3', '4', '5')),
	created_at datetime default getdate() not null,
	updated_at datetime default getdate(),
	primary key (lane_id, control_unit_id),
    foreign key (lane_id) references lanes(id),
    foreign key (control_unit_id) references control_units(id)
)

