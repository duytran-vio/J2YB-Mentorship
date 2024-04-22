--CREATE DATABASE ClassroomApp;

USE ClassroomApp; 

CREATE TABLE [users] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255),
  [email] nvarchar(255) UNIQUE NOT NULL,
  [password] nvarchar(255) NOT NULL,
  [phone] nvarchar(255),
  [location] integer,
  [created_at] datetime,
  [overview] nvarchar(255),
  [profile_link] nvarchar(255),
  [title] nvarchar(255),
  [avatar_id] integer,
  [onl_status] bit
)
GO

CREATE TABLE [roles] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [role_name] nvarchar(255)
)
GO

CREATE TABLE [user_role] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [userId] integer,
  [roleId] integer
)
GO

CREATE TABLE [teacher_addition] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [userId] integer,
  [rating] float
)
GO

CREATE TABLE [locations] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255)
)
GO

CREATE TABLE [certificates] (
  [id] integer PRIMARY KEY,
  [teacher_id] integer,
  [cert_name] nvarchar(255)
)
GO

CREATE TABLE [follow] (
  [id] integer IDENTITY(1, 1),
  [student_id] integer,
  [teacher_id] integer,
  PRIMARY KEY ([id], [student_id], [teacher_id])
)
GO

CREATE TABLE [cards] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [card_number] nvarchar(255) UNIQUE NOT NULL,
  [card_holder] nvarchar(255) NOT NULL,
  [expiration_data] nvarchar(255) NOT NULL,
  [cvv] nvarchar(255) NOT NULL,
  [user_id] integer
)
GO

CREATE TABLE [courses] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [title] nvarchar(255) NOT NULL,
  [description] nvarchar(255),
  [course_price] integer DEFAULT (0),
  [document_price] integer DEFAULT (0),
  [discount] float,
  [level] integer,
  [language] integer,
  [teacher_id] integer,
  [create_at] datetime
)
GO

CREATE TABLE [levels] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [level_name] nvarchar(255)
)
GO

CREATE TABLE [languages] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [language_name] nvarchar(255)
)
GO

CREATE TABLE [enrollments] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [student_id] integer,
  [course_id] integer,
  [status] bit
)
GO

CREATE TABLE [categories] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255) NOT NULL
)
GO

CREATE TABLE [courses_categories] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [course_id] integer,
  [category_id] integer
)
GO

CREATE TABLE [sessions] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [title] nvarchar(255) NOT NULL,
  [summary] nvarchar(255),
  [start_time] datetime,
  [course_id] integer,
  [record_id] integer,
  [order_index] integer
)
GO

CREATE TABLE [session_status] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [session_id] integer,
  [student_id] integer,
  [status_id] integer
)
GO

CREATE TABLE [session_status_type] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [status_name] nvarchar(255)
)
GO

CREATE TABLE [records] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [file_name] nvarchar(255) UNIQUE NOT NULL,
  [create_at] datetime
)
GO

CREATE TABLE [materials] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [file_name] nvarchar(255) UNIQUE NOT NULL,
  [size] float,
  [update_at] datetime,
  [session_id] integer
)
GO

CREATE TABLE [session_discuss] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [user_id] integer,
  [session_id] integer,
  [content] nvarchar(255),
  [likes] integer,
  [reply_discuss_id] integer,
  [create_at] datetime
)
GO

CREATE TABLE [session_discuss_image] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [session_discuss_id] integer,
  [image_id] integer
)
GO

CREATE TABLE [course_review] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [student_id] integer,
  [course_id] integer,
  [content] nvarchar(255),
  [rating] integer
)
GO

CREATE TABLE [teacher_review] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [student_id] integer,
  [teacher_id] integer,
  [content] nvarchar(255),
  [rating] integer
)
GO

CREATE TABLE [images] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [image_path] nvarchar(255)
)
GO

CREATE TABLE [course_images] (
  [id] integer PRIMARY KEY,
  [course_id] integer
)
GO

CREATE TABLE [tasks] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [session_id] integer,
  [question] nvarchar(255),
  [create_at] datetime
)
GO

CREATE TABLE [submission] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [student_id] integer,
  [task_id] integer,
  [submit_time] datetime,
  [answer_file_id] integer,
  [score] float
)
GO

CREATE TABLE [files] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [file_name] nvarchar(255)
)
GO

CREATE TABLE [attendance] (
  [session_id] integer,
  [student_id] integer,
  [first_enter_time] datetime,
  [duration] integer,
  PRIMARY KEY ([session_id], [student_id])
)
GO

CREATE TABLE [selectors] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [session_id] integer,
  [correct_ans] nvarchar(255)
)
GO

CREATE TABLE [answer_selector] (
  [selecter_id] integer,
  [student_id] integer,
  [submit_time] datetime,
  [answer] nvarchar(255),
  PRIMARY KEY ([selecter_id], [student_id])
)
GO

CREATE TABLE [carts] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [student_id] integer,
  [create_at] datetime,
  [modify_at] datetime
)
GO

CREATE TABLE [cart_item] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [cart_id] integer,
  [course_id] integer
)
GO

CREATE TABLE [message] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [user_id] integer,
  [content] nvarchar(255),
  [create_at] datetime
)
GO

CREATE TABLE [session_chat] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [chat_id] integer,
  [session_id] integer,
  [likes] integer,
  [is_question] bit,
  [reply_chat_id] integer
)
GO

CREATE TABLE [chat_room] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [user1_id] integer,
  [user2_id] integer
)
GO

CREATE TABLE [room_message] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [chat_id] integer,
  [chat_room_id] integer
)
GO

CREATE TABLE [room_file] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [chat_room_id] integer,
  [file_id] integer
)
GO

CREATE TABLE [vouchers] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [voucher_value] float,
  [voucher_type] integer
)
GO

CREATE TABLE [own_vouchers] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [student_id] integer,
  [voucher_id] integer,
  [expired_date] datetime,
  [isActive] bit
)
GO

CREATE TABLE [orders] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [student_id] integer,
  [voucher_id] integer,
  [discount] float,
  [order_total] float,
  [create_at] datetime
)
GO

CREATE TABLE [order_item] (
  [id] integer PRIMARY KEY,
  [order_id] integer,
  [courses_id] integer
)
GO

CREATE TABLE [notifications] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [content] nvarchar(255)
)
GO

CREATE TABLE [user_noti] (
  [id] integer PRIMARY KEY IDENTITY(1, 1),
  [user_id] integer,
  [noti_id] integer
)
GO

ALTER TABLE [users] ADD FOREIGN KEY ([location]) REFERENCES [locations] ([id])
GO

ALTER TABLE [users] ADD FOREIGN KEY ([avatar_id]) REFERENCES [images] ([id])
GO

ALTER TABLE [user_role] ADD FOREIGN KEY ([userId]) REFERENCES [users] ([id])
GO

ALTER TABLE [user_role] ADD FOREIGN KEY ([roleId]) REFERENCES [roles] ([id])
GO

ALTER TABLE [teacher_addition] ADD FOREIGN KEY ([userId]) REFERENCES [users] ([id])
GO

ALTER TABLE [certificates] ADD FOREIGN KEY ([teacher_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [follow] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [follow] ADD FOREIGN KEY ([teacher_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [cards] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [courses] ADD FOREIGN KEY ([level]) REFERENCES [levels] ([id])
GO

ALTER TABLE [courses] ADD FOREIGN KEY ([language]) REFERENCES [languages] ([id])
GO

ALTER TABLE [courses] ADD FOREIGN KEY ([teacher_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [enrollments] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [enrollments] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([id])
GO

ALTER TABLE [courses_categories] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([id])
GO

ALTER TABLE [courses_categories] ADD FOREIGN KEY ([category_id]) REFERENCES [categories] ([id])
GO

ALTER TABLE [sessions] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([id])
GO

ALTER TABLE [sessions] ADD FOREIGN KEY ([record_id]) REFERENCES [records] ([id])
GO

ALTER TABLE [session_status] ADD FOREIGN KEY ([session_id]) REFERENCES [sessions] ([id])
GO

ALTER TABLE [session_status] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [session_status] ADD FOREIGN KEY ([status_id]) REFERENCES [session_status_type] ([id])
GO

ALTER TABLE [materials] ADD FOREIGN KEY ([session_id]) REFERENCES [sessions] ([id])
GO

ALTER TABLE [session_discuss] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [session_discuss] ADD FOREIGN KEY ([session_id]) REFERENCES [sessions] ([id])
GO

ALTER TABLE [session_discuss] ADD FOREIGN KEY ([reply_discuss_id]) REFERENCES [session_discuss] ([id])
GO

ALTER TABLE [session_discuss_image] ADD FOREIGN KEY ([session_discuss_id]) REFERENCES [session_discuss] ([id])
GO

ALTER TABLE [session_discuss_image] ADD FOREIGN KEY ([image_id]) REFERENCES [images] ([id])
GO

ALTER TABLE [course_review] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [course_review] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([id])
GO

ALTER TABLE [teacher_review] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [teacher_review] ADD FOREIGN KEY ([teacher_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [course_images] ADD FOREIGN KEY ([id]) REFERENCES [images] ([id])
GO

ALTER TABLE [course_images] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([id])
GO

ALTER TABLE [tasks] ADD FOREIGN KEY ([session_id]) REFERENCES [sessions] ([id])
GO

ALTER TABLE [submission] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [submission] ADD FOREIGN KEY ([task_id]) REFERENCES [tasks] ([id])
GO

ALTER TABLE [submission] ADD FOREIGN KEY ([answer_file_id]) REFERENCES [files] ([id])
GO

ALTER TABLE [attendance] ADD FOREIGN KEY ([session_id]) REFERENCES [sessions] ([id])
GO

ALTER TABLE [attendance] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [selectors] ADD FOREIGN KEY ([session_id]) REFERENCES [sessions] ([id])
GO

ALTER TABLE [answer_selector] ADD FOREIGN KEY ([selecter_id]) REFERENCES [selectors] ([id])
GO

ALTER TABLE [answer_selector] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [carts] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [cart_item] ADD FOREIGN KEY ([cart_id]) REFERENCES [carts] ([id])
GO

ALTER TABLE [cart_item] ADD FOREIGN KEY ([course_id]) REFERENCES [courses] ([id])
GO

ALTER TABLE [message] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [session_chat] ADD FOREIGN KEY ([chat_id]) REFERENCES [message] ([id])
GO

ALTER TABLE [session_chat] ADD FOREIGN KEY ([session_id]) REFERENCES [sessions] ([id])
GO

ALTER TABLE [session_chat] ADD FOREIGN KEY ([reply_chat_id]) REFERENCES [session_chat] ([id])
GO

ALTER TABLE [chat_room] ADD FOREIGN KEY ([user1_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [chat_room] ADD FOREIGN KEY ([user2_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [room_message] ADD FOREIGN KEY ([chat_id]) REFERENCES [message] ([id])
GO

ALTER TABLE [room_message] ADD FOREIGN KEY ([chat_room_id]) REFERENCES [chat_room] ([id])
GO

ALTER TABLE [room_file] ADD FOREIGN KEY ([chat_room_id]) REFERENCES [chat_room] ([id])
GO

ALTER TABLE [room_file] ADD FOREIGN KEY ([file_id]) REFERENCES [files] ([id])
GO

ALTER TABLE [own_vouchers] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [own_vouchers] ADD FOREIGN KEY ([voucher_id]) REFERENCES [vouchers] ([id])
GO

ALTER TABLE [orders] ADD FOREIGN KEY ([student_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [orders] ADD FOREIGN KEY ([voucher_id]) REFERENCES [own_vouchers] ([id])
GO

ALTER TABLE [order_item] ADD FOREIGN KEY ([order_id]) REFERENCES [orders] ([id])
GO

ALTER TABLE [order_item] ADD FOREIGN KEY ([courses_id]) REFERENCES [courses] ([id])
GO

ALTER TABLE [user_noti] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [user_noti] ADD FOREIGN KEY ([noti_id]) REFERENCES [notifications] ([id])
GO

ALTER TABLE [vouchers] ADD FOREIGN KEY ([id]) REFERENCES [cart_item] ([id])
GO
