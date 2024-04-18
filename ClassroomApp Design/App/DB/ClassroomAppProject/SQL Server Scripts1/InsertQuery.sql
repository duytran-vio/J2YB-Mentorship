USE ClassroomApp; GO

INSERT INTO [locations] ([name]) VALUES ('San Francisco Bay Area, USA');
INSERT INTO [locations] ([name])  VALUES ('London, UK');
INSERT INTO [locations] ([name]) VALUES ('Tokyo, Japan');

INSERT INTO [users] ([name], [email], [password], [phone], [location], [overview], 
			[profile_link], [title], [avatar_id], [onl_status])
VALUES
  ('Sarah Jones', 'sarah.jones@designstudio.com', 'notmyrealpassword', '+14155550123', 1, 'Aspiring graphic designer with a passion for creating user-friendly interfaces. Recently completed a design internship at a local startup.', 'https://www.behance.net/sarahjdesigns', 'Graphic Design Student', 3, 1),
  ('Omar Hassan', 'omar.hassan@codesmith.com', 'anothersecurepass2', '+97143219876', 2, 'Software engineer with 3+ years of experience in backend development. Skilled in problem-solving and enjoys tackling complex technical challenges.', 'https://stackoverflow.com/users/omarhcodes', 'Software Engineer', 2, 0),
  ('Maria Garcia', 'maria.garcia@travelphotography.es', 'strong_password3', '+34917654321', 3, 'Travel enthusiast and amateur photographer capturing the beauty of nature through her lens. Recently returned from a backpacking trip across Southeast Asia.', 'https://www.flickr.com/photos/mariagarciaphoto', 'Hobbyist Photographer', 4, 1),
  ('Chen Lin', 'chen.lin@datascience.cn', 'very_secure4', '+862156789012', 2, 'Data science student eager to explore the potential of machine learning and data analysis. Currently working on a personal project to analyze social media trends.', 'https://github.com/Wenlin-Chen', 'Data Science Student', 1, 0),
  ('John Smith', 'john.smith@example.com', 'securepassword123', '+1234567890', 1, 'Experienced software developer with expertise in web development. Passionate about creating efficient and scalable applications.', 'https://github.com/johnsmith', 'Software Developer', 5, 1),
  ('Emma Johnson', 'emma.johnson@example.com', 'strongpassword456', '+9876543210', 2, 'Frontend developer with a keen eye for design. Enjoys creating visually appealing and user-friendly interfaces.', 'https://www.linkedin.com/in/emmajohnson', 'Frontend Developer', 6, 0);

-- Insert Teachers (assuming User IDs 1 and 2 are teachers)

INSERT INTO [teachers] ([id], [rating])
VALUES (1, 4.5), 
       (2, 3.8);  

INSERT INTO [students] ([id])
VALUES (3), (4), (5), (6);

-- Insert data into the [certificates] table
INSERT INTO [certificates] ([id], [teacher_id], [cert_name])
VALUES
       (1, 1, 'Full Stack Web Development Certification (University Name)'),
       (2, 2, 'Etudes en Langue Française');

-- Insert data into the [students] table


-- Insert data into the [follow] table
INSERT INTO [follow] ([student_id], [teacher_id])
VALUES (3, 1), (4, 2);

-- Insert data into the [cards] table
INSERT INTO [cards] ([card_number], [card_holder], [expiration_data], [cvv], [user_id])
VALUES
       ('123456789345', 'Sarah Jones', '2023-12-31', '789', 1),
       ('546543873345', 'Omar Hassan', '2024-06-30', '123', 2);


-- Insert data into the [courses] table
INSERT INTO [courses] ([title], [description], [course_price], [document_price], [discount], 
			[level], [language], [teacher_id])
VALUES
       ('Web Development 101', 'Introduction to web development', 50, 10, 0.2, 1, 1, 1),
       ('Data Science Fundamentals', 'Introduction to data science', 75, 15, 0.1, 2, 1, 2);

-- Insert data into the [levels] table
INSERT INTO [levels] ([level_name])
VALUES ('Beginner'), ('Intermediate'), ('Advanced');

-- Insert data into the [languages] table
INSERT INTO [languages] ([language_name])
VALUES ('English'), ('French');

-- Insert data into the [enrollments] table
INSERT INTO [enrollments] ([student_id], [course_id], [status])
VALUES
       (3, 1, 1),
       (4, 2, 1),
	   (5, 1, 1),
	   (6, 1, 1);

-- Insert data into the [sessions] table
INSERT INTO [sessions] ([title], [summary], [start_time], [course_id], [record_id])
VALUES
       ('Introduction to HTML', 'Learn the basics of HTML and how to create web pages', '2022-01-10 09:00:00', 1, 1),
       ('CSS Styling Techniques', 'Explore different CSS styling techniques to enhance your web pages', '2022-01-12 09:00:00', 1, 2),
       ('JavaScript Fundamentals', 'JavaScript Fundamentals', '2022-01-14 09:00:00', 1, 3),
       ('Introduction to Python', 'Get started with Python programming language', '2022-01-11 09:00:00', 2, 4),
       ('Data Analysis with Pandas', 'Learn how to analyze data using Pandas library in Python', '2022-01-13 09:00:00', 2, 5),
       ('Machine Learning Algorithms', 'Machine Learning Algorithms', '2022-01-15 09:00:00', 2, 6);

INSERT INTO [session_status] ([session_id], [student_id], [status])
VALUES
       (1, 3, 'Completed'),
       (2, 3, 'Inprogress'),
	   (3, 3, 'NotStart'),
       (4, 4, 'Completed'),
       (5, 4, 'Completed'),
       (6, 4, 'NotStart');

-- Insert data into the [session_discuss] table
INSERT INTO [session_discuss] ([user_id], [session_id], [content], [likes], [reply_discuss_id])
VALUES	(3, 1, 'How can I learn Web Development effectively?', 10, NULL), 
		(1, 1, 'You need to study the basics and practice regularly.', 5, 1);

-- Insert data into the [course_review] table
INSERT INTO [course_review] ([student_id], [course_id], [content], [rating])
VALUES        (3, 1, 'Great course highly recommended!', 5), 
              (6, 1, 'Eyes opening course!', 4),
              (4, 2, 'The content was informative but could be more engaging.', 3);

-- Insert data into the [files] table
INSERT INTO [files] ([file_name])
VALUES
       ('document1.pdf'),
       ('image1.jpg'),
       ('video1.mp4');

-- Insert data into the [attendance] table
INSERT INTO [attendance] ([session_id], [student_id], [first_enter_time], [duration])
VALUES
       (1, 3, '2022-01-05 09:00:00', 60),
       (1, 4, '2022-01-05 09:00:00', 60),
       (2, 3, '2022-01-06 10:00:00', 90),
       (2, 4, '2022-01-06 10:00:00', 90);

-- Insert data into the [selectors] table
INSERT INTO [selectors] ([session_id], [correct_ans])
VALUES (1, 'A'), (2, 'B');

-- Insert data into the [answer_selector] table
INSERT INTO [answer_selector] ([selecter_id], [student_id], [submit_time], [answer])
VALUES (1, 3, GETDATE(), 'A'), (2, 4, GETDATE(), 'B'), (1, 4, GETDATE(), 'C'), (2, 3, GETDATE(), 'D');

-- Insert data into the [carts] table
INSERT INTO [carts] ([student_id], [create_at], [modify_at])
VALUES (3, GETDATE(), GETDATE()), (4, GETDATE(), GETDATE());

-- Insert data into the [cart_item] table
INSERT INTO [cart_item] ([cart_id], [course_id])
VALUES (1, 1), (1, 2), (2, 1), (2, 2);

-- Insert data into the [message] table
INSERT INTO [message] ([user_id], [content], [create_at])
VALUES
       (1, 'Hello, how are you?', GETDATE()),
       (2, 'I am doing great, thanks!', GETDATE()),
       (1, 'Do you have any plans for the weekend?', GETDATE()),
       (2, 'Yes, I am going hiking with some friends.', GETDATE());

-- Insert data into the [session_chat] table
INSERT INTO [session_chat] ([chat_id], [session_id], [likes], [is_question], [reply_chat_id])
VALUES
       (1, 1, 10, 1, NULL),
       (2, 1, 5, 0, 1),
       (3, 2, 8, 1, NULL),
       (4, 2, 3, 0, 3);

-- Insert data into the [chat_room] table
INSERT INTO [chat_room] ([user1_id], [user2_id])
VALUES
       (1, 2),
       (3, 4);

-- Insert data into the [room_message] table
INSERT INTO [room_message] ([chat_id], [chat_room_id])
VALUES
       (1, 1),
       (2, 1),
       (3, 2),
       (4, 2);

-- Insert data into the [vouchers] table
INSERT INTO [vouchers] ([voucher_value], [voucher_type])
VALUES
       (10.0, 1),
       (20.0, 2),
       (30.0, 1),
       (40.0, 2);

-- Insert data into the [own_vouchers] table
INSERT INTO [own_vouchers] ([student_id], [voucher_id], [expired_date], [isActive])
VALUES
       (1, 1, '2023-01-01', 1),
       (2, 2, '2023-02-01', 1),
       (1, 3, '2023-03-01', 1),
       (2, 4, '2023-04-01', 1);

-- Insert data into the [orders] table
INSERT INTO [orders] ([student_id], [voucher_id], [discount], [order_total], [create_at])
VALUES
       (1, 1, 5.0, 45.0, GETDATE()),
       (2, 2, 10.0, 90.0, GETDATE()),
       (1, 3, 15.0, 135.0, GETDATE()),
       (2, 4, 20.0, 180.0, GETDATE());

-- Insert data into the [order_item] table
INSERT INTO [order_item] ([id], [order_id], [courses_id])
VALUES
       (1, 1, 1),
       (2, 1, 2),
       (3, 2, 3),
       (4, 2, 4);

-- Insert data into the [notifications] table
-- Insert data into the [notifications] table
INSERT INTO [notifications] ([content])
VALUES
       ('New message received from teacher'),
       ('New message received from student'),
       ('New course available'),
       ('New task assigned');

-- Insert data into the [user_noti] table
INSERT INTO [user_noti] ([user_id], [noti_id])
VALUES
       (1, 1),
       (2, 2),
       (1, 3),
       (2, 4);
