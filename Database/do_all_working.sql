/********************************************************
* This script creates the database named Forum 
*********************************************************/
USE master;
GO

IF  DB_ID('Forum') IS NOT NULL
   DROP DATABASE Forum;
GO

CREATE DATABASE Forum;
GO


-- Tables
USE Forum



CREATE TABLE [dbo].[Users] (
   [UserID]       INT PRIMARY KEY IDENTITY NOT NULL,
   [UserName]     VARCHAR (20) NOT NULL,
   [EmailAddress] VARCHAR (50) NOT NULL,
   [Password]     VARCHAR (20) NOT NULL,
   [DateCreated]  DATETIME     NOT NULL,
   [LastLogin]    DATETIME     NOT NULL,
   [Deleted]       BIT          DEFAULT ((0)) NOT NULL,
   UNIQUE NONCLUSTERED ([UserName] ASC),
   UNIQUE NONCLUSTERED ([EmailAddress] ASC)
);


CREATE TABLE [dbo].[Topics] (
   [TopicID]     INT PRIMARY KEY IDENTITY NOT NULL,
   [UserID]      INT REFERENCES Users(UserID) NOT NULL,
   [Name]        VARCHAR (30)  NOT NULL,
   [Description] VARCHAR (MAX) NOT NULL,
   [DateCreated] DATETIME      NOT NULL
);

CREATE TABLE [dbo].[Posts] (
   [PostID]  INT PRIMARY KEY IDENTITY NOT NULL,
   [TopicID] INT REFERENCES Topics(TopicID) NOT NULL,
   [UserID]  INT REFERENCES Users(UserID) NOT NULL,
   [Title]   VARCHAR (30)  NOT NULL,
   [Text]    VARCHAR (MAX) NOT NULL,
   [DateCreated]    DATETIME      NOT NULL,
   [Stickied] BIT    DEFAULT ((0)) NOT NULL,
   [Hidden]  BIT    DEFAULT ((0)) NOT NULL
);


CREATE TABLE [dbo].[Replies] (
   [ReplyID]     INT PRIMARY KEY IDENTITY NOT NULL,
   [PostID]      INT REFERENCES Posts(PostID) NOT NULL,
   [UserID]      INT REFERENCES Users(UserID) NOT NULL,
   [Text]        VARCHAR (MAX) NOT NULL,
   [DateCreated] DATETIME      NOT NULL,
   [Hidden]      BIT           DEFAULT ((0)) NOT NULL
);

CREATE TABLE [dbo].[Messages] (
   [MessageID]   INT PRIMARY KEY IDENTITY NOT NULL,
   [SenderID]    INT REFERENCES Users(UserID) NOT NULL,
   [RecipientID] INT REFERENCES Users(UserID) NOT NULL,
   [Subject]     VARCHAR (30)  NOT NULL,
   [Text]        VARCHAR (MAX) NOT NULL,
   [DateCreated] DATETIME      NOT NULL
);

-- Inserts

SET IDENTITY_INSERT dbo.Users ON

insert into Users (UserID, UserName, EmailAddress, Password, DateCreated, LastLogin, Deleted) values 
    (1, 'Celestyna', 'cliptrot0@naver.com', 'Lyq6yFlM', '2016-07-02 11:20:13', '2016-10-10 11:52:51', 0),
    (2, 'Sharai', 'swetton1@ustream.tv', 'N2UJc1WPii', '2017-04-09 19:07:35', '2016-11-29 15:05:15', 1),
    (3, 'Oliy', 'ogarthland2@simplemachines.org', '8FjvbxjcO', '2016-10-24 20:01:02', '2016-05-12 10:38:36', 0),
    (4, 'Colas', 'cstroulger3@ning.com', '1Ey1TTWA', '2017-01-20 15:24:17', '2016-12-26 01:46:59', 1),
    (5, 'Luisa', 'lralls4@europa.eu', '18WQQjLbp0', '2016-05-07 15:06:25', '2016-06-01 09:24:24', 1),
    (6, 'Westley', 'wdominguez5@t.co', 'C4QDmi2A', '2017-02-26 00:38:55', '2016-05-19 14:29:29', 1),
    (7, 'Robbyn', 'rcraisford6@rambler.ru', 'RR9j3i', '2016-12-24 05:46:55', '2016-07-23 19:55:19', 1),
    (8, 'Melania', 'mmiddleweek7@cbslocal.com', 'acvgk6XA', '2016-10-14 21:19:06', '2017-02-24 08:32:14', 0),
    (9, 'Marjie', 'mwallentin8@google.cn', 'mi8tf9RqQTg', '2016-10-15 15:08:59', '2017-02-23 12:13:59', 0),
    (10, 'Keenan', 'kcockney9@hp.com', 'ShVuuZ', '2017-01-26 09:49:00', '2016-10-04 21:33:33', 0),
    (11, 'Shaine', 'scliffea@cocolog-nifty.com', 'thjhMNe', '2017-02-04 04:28:18', '2016-07-20 20:22:42', 0),
    (12, 'Emogene', 'efleischerb@bing.com', 'AowsTt', '2016-12-28 11:11:16', '2016-11-07 19:36:05', 1),
    (13, 'Zebadiah', 'zivankovicc@springer.com', 'evV6aSHnbf8X', '2016-08-01 19:45:27', '2016-09-23 08:31:58', 1),
    (14, 'Phillip', 'pmansourd@oakley.com', '2rsDBIi', '2016-10-09 10:13:00', '2016-09-14 07:46:24', 0),
    (15, 'Penelope', 'pjakubowskie@nba.com', 'Xco9h8AzD', '2017-01-18 10:00:33', '2017-02-18 15:56:54', 0),
    (16, 'Emeline', 'egerratyf@blog.com', 'LaBtxQGK', '2017-03-30 19:21:45', '2017-04-21 17:42:50', 1),
    (17, 'Jonas', 'jshielg@psu.edu', 'I8zh2IKGR', '2016-05-31 17:12:22', '2017-03-14 09:02:39', 1),
    (18, 'Jamison', 'jbecerrah@sfgate.com', '0zTUi5BgNbpJ', '2016-06-19 04:56:29', '2016-12-14 10:16:22', 1),
    (19, 'Coletta', 'ccovelyi@storify.com', 'D66OGSmwv', '2016-09-13 01:38:20', '2016-11-01 19:35:24', 1),
    (20, 'Nollie', 'ndomninj@home.pl', 'LCvXWDOea5', '2017-03-20 14:12:44', '2016-10-11 10:57:06', 0),
    (21, 'Ricardo', 'rfarrancek@economist.com', 'oYwYUq', '2017-01-05 20:48:21', '2016-12-06 21:42:08', 1),
    (22, 'Sherwood', 'sgatesmanl@adobe.com', 'RSMTr48bb', '2016-07-02 18:05:11', '2016-07-08 02:46:08', 0),
    (23, 'Gery', 'givelm@arstechnica.com', 'GhaSkr5Uzpo3', '2016-11-26 13:29:25', '2017-01-30 06:41:44', 0),
    (24, 'Alyce', 'aavrahamofn@abc.net.au', 'U0dlJGzHzWh', '2016-05-30 04:57:36', '2017-03-17 01:11:22', 1),
    (25, 'Dix', 'dgennero@dot.gov', 'lxg7C7Wp3z8u', '2016-10-06 17:02:05', '2016-09-12 16:24:59', 0),
    (26, 'Samuel', 'shealyp@aol.com', 'qJo7wiX', '2017-03-12 01:08:32', '2016-10-08 16:10:46', 1),
    (27, 'Ingunna', 'istarcksq@nationalgeographic.com', 'MkTadSHIgJH6', '2016-08-31 13:57:29', '2016-12-10 23:13:24', 1),
    (28, 'Errol', 'eseintr@twitpic.com', 'xah4sZA1eSa', '2016-07-11 04:14:32', '2017-02-08 08:21:20', 1),
    (29, 'Shaun', 'seouzans@salon.com', 'RIhFy23qTjDs', '2016-09-22 09:29:04', '2016-11-20 01:41:03', 1),
    (30, 'Vinson', 'vplentyt@ezinearticles.com', 'rWc4wdJIHxDc', '2016-11-15 01:26:34', '2016-06-17 13:44:59', 0),
    (31, 'Salmon', 'ssouttaru@nsw.gov.au', 'brBqvUmWoPd6', '2017-03-01 04:38:21', '2016-09-20 11:57:53', 0),
    (32, 'Amby', 'alongthornev@xinhuanet.com', 'TauW1ALb', '2017-04-18 03:07:53', '2016-09-23 07:28:03', 0),
    (33, 'Jeannette', 'jegintonw@123-reg.co.uk', 'Xy72Iuy2', '2016-08-08 03:54:39', '2017-02-22 01:45:24', 0),
    (34, 'Dulcinea', 'dsellimanx@squidoo.com', '4TLXLqPwW', '2016-07-26 15:51:23', '2017-01-12 19:17:03', 1),
    (35, 'Byran', 'bwynetty@mozilla.org', 'SK9GSQhnpU3', '2017-03-01 16:44:20', '2016-07-24 21:08:03', 0),
    (36, 'Adorne', 'aosmentz@sun.com', '1GgQA5Xa', '2017-01-20 22:29:15', '2017-02-24 14:07:14', 1),
    (37, 'Alfy', 'aryburn10@washingtonpost.com', 'vvOk1h', '2017-01-13 01:19:04', '2017-01-16 16:51:17', 0),
    (38, 'Jayne', 'jreggio11@mapy.cz', 'jRqCu06rDb', '2016-07-21 11:42:07', '2017-03-17 12:25:22', 1),
    (39, 'Perren', 'pwathen12@cyberchimps.com', 'Ygn7TZyKT5HL', '2016-07-16 00:43:04', '2016-09-13 03:35:13', 1),
    (40, 'Walker', 'wkarlicek13@cbslocal.com', 'lvaN8QO', '2017-01-17 17:24:03', '2016-07-24 18:11:20', 1),
    (41, 'Henryetta', 'hbootell14@noaa.gov', 'COW7K3q8y', '2017-02-07 13:38:19', '2016-11-29 18:39:30', 1),
    (42, 'Frederick', 'flesieur15@yandex.ru', 'mvDXeke64ji', '2016-06-21 03:38:18', '2017-04-11 00:40:35', 1),
    (43, 'Chad', 'chubble16@posterous.com', 'tZKVW1U2fS', '2017-02-15 21:03:36', '2016-11-03 21:01:25', 1),
    (44, 'Meade', 'mfairnington17@psu.edu', 'UgNUHqw4J', '2016-10-31 15:30:53', '2016-10-16 07:44:54', 1),
    (45, 'Allistir', 'abatting18@loc.gov', 'NhMMzB4u', '2016-07-30 17:01:15', '2016-05-04 17:42:44', 1),
    (46, 'Bel', 'bvandermark19@simplemachines.org', 'KCAOx7RK', '2016-09-06 19:44:01', '2016-10-17 08:28:47', 0),
    (47, 'Casper', 'cweber1a@multiply.com', 'cr3XtSDuhTR5', '2016-06-02 02:02:15', '2016-09-26 15:24:12', 0),
    (48, 'Daveta', 'ddjekovic1b@disqus.com', 'AILA3ffvo', '2017-03-07 00:28:45', '2016-07-25 11:44:12', 0),
    (49, 'Kinnie', 'klacknor1c@webnode.com', 'HkMfaQdN', '2016-12-08 23:46:40', '2016-05-17 12:02:49', 1),
    (50, 'Dyanne', 'dhayes1d@blog.com', 'XD0RNyD93soq', '2016-12-05 20:04:13', '2016-05-19 03:37:58', 1),
    (51, 'Gabbi', 'ggatfield1e@bbb.org', 'HJKVtjzeENXI', '2016-06-17 12:29:36', '2017-02-25 04:43:18', 1),
    (52, 'Claiborn', 'csunner1f@ox.ac.uk', '92jQksTYRrp', '2016-10-24 00:08:09', '2016-11-02 11:23:23', 1),
    (53, 'Evelyn', 'enorcliffe1g@nhs.uk', 'DNpuS3qLLq', '2017-02-26 21:20:03', '2016-09-15 01:58:50', 1),
    (54, 'Alley', 'aodooley1h@home.pl', 'GqWazK', '2016-08-06 00:20:21', '2016-06-06 02:47:18', 0),
    (55, 'Judy', 'jspohr1i@forbes.com', 'qxrOmZpIZnlZ', '2016-05-20 20:10:37', '2016-07-08 17:37:37', 1),
    (56, 'Lou', 'lshanley1j@pbs.org', 'hOa8DQ', '2016-10-22 11:34:32', '2016-09-13 07:48:13', 1),
    (57, 'Fan', 'fgrigolashvill1k@pbs.org', 'RQhBYBMR5', '2016-08-06 13:53:13', '2016-05-18 17:32:35', 0),
    (58, 'Truman', 'tlukock1l@skyrock.com', '8mbk9s', '2017-01-18 01:44:35', '2016-10-06 13:08:04', 0),
    (59, 'Barrie', 'bocarrol1m@dropbox.com', 'jWX3pWB', '2016-11-02 11:32:09', '2016-10-04 16:20:01', 0),
    (60, 'Arni', 'aburnhard1n@cnet.com', 'yoG3aYis', '2016-05-12 15:47:50', '2016-06-09 01:45:38', 1),
    (61, 'Son', 'shassent1o@gov.uk', 'O4XXq0N5SUP', '2016-11-26 01:26:19', '2016-06-14 04:31:33', 1),
    (62, 'Rowe', 'resseby1p@newsvine.com', 'ZDaDy2FqnTMp', '2017-04-10 23:20:48', '2016-10-28 02:52:37', 0),
    (63, 'Abelard', 'aschiersch1q@omniture.com', 'ZTSXRCT', '2016-11-16 20:21:16', '2016-07-24 01:06:53', 0),
    (64, 'Marcia', 'mfenn1r@unicef.org', 'uwNcmuYqxTWc', '2016-05-06 10:54:45', '2017-01-29 01:37:05', 1),
    (65, 'Werner', 'wgovenlock1s@ucla.edu', 'trO2Jv83Fk94', '2016-05-28 01:41:26', '2016-06-14 06:07:36', 1),
    (66, 'Anatol', 'ahaseman1t@bing.com', 'DcFjh1EwoRC', '2017-02-24 18:56:17', '2016-07-15 20:31:05', 1),
    (67, 'Pepita', 'pdrysdell1u@sakura.ne.jp', 'wL2qPOSyi', '2016-08-19 09:21:52', '2016-11-01 17:00:47', 1),
    (68, 'Angelique', 'afinnan1v@wikispaces.com', '7BS4GtM', '2017-01-08 20:37:58', '2016-07-23 20:03:39', 0),
    (69, 'Jackson', 'jboyn1w@upenn.edu', 'PVElbom', '2016-12-15 10:37:00', '2017-03-22 21:05:25', 0),
    (70, 'Nat', 'nfulton1x@infoseek.co.jp', 'x636mY', '2016-07-12 08:58:56', '2016-11-12 23:33:17', 0),
    (71, 'Rica', 'rpashley1y@reddit.com', 'StQS07', '2017-01-27 21:03:39', '2016-07-11 21:25:15', 1),
    (72, 'Clim', 'czoppie1z@acquirethisname.com', '7UryLeCXeA', '2016-05-15 13:48:46', '2017-01-14 00:30:47', 0),
    (73, 'Adeline', 'apogg20@accuweather.com', 'e5laN0', '2016-05-26 12:54:48', '2016-10-13 23:38:15', 0),
    (74, 'Lazarus', 'ldrysdall21@ycombinator.com', 'OzGm5s0Y', '2016-10-12 19:54:30', '2016-08-09 22:24:56', 0),
    (75, 'Mattheus', 'mcranson22@mysql.com', 'uBLOpotz', '2017-01-18 17:45:08', '2016-12-11 06:21:07', 1),
    (76, 'Queenie', 'qkolodziej23@mayoclinic.com', 'jriC13vTL', '2016-07-15 08:13:55', '2016-05-04 13:49:12', 0),
    (77, 'Ciro', 'ccicchillo24@marriott.com', '9WID27bNbRxL', '2017-03-30 15:04:14', '2016-06-15 15:22:25', 0),
    (78, 'Bruis', 'babendroth25@princeton.edu', 'k4z2CZk68Rp', '2016-10-04 01:44:47', '2016-06-03 08:28:36', 0),
    (79, 'Nichole', 'nrosenbush26@jugem.jp', '3j1wk4Ti4Ps6', '2016-05-30 00:04:20', '2017-03-19 10:50:48', 0),
    (80, 'Philly', 'ppoundsford27@hatena.ne.jp', 'rfQ2wqx1E', '2016-10-28 13:58:38', '2016-08-22 06:17:15', 0),
    (81, 'Noble', 'ntodman28@last.fm', 'OgJIWRxDVa3', '2016-08-24 10:20:07', '2016-11-20 02:16:19', 0),
    (82, 'Lucy', 'lcordet29@mozilla.org', 'BeHtADIG5T', '2016-06-09 09:34:26', '2017-04-06 15:14:56', 0),
    (83, 'Anette', 'aduer2a@diigo.com', 'Fd6HB9XCcQ', '2017-02-04 13:40:17', '2016-10-11 01:55:34', 0),
    (84, 'Feodora', 'fadshed2b@baidu.com', 'w6BdIWabOmZ', '2016-06-02 07:06:24', '2016-06-19 23:00:14', 1),
    (85, 'Brandise', 'bcummings2c@disqus.com', 'wTJor3TeDtY', '2016-09-23 09:34:11', '2016-09-17 20:29:09', 1),
    (86, 'Lucias', 'lquiddihy2d@pagesperso-orange.fr', '4awupiMCn', '2016-08-12 11:11:43', '2016-10-27 02:10:57', 0),
    (87, 'Guenevere', 'gibell2e@hexun.com', 'yWo46Z', '2016-10-16 11:01:42', '2016-07-16 18:10:08', 1),
    (88, 'Connor', 'crosenwald2f@uiuc.edu', 'ftNEZA4', '2017-01-08 17:58:47', '2016-06-28 04:14:47', 1),
    (89, 'Eben', 'esorrie2g@arstechnica.com', 'WlA0ape7', '2017-01-10 20:59:27', '2016-07-24 14:57:49', 0),
    (90, 'Shari', 'sgepp2h@wired.com', 'kFbJ1UBHJc8x', '2016-10-14 23:14:22', '2017-03-10 03:40:16', 1),
    (91, 'Shane', 'sdebow2i@freewebs.com', '2FVICe', '2016-09-23 16:00:21', '2017-02-04 10:18:23', 0),
    (92, 'Buddy', 'bcarter2j@microsoft.com', 'odjDEK1olW', '2017-03-13 19:55:33', '2016-07-13 13:30:57', 1),
    (93, 'Ula', 'ucollough2k@vk.com', 'IicBEMyUG', '2016-08-22 23:50:01', '2016-06-13 19:31:07', 0),
    (94, 'Sabina', 'smccarrick2l@hhs.gov', 'bGW10Xac', '2016-11-21 20:31:22', '2017-04-13 05:58:23', 0),
    (95, 'Geoff', 'gradley2m@theglobeandmail.com', 'ZT7knF6piQ', '2016-09-08 15:17:01', '2016-08-03 20:17:08', 1),
    (96, 'Bethina', 'blowle2n@princeton.edu', 'I7MCGV', '2016-11-19 06:56:20', '2016-12-21 17:01:59', 0),
    (97, 'Marcella', 'mstickells2o@intel.com', 'pFP8WLN2q3p0', '2016-12-31 13:46:08', '2016-08-15 16:42:28', 1),
    (98, 'Sylvan', 'snelius2p@nifty.com', 'FgUkJuYaLaH', '2016-09-15 14:37:01', '2017-02-23 18:36:33', 0),
    (99, 'Arlinda', 'aludford2q@spotify.com', 'dBbYeJWLjLk8', '2016-07-22 04:47:26', '2016-07-20 14:04:16', 0),
    (100, 'Caralie', 'chaensel2r@mit.edu', 'KdAedTCa', '2016-06-16 08:52:59', '2016-12-05 06:43:41', 0);

SET IDENTITY_INSERT dbo.Users OFF

SET IDENTITY_INSERT dbo.Topics ON

insert into Topics (TopicID, UserID, Name, Description, DateCreated) values
    (1, 44, 'Sports', 'arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis', '2016-09-08 15:17:01'),
    (2, 9,'Programming', 'lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio','2016-07-24 14:57:49'),
    (3, 83,'TV & Movies', 'turpis enim blandit mi in porttitor', '2016-10-16 11:01:42'),
    (4, 23,'Books', 'quam pharetra magna ac consequat metus sapien ut nunc', '2016-06-16 08:52:59'),
    (5, 61,'Cooking', 'massa id nisl venenatis lacinia aenean sit amet justo morbi','2017-03-13 19:55:33');

SET IDENTITY_INSERT dbo.Topics OFF

SET IDENTITY_INSERT dbo.Posts ON

insert into Posts (PostID, TopicID, UserID, Title, Text, DateCreated, Hidden) values 
    (1, 2, 100, 'hub', 'dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum', '2016-07-01 18:15:27', 0),
    (2, 5, 53, 'Self-enabling', 'libero nam dui proin leo odio', '2016-12-23 06:11:15', 0),
    (3, 2, 97, 'Decentralized', 'tortor risus dapibus augue vel accumsan tellus', '2016-08-10 14:17:31', 1),
    (4, 1, 39, 'Reduced', 'orci eget orci vehicula condimentum curabitur in libero', '2016-06-30 21:56:39', 0),
    (5, 1, 11, 'radical', 'nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor', '2016-07-15 21:15:30', 0),
    (6, 2, 50, 'architecture', 'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin', '2017-01-25 06:01:57', 1),
    (7, 5, 70, 'bandwidth-monitored', 'quisque ut erat curabitur gravida', '2017-03-14 18:47:13', 0),
    (8, 5, 63, 'implementation', 'est phasellus sit amet erat nulla tempus vivamus in felis', '2016-06-21 23:35:09', 1),
    (9, 5, 81, 'radical', 'tellus nisi eu orci mauris lacinia sapien quis libero nullam sit', '2016-11-19 19:11:52', 0),
    (10, 5, 29, 'discrete', 'interdum in ante vestibulum ante ipsum primis in faucibus orci luctus', '2016-04-25 00:23:12', 1),
    (11, 3, 76, 'impactful', 'eget congue eget semper rutrum nulla nunc purus phasellus in', '2016-05-01 15:10:00', 1),
    (12, 2, 43, 'intermediate', 'iaculis diam erat fermentum justo nec condimentum', '2016-09-24 10:25:35', 1),
    (13, 5, 36, 'composite', 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat', '2017-01-13 03:05:43', 0),
    (14, 5, 74, 'radical', 'quis odio consequat varius integer', '2016-11-29 16:31:29', 1),
    (15, 3, 99, 'upward-trending', 'est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in', '2016-08-15 20:57:20', 0),
    (16, 1, 54, 'Compatible', 'quam pharetra magna ac consequat metus sapien ut nunc vestibulum', '2016-08-30 03:05:07', 1),
    (17, 2, 98, 'attitude-oriented', 'molestie nibh in lectus pellentesque at', '2016-06-21 13:26:12', 0),
    (18, 2, 97, 'uniform', 'velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante', '2017-02-13 02:15:57', 0),
    (19, 1, 40, 'empowering', 'tristique est et tempus semper est quam pharetra magna ac consequat metus', '2016-06-21 06:39:34', 1),
    (20, 5, 42, 'Re-contextualized', 'ac consequat metus sapien ut nunc vestibulum ante', '2016-08-03 10:18:43', 1),
    (21, 3, 37, 'Down-sized', 'suspendisse potenti in eleifend quam', '2016-07-31 14:18:30', 0),
    (22, 5, 54, 'Front-line', 'orci nullam molestie nibh in lectus', '2017-01-26 10:02:37', 1),
    (23, 3, 29, 'Graphical User Interface', 'id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit', '2016-04-29 13:55:44', 0),
    (24, 1, 23, 'uniform', 'proin eu mi nulla ac enim in tempor turpis', '2016-06-05 06:41:49', 0),
    (25, 1, 58, 'Adaptive', 'consequat lectus in est risus auctor sed', '2017-01-05 03:30:35', 0),
    (26, 5, 14, 'hardware', 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus', '2017-01-16 12:01:01', 0),
    (27, 5, 11, 'Total', 'id nulla ultrices aliquet maecenas leo', '2017-02-17 14:12:46', 0),
    (28, 2, 46, 'discrete', 'ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus', '2016-05-21 19:50:05', 0),
    (29, 4, 24, 'focus group', 'hendrerit at vulputate vitae nisl aenean', '2016-10-12 01:14:20', 1),
    (30, 1, 19, 'Expanded', 'malesuada in imperdiet et commodo vulputate', '2016-08-09 22:09:44', 1),
    (31, 2, 70, 'attitude-oriented', 'mauris lacinia sapien quis libero nullam sit amet', '2016-12-16 00:56:50', 0),
    (32, 5, 59, 'functionalities', 'lobortis est phasellus sit amet erat nulla tempus vivamus', '2016-10-14 05:27:24', 0),
    (33, 5, 32, 'monitoring', 'in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem', '2016-11-29 14:27:58', 0),
    (34, 4, 77, 'optimizing', 'sapien cursus vestibulum proin eu mi nulla ac', '2016-12-05 07:01:12', 1),
    (35, 4, 36, 'hybrid', 'varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam', '2016-09-13 10:36:03', 0),
    (36, 3, 58, 'info-mediaries', 'blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus', '2017-03-27 11:47:32', 1),
    (37, 1, 40, 'capacity', 'consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac', '2017-02-01 07:45:01', 0),
    (38, 1, 6, 'algorithm', 'in hac habitasse platea dictumst maecenas ut massa', '2016-05-20 17:12:23', 0),
    (39, 5, 57, 'optimal', 'ut volutpat sapien arcu sed augue aliquam erat volutpat in', '2017-03-20 09:41:59', 1),
    (40, 5, 76, 'Intuitive', 'massa donec dapibus duis at velit eu est congue', '2017-03-21 00:29:25', 1),
    (41, 1, 11, 'Total', 'a libero nam dui proin leo odio porttitor id consequat', '2016-07-15 04:15:35', 0),
    (42, 3, 75, 'open architecture', 'sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate', '2016-09-04 20:18:55', 1),
    (43, 4, 83, 'Versatile', 'vulputate ut ultrices vel augue vestibulum', '2017-02-13 01:32:12', 1),
    (44, 1, 52, 'regional', 'eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget', '2017-03-27 04:42:54', 0),
    (45, 1, 2, 'Devolved', 'eros suspendisse accumsan tortor quis turpis sed ante', '2017-04-19 20:22:07', 0),
    (46, 3, 38, 'leverage', 'a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla', '2017-03-18 07:55:30', 0),
    (47, 2, 53, 'Monitored', 'accumsan felis ut at dolor quis', '2016-10-24 18:53:48', 0),
    (48, 4, 38, 'interface', 'augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa', '2017-03-23 08:55:04', 1),
    (49, 5, 74, 'incremental', 'placerat ante nulla justo aliquam quis', '2016-06-28 21:39:06', 1),
    (50, 1, 33, 'migration', 'ac tellus semper interdum mauris ullamcorper purus', '2016-09-13 02:51:22', 0),
    (51, 3, 34, 'service-desk', 'amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel', '2016-11-11 05:42:07', 1),
    (52, 4, 71, 'Graphic Interface', 'sapien arcu sed augue aliquam erat volutpat in congue etiam', '2017-02-24 15:17:43', 1),
    (53, 4, 89, 'Quality-focused', 'donec odio justo sollicitudin ut', '2016-06-27 22:48:59', 0),
    (54, 3, 85, 'Extended', 'auctor gravida sem praesent id massa id nisl venenatis lacinia aenean', '2017-04-01 19:55:49', 1),
    (55, 1, 95, 'User-centric', 'ac consequat metus sapien ut nunc vestibulum ante ipsum primis in', '2016-06-22 03:06:59', 1),
    (56, 4, 94, 'standardization', 'varius ut blandit non interdum in ante vestibulum ante ipsum primis in', '2016-05-21 07:18:36', 0),
    (57, 3, 77, 'success', 'suspendisse potenti in eleifend quam a odio in', '2016-12-04 03:27:35', 0),
    (58, 2, 32, 'Proactive', 'quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas', '2016-07-07 23:51:32', 0),
    (59, 1, 44, 'task-force', 'orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio', '2017-04-03 16:06:58', 0),
    (60, 1, 2, 'model', 'cursus urna ut tellus nulla ut erat', '2016-10-31 23:49:05', 0),
    (61, 2, 75, 'success', 'penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', '2017-02-11 23:17:55', 0),
    (62, 2, 69, 'system-worthy', 'libero rutrum ac lobortis vel dapibus at diam', '2016-11-26 11:25:47', 0),
    (63, 3, 59, 'Face to face', 'interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus', '2016-10-21 04:07:30', 0),
    (64, 2, 38, 'knowledge base', 'tellus semper interdum mauris ullamcorper purus sit', '2016-08-01 01:49:13', 0),
    (65, 4, 77, 'fresh-thinking', 'diam cras pellentesque volutpat dui maecenas tristique est et tempus', '2017-03-03 20:04:00', 1),
    (66, 1, 55, 'maximized', 'faucibus orci luctus et ultrices', '2017-01-07 03:14:36', 0),
    (67, 1, 62, 'alliance', 'tellus semper interdum mauris ullamcorper purus', '2017-04-20 21:10:38', 0),
    (68, 1, 41, 'array', 'viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et', '2017-02-09 00:34:03', 0),
    (69, 4, 73, 'cohesive', 'duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut', '2016-08-13 03:37:02', 0),
    (70, 3, 62, 'info-mediaries', 'faucibus orci luctus et ultrices', '2017-01-15 21:37:33', 0),
    (71, 1, 4, 'process improvement', 'varius ut blandit non interdum in ante vestibulum ante ipsum primis in', '2017-01-09 08:05:40', 0),
    (72, 5, 84, 'analyzing', 'condimentum neque sapien placerat ante', '2016-12-16 17:17:01', 1),
    (73, 4, 48, 'Fully-configurable', 'in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor', '2016-10-14 12:55:39', 0),
    (74, 4, 38, 'challenge', 'ligula nec sem duis aliquam', '2017-03-30 09:26:47', 0),
    (75, 1, 37, 'contextually-based', 'odio porttitor id consequat in consequat ut nulla sed accumsan felis', '2017-01-15 11:40:13', 1),
    (76, 1, 57, 'Upgradable', 'sit amet cursus id turpis integer aliquet massa id', '2016-07-19 14:24:39', 0),
    (77, 4, 29, 'infrastructure', 'aliquam erat volutpat in congue etiam justo etiam pretium iaculis', '2016-08-13 16:40:28', 1),
    (78, 1, 93, 'Secured', 'nulla ac enim in tempor', '2016-12-17 05:27:37', 1),
    (79, 4, 28, 'object-oriented', 'posuere metus vitae ipsum aliquam non mauris morbi', '2016-08-25 02:21:52', 1),
    (80, 1, 71, 'incremental', 'lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum', '2017-01-06 02:04:48', 0),
    (81, 1, 95, 'help-desk', 'donec quis orci eget orci vehicula condimentum curabitur in', '2016-07-24 18:59:58', 1),
    (82, 1, 59, 'user-facing', 'scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus', '2017-04-02 15:59:24', 0),
    (83, 1, 36, '6th generation', 'sapien varius ut blandit non interdum in ante vestibulum ante ipsum', '2016-06-10 16:07:19', 1),
    (84, 4, 34, 'interactive', 'curae mauris viverra diam vitae', '2016-12-14 07:47:57', 0),
    (85, 2, 4, 'circuit', 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat', '2016-12-16 14:55:55', 1),
    (86, 2, 80, 'structure', 'dapibus dolor vel est donec odio', '2016-04-29 02:02:24', 1),
    (87, 4, 2, 'Multi-layered', 'hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo', '2016-07-30 05:07:49', 1),
    (88, 2, 28, 'Future-proofed', 'posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam', '2016-08-13 00:00:55', 1),
    (89, 3, 57, 'contingency', 'cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius', '2017-02-11 23:54:30', 0),
    (90, 3, 76, 'database', 'scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis', '2016-12-14 21:45:57', 0),
    (91, 2, 95, 'superstructure', 'id ligula suspendisse ornare consequat lectus in est risus', '2016-06-18 20:39:43', 0),
    (92, 5, 56, 'alliance', 'at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac', '2016-12-04 16:28:02', 0),
    (93, 5, 59, 'composite', 'cras pellentesque volutpat dui maecenas', '2017-04-03 00:29:34', 0),
    (94, 1, 18, 'artificial intelligence', 'ullamcorper purus sit amet nulla', '2016-12-03 16:28:24', 0),
    (95, 5, 100, 'interface', 'nulla integer pede justo lacinia', '2016-12-10 13:07:51', 1),
    (96, 3, 94, 'Automated', 'luctus et ultrices posuere cubilia curae duis', '2016-05-24 18:35:23', 1),
    (97, 5, 64, 'Customizable', 'adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis', '2016-12-19 15:18:15', 0),
    (98, 3, 2, 'Persevering', 'aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero', '2016-12-07 13:36:29', 1),
    (99, 5, 10, 'throughput', 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi', '2016-10-10 08:19:43', 0),
    (100, 4, 4, 'protocol', 'in eleifend quam a odio', '2017-03-23 09:10:21', 1);

SET IDENTITY_INSERT dbo.Posts OFF

SET IDENTITY_INSERT dbo.Replies ON

insert into Replies (ReplyID, PostID, UserID, Text, DateCreated, Hidden) values 
    (1, 97, 10, 'in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis', '2016-09-19 01:43:40', 0),
    (2, 41, 40, 'non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet', '2016-10-30 19:45:44', 0),
    (3, 65, 43, 'quis lectus suspendisse potenti in eleifend quam a odio in', '2016-10-04 13:54:35', 1),
    (4, 82, 27, 'pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id', '2017-04-17 09:53:45', 1),
    (5, 90, 23, 'nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis', '2017-02-19 07:22:53', 0),
    (6, 20, 11, 'iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', '2016-06-22 03:54:52', 0),
    (7, 80, 25, 'curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar', '2017-04-24 08:29:55', 0),
    (8, 20, 26, 'justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique', '2016-09-03 12:42:09', 1),
    (9, 86, 43, 'nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante', '2016-07-01 15:31:45', 1),
    (10, 3, 30, 'neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus', '2016-12-04 13:29:29', 0),
    (11, 36, 43, 'ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl', '2016-09-27 21:15:23', 1),
    (12, 99, 11, 'convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci', '2016-08-22 02:03:57', 0),
    (13, 43, 24, 'eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', '2016-07-21 18:09:24', 1),
    (14, 38, 24, 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio', '2016-05-09 21:44:43', 1),
    (15, 43, 14, 'at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices', '2016-11-25 01:50:30', 0),
    (16, 10, 32, 'nam congue risus semper porta volutpat quam pede lobortis ligula', '2017-03-17 21:01:58', 0),
    (17, 34, 39, 'pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis', '2016-06-27 17:42:02', 0),
    (18, 98, 49, 'habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer', '2016-09-08 16:58:06', 1),
    (19, 28, 18, 'risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis', '2017-02-14 04:28:17', 0),
    (20, 14, 33, 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis', '2016-08-17 05:43:53', 0),
    (21, 61, 19, 'proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum', '2016-09-27 07:21:03', 1),
    (22, 14, 44, 'luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est', '2017-02-14 20:19:20', 1),
    (23, 60, 36, 'donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique', '2017-02-27 02:11:14', 0),
    (24, 44, 45, 'aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia', '2017-04-04 17:59:24', 0),
    (25, 69, 25, 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet', '2017-01-07 10:06:21', 0),
    (26, 77, 21, 'semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in', '2017-01-14 11:04:47', 0),
    (27, 59, 16, 'ultrices phasellus id sapien in sapien iaculis congue vivamus metus', '2017-01-19 12:26:13', 1),
    (28, 57, 35, 'hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur', '2017-03-06 15:51:22', 1),
    (29, 43, 31, 'vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum', '2016-07-29 12:25:35', 1),
    (30, 24, 34, 'posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at', '2016-12-10 07:15:39', 1),
    (31, 18, 46, 'ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer', '2016-10-07 05:09:03', 1),
    (32, 54, 11, 'turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus', '2016-12-26 08:33:37', 0),
    (33, 1, 7, 'purus eu magna vulputate luctus cum sociis natoque penatibus et magnis', '2016-09-05 04:20:16', 1),
    (34, 61, 33, 'lorem ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum', '2016-07-15 21:53:06', 1),
    (35, 64, 25, 'primis in faucibus orci luctus et ultrices posuere cubilia curae mauris', '2017-02-11 08:57:09', 1),
    (36, 2, 45, 'pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum', '2017-03-16 11:31:55', 1),
    (37, 29, 4, 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla', '2016-11-24 15:29:19', 1),
    (38, 18, 33, 'nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros', '2016-10-09 00:22:45', 0),
    (39, 82, 19, 'aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut', '2016-11-22 10:21:09', 1),
    (40, 32, 42, 'est risus auctor sed tristique in tempus sit amet sem', '2017-01-13 21:38:17', 0),
    (41, 94, 7, 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi', '2017-04-09 00:02:57', 1),
    (42, 69, 40, 'dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum', '2016-04-25 09:35:40', 0),
    (43, 22, 14, 'vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis', '2016-09-13 02:21:03', 1),
    (44, 86, 19, 'auctor gravida sem praesent id massa id nisl venenatis lacinia', '2016-11-19 22:58:04', 0),
    (45, 67, 2, 'lorem quisque ut erat curabitur gravida nisi at nibh in hac', '2016-06-15 23:51:23', 1),
    (46, 11, 41, 'felis sed interdum venenatis turpis enim blandit mi in porttitor', '2016-11-12 17:48:07', 1),
    (47, 19, 24, 'diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus', '2016-09-09 20:30:09', 1),
    (48, 66, 49, 'lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper', '2016-07-08 04:43:19', 1),
    (49, 48, 36, 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel', '2016-11-10 01:52:05', 0),
    (50, 78, 31, 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices', '2016-05-12 20:10:27', 1),
    (51, 25, 34, 'morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus', '2016-08-16 21:46:44', 1),
    (52, 16, 8, 'primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat', '2017-03-21 20:11:21', 0),
    (53, 17, 32, 'lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', '2016-10-15 10:03:44', 1),
    (54, 27, 32, 'ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend', '2017-01-31 12:31:44', 0),
    (55, 38, 43, 'velit eu est congue elementum in hac habitasse platea dictumst morbi', '2016-11-05 04:07:57', 0),
    (56, 99, 9, 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus', '2016-08-11 15:15:30', 0),
    (57, 91, 33, 'in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus', '2017-02-22 12:14:41', 0),
    (58, 53, 27, 'vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at', '2016-08-11 07:17:59', 1),
    (59, 66, 4, 'vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur', '2016-09-06 22:02:07', 1),
    (60, 66, 42, 'leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero', '2016-12-01 07:42:13', 1),
    (61, 13, 34, 'posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet', '2016-12-13 06:23:54', 1),
    (62, 63, 21, 'rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id', '2017-01-16 04:30:33', 1),
    (63, 55, 30, 'ante ipsum primis in faucibus orci luctus et ultrices posuere', '2017-01-05 15:06:06', 1),
    (64, 26, 44, 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui', '2017-02-22 20:11:46', 0),
    (65, 22, 24, 'ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate', '2017-04-07 05:45:45', 0),
    (66, 36, 32, 'pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac', '2017-03-13 10:51:08', 0),
    (67, 90, 30, 'sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam', '2016-11-03 06:05:02', 1),
    (68, 48, 31, 'ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan', '2016-06-03 14:59:46', 1),
    (69, 34, 33, 'nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices', '2016-12-02 12:38:55', 0),
    (70, 86, 39, 'dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis', '2016-11-04 09:46:37', 0),
    (71, 79, 27, 'id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo', '2017-01-09 00:49:39', 1),
    (72, 40, 5, 'ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac', '2016-09-28 13:56:33', 0),
    (73, 92, 35, 'nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit', '2016-05-22 16:27:09', 0),
    (74, 34, 23, 'sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum', '2016-12-26 20:38:51', 1),
    (75, 61, 11, 'in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec', '2016-12-07 03:11:10', 0),
    (76, 78, 45, 'mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl', '2016-10-30 07:06:55', 0),
    (77, 63, 49, 'in faucibus orci luctus et ultrices posuere cubilia curae donec', '2016-09-21 19:21:41', 0),
    (78, 88, 2, 'nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at', '2017-03-03 08:56:48', 1),
    (79, 95, 10, 'sapien arcu sed augue aliquam erat volutpat in congue etiam', '2016-08-14 00:56:53', 0),
    (80, 65, 10, 'nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi', '2016-05-02 18:45:11', 0),
    (81, 16, 35, 'dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in', '2016-11-20 07:13:12', 1),
    (82, 1, 11, 'id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante', '2017-02-16 22:24:43', 0),
    (83, 66, 40, 'magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis', '2017-03-12 08:12:38', 0),
    (84, 12, 16, 'tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat', '2016-12-18 00:10:59', 1),
    (85, 78, 39, 'mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa', '2017-04-03 13:03:53', 1),
    (86, 63, 28, 'suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes', '2016-05-09 16:23:20', 1),
    (87, 39, 31, 'morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh', '2016-10-17 15:20:56', 1),
    (88, 72, 20, 'interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam', '2016-06-30 16:05:39', 0),
    (89, 55, 7, 'lectus vestibulum quam sapien varius ut blandit non interdum in ante', '2016-08-03 15:23:42', 0),
    (90, 48, 18, 'eu sapien cursus vestibulum proin eu mi nulla ac enim in', '2016-11-24 16:38:16', 1),
    (91, 95, 17, 'dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien', '2016-10-06 07:11:23', 0),
    (92, 68, 11, 'amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis', '2016-10-23 19:16:56', 0),
    (93, 42, 21, 'est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus', '2017-01-22 11:22:04', 1),
    (94, 41, 41, 'eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis', '2016-06-04 23:50:40', 0),
    (95, 100, 31, 'sagittis nam congue risus semper porta volutpat quam pede lobortis ligula', '2016-11-14 15:43:21', 0),
    (96, 43, 32, 'morbi vestibulum velit id pretium iaculis diam erat fermentum justo', '2017-04-06 15:49:12', 0),
    (97, 7, 32, 'etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia', '2017-02-03 23:38:49', 1),
    (98, 75, 49, 'cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus', '2017-02-20 21:41:27', 0),
    (99, 17, 19, 'neque duis bibendum morbi non quam nec dui luctus rutrum', '2016-08-15 22:32:58', 1),
    (100, 9, 26, 'volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla', '2016-06-11 09:00:03', 0);

SET IDENTITY_INSERT dbo.Replies OFF

SET IDENTITY_INSERT dbo.Messages ON

insert into Messages (MessageID, SenderID, RecipientID, Subject, Text, DateCreated) values (1, 91, 49, 'Pre-emptive', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', '2017-01-24 17:54:53'),
    (2, 40, 68, 'Reduced', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2016-08-10 14:37:26'),
    (3, 13, 11, 'bi-directional', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2017-03-17 23:09:54'),
    (4, 85, 76, 'paradigm', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '2016-10-09 09:09:18'),
    (5, 83, 89, 'hybrid', 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2016-09-10 06:14:45'),
    (6, 44, 18, 'Seamless', 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2017-04-11 23:44:50'),
    (7, 73, 75, 'exuding', 'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2016-10-31 21:28:56'),
    (8, 9, 67, 'Re-contextualized', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2016-12-19 16:58:27'),
    (9, 46, 39, 'knowledge base', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2016-07-15 20:51:29'),
    (10, 2, 26, 'structure', 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2016-10-19 00:08:13'),
    (11, 89, 68, 'functionalities', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2017-01-03 09:40:04'),
    (12, 2, 1, 'content-based', 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2016-07-05 02:28:57'),
    (13, 54, 20, 'Switchable', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2017-03-08 18:27:24'),
    (14, 46, 97, 'flexibility', 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam.', '2017-04-10 12:08:51'),
    (15, 79, 14, 'Pre-emptive', 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2016-07-05 17:20:34'),
    (16, 75, 66, 'artificial intelligence', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2016-09-13 18:46:52'),
    (17, 89, 72, 'upward-trending', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2017-01-16 18:00:58'),
    (18, 5, 41, 'Decentralized', 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2016-11-11 20:20:01'),
    (19, 59, 25, 'modular', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2017-03-24 11:50:52'),
    (20, 54, 48, 'transitional', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2016-07-06 19:35:14'),
    (21, 1, 70, 'Configurable', 'In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2017-03-04 15:16:24'),
    (22, 44, 83, 'Streamlined', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2017-02-16 13:50:40'),
    (23, 91, 44, 'website', 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2017-02-04 19:03:40'),
    (24, 95, 38, 'implementation', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', '2016-06-19 15:01:37'),
    (25, 36, 2, 'architecture', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2016-05-27 00:09:39'),
    (26, 19, 86, 'cohesive', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2017-03-01 18:02:48'),
    (27, 94, 40, 'holistic', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2017-03-22 10:58:59'),
    (28, 59, 26, 'standardization', 'Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2017-03-11 00:35:54'),
    (29, 34, 31, 'Multi-tiered', 'Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2017-04-21 16:21:45'),
    (30, 49, 49, 'concept', 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2017-03-28 15:08:48'),
    (31, 15, 44, 'asymmetric', 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2016-08-30 08:30:12'),
    (32, 75, 15, 'Cross-group', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2016-05-06 02:39:18'),
    (33, 23, 43, 'adapter', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2017-02-08 22:49:16'),
    (34, 14, 81, 'product', 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2017-03-23 12:31:31'),
    (35, 23, 54, 'matrix', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2016-11-11 06:34:37'),
    (36, 86, 49, 'Proactive', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2016-12-29 02:34:02'),
    (37, 31, 41, 'web-enabled', 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2016-09-19 17:59:34'),
    (38, 54, 99, 'full-range', 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2017-02-02 04:18:48'),
    (39, 80, 61, 'extranet', 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2016-09-16 18:57:27'),
    (40, 78, 47, 'Robust', 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2016-10-07 06:01:17'),
    (41, 30, 92, 'De-engineered', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2017-01-30 23:43:51'),
    (42, 6, 94, 'Intuitive', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.', '2016-11-16 18:41:57'),
    (43, 59, 76, 'maximized', 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2017-01-22 13:53:29'),
    (44, 99, 83, 'help-desk', 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', '2016-07-10 09:27:37'),
    (45, 70, 31, 'workforce', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2016-07-10 14:54:02'),
    (46, 4, 62, 'attitude-oriented', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2017-03-29 20:18:49'),
    (47, 94, 84, 'Optimized', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2017-04-03 12:02:33'),
    (48, 32, 2, 'interface', 'Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2016-07-12 13:53:50'),
    (49, 43, 7, 'User-friendly', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', '2017-04-14 21:28:52'),
    (50, 81, 86, 'content-based', 'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2017-01-23 10:03:45'),
    (51, 96, 79, 'modular', 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', '2016-07-15 18:23:37'),
    (52, 97, 71, 'discrete', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2016-07-22 05:53:59'),
    (53, 28, 10, 'Progressive', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2016-05-28 12:55:36'),
    (54, 81, 4, 'Progressive', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2017-02-15 14:23:47'),
    (55, 87, 59, 'uniform', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2016-08-18 21:47:25'),
    (56, 16, 37, 'Cross-group', 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2016-08-30 16:00:55'),
    (57, 88, 54, 'Vision-oriented', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2016-08-23 09:13:57'),
    (58, 52, 46, 'installation', 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2016-09-21 01:24:27'),
    (59, 48, 67, 'Future-proofed', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2016-08-07 05:32:21'),
    (60, 56, 76, 'encryption', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2016-07-20 09:23:02'),
    (61, 63, 75, 'hardware', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2017-02-20 09:52:45'),
    (62, 51, 66, 'regional', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2017-02-27 22:56:09'),
    (63, 82, 67, 'process improvement', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', '2016-11-10 04:53:17'),
    (64, 2, 8, 'Multi-layered', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2016-12-29 09:12:52'),
    (65, 28, 1, 'Down-sized', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2017-01-22 12:21:23'),
    (66, 84, 98, 'Switchable', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2017-02-09 19:39:53'),
    (67, 91, 47, 'approach', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2017-01-17 01:40:04'),
    (68, 94, 1, 'Pre-emptive', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2017-04-17 18:49:10'),
    (69, 91, 26, 'strategy', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2016-05-24 07:19:30'),
    (70, 87, 73, 'Organic', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2017-02-19 19:08:31'),
    (71, 8, 15, 'Virtual', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2016-05-02 03:53:46'),
    (72, 43, 20, 'matrix', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '2016-12-24 10:28:25'),
    (73, 72, 66, 'heuristic', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2016-06-26 03:39:11'),
    (74, 82, 40, 'user-facing', 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2016-10-30 02:48:58'),
    (75, 98, 28, 'Universal', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '2016-05-01 08:25:07'),
    (76, 84, 73, 'Configurable', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', '2017-03-19 04:39:30'),
    (77, 27, 81, 'mission-critical', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2017-03-16 04:46:19'),
    (78, 9, 99, 'Cross-platform', 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2016-07-09 01:03:21'),
    (79, 54, 26, 'high-level', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2016-09-11 13:02:49'),
    (80, 59, 49, 'intranet', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '2017-03-14 01:36:33'),
    (81, 18, 66, 'Realigned', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2017-03-16 13:35:17'),
    (82, 23, 49, 'grid-enabled', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2016-05-13 14:25:16'),
    (83, 70, 8, 'tertiary', 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2016-10-26 17:31:31'),
    (84, 30, 52, 'Adaptive', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '2016-05-13 21:06:45'),
    (85, 92, 41, 'grid-enabled', 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', '2017-04-02 17:12:55'),
    (86, 63, 94, 'leverage', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2016-05-01 10:33:32'),
    (87, 12, 43, 'local', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', '2016-07-16 21:20:50'),
    (88, 90, 48, 'Inverse', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2017-02-26 00:58:37'),
    (89, 23, 2, 'Universal', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '2016-08-16 04:33:21'),
    (90, 4, 28, 'foreground', 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2016-05-22 16:09:41'),
    (91, 52, 58, 'impactful', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.', '2017-02-16 13:02:40'),
    (92, 21, 26, 'didactic', 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2017-01-12 03:25:06'),
    (93, 17, 9, 'asymmetric', 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', '2016-10-29 08:48:51'),
    (94, 43, 67, 'Secured', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2017-03-04 10:43:26'),
    (95, 94, 32, 'bi-directional', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2017-03-17 20:27:40'),
    (96, 23, 28, 'structure', 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', '2017-04-17 06:08:54'),
    (97, 31, 100, 'directional', 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2016-11-17 08:01:15'),
    (98, 50, 31, 'Stand-alone', 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2017-01-23 00:38:29'),
    (99, 31, 10, 'regional', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2016-10-12 06:31:12'),
    (100, 48, 68, 'algorithm', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2016-08-08 04:39:16'),
    (101, 17, 67, 'structure', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2017-03-28 18:17:31'),
    (102, 49, 67, 'Sharable', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2017-04-01 22:41:25'),
    (103, 66, 79, 'optimizing', 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2016-06-20 01:05:06'),
    (104, 38, 72, 'solution', 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2017-01-28 09:30:53'),
    (105, 7, 100, 'Up-sized', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2016-06-05 02:51:54'),
    (106, 13, 89, 'motivating', 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2016-08-07 06:02:00'),
    (107, 53, 84, 'Monitored', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2017-04-21 15:13:15'),
    (108, 2, 9, 'Devolved', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2017-03-25 11:13:23'),
    (109, 37, 45, 'open system', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2016-07-08 01:45:58'),
    (110, 97, 14, 'Progressive', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2016-07-31 08:52:13'),
    (111, 26, 49, 'paradigm', 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', '2017-03-07 22:07:23'),
    (112, 54, 72, 'info-mediaries', 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2016-11-20 04:18:51'),
    (113, 22, 67, 'intranet', 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2016-09-18 03:05:58'),
    (114, 45, 68, 'Optional', 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2016-10-10 08:17:42'),
    (115, 9, 73, 'national', 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', '2017-01-27 02:12:45'),
    (116, 51, 68, 'responsive', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2017-04-06 12:54:40'),
    (117, 65, 5, 'Fundamental', 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2016-10-28 20:50:20'),
    (118, 45, 7, 'Streamlined', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '2016-05-19 05:06:15'),
    (119, 32, 70, 'Stand-alone', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2016-09-27 03:41:51'),
    (120, 56, 61, 'groupware', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2016-11-06 11:49:49'),
    (121, 88, 16, 'dynamic', 'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2016-09-07 05:19:05'),
    (122, 26, 24, 'solution', 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2017-01-12 18:37:46'),
    (123, 38, 12, 'implementation', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2017-01-02 20:15:41'),
    (124, 24, 72, 'explicit', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo.', '2017-01-18 15:38:00'),
    (125, 89, 2, 'Diverse', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', '2016-08-03 00:06:56'),
    (126, 81, 37, 'discrete', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', '2016-11-11 17:16:05'),
    (127, 53, 30, 'Team-oriented', 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', '2016-05-25 22:59:52'),
    (128, 29, 83, 'standardization', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', '2016-07-22 07:35:55'),
    (129, 55, 29, 'workforce', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2017-02-11 11:41:36'),
    (130, 81, 72, 'Profit-focused', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2016-11-09 23:41:38'),
    (131, 26, 55, 'Re-engineered', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '2016-05-22 09:07:05'),
    (132, 55, 91, 'function', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2017-01-18 23:03:02'),
    (133, 23, 31, 'access', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2017-04-02 04:52:51'),
    (134, 98, 62, 'Front-line', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', '2017-04-18 12:53:09'),
    (135, 12, 41, 'Organized', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2017-03-09 16:54:47'),
    (136, 81, 34, 'Customizable', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '2017-01-31 19:34:48'),
    (137, 81, 62, 'bi-directional', 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2017-02-18 14:30:34'),
    (138, 42, 9, 'algorithm', 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', '2016-07-29 16:01:16'),
    (139, 44, 74, 'client-server', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '2016-08-12 20:12:13'),
    (140, 20, 50, 'full-range', 'In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2017-03-07 08:15:03'),
    (141, 62, 28, 'synergy', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2016-08-25 01:33:36'),
    (142, 13, 55, 'concept', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2017-01-15 18:26:55'),
    (143, 78, 52, 'array', 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo.', '2016-11-18 07:28:07'),
    (144, 47, 91, 'even-keeled', 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2017-02-19 11:52:59'),
    (145, 77, 27, 'discrete', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2016-06-13 20:01:57'),
    (146, 23, 1, 'zero tolerance', 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2017-04-26 06:25:21'),
    (147, 22, 4, 'high-level', 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', '2016-08-18 07:22:31'),
    (148, 85, 89, 'policy', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '2017-03-27 07:33:33'),
    (149, 52, 29, 'system-worthy', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.', '2016-11-01 03:12:30'),
    (150, 56, 80, 'Organized', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2017-04-26 11:08:41'),
    (151, 60, 16, 'Multi-layered', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', '2016-11-29 15:59:22'),
    (152, 78, 45, 'Grass-roots', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2016-09-17 07:28:03'),
    (153, 98, 16, 'mobile', 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '2017-04-07 02:26:43'),
    (154, 21, 60, 'fresh-thinking', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2017-01-13 10:42:40'),
    (155, 18, 18, 'attitude-oriented', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', '2016-10-22 17:15:11'),
    (156, 19, 39, 'Persistent', 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2017-03-27 11:09:58'),
    (157, 23, 16, 'fault-tolerant', 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '2017-04-19 02:36:32'),
    (158, 77, 44, 'secondary', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2017-01-22 16:06:08'),
    (159, 8, 54, 'archive', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2016-09-25 04:29:58'),
    (160, 18, 16, 'Self-enabling', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2016-06-30 12:57:52'),
    (161, 70, 59, 'collaboration', 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2016-06-17 23:20:44'),
    (162, 47, 99, 'neural-net', 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '2016-05-19 03:05:40'),
    (163, 3, 21, 'pricing structure', 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2017-03-13 23:41:03'),
    (164, 100, 16, 'challenge', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2016-08-15 04:49:27'),
    (165, 94, 21, 'pricing structure', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '2016-08-26 10:19:01'),
    (166, 61, 36, '4th generation', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2017-04-03 02:48:05'),
    (167, 78, 9, 'Face to face', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '2017-03-31 10:24:55'),
    (168, 26, 50, 'reciprocal', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2016-04-27 01:25:57'),
    (169, 29, 27, 'contingency', 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', '2017-03-06 17:07:51'),
    (170, 52, 63, 'scalable', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2016-07-17 11:37:03'),
    (171, 94, 22, 'capability', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2017-04-17 10:56:02'),
    (172, 93, 41, 'Profound', 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2016-08-26 15:50:41'),
    (173, 73, 29, 'Right-sized', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2017-04-17 12:06:38'),
    (174, 42, 84, 'paradigm', 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2016-07-14 23:53:55'),
    (175, 1, 91, 'impactful', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2016-05-20 01:10:35'),
    (176, 21, 37, 'application', 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2016-07-03 04:28:37'),
    (177, 76, 22, 'Synergistic', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2016-06-17 09:18:16'),
    (178, 40, 4, 'Profit-focused', 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2016-12-24 08:55:10'),
    (179, 86, 99, 'Mandatory', 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-04-03 06:19:32'),
    (180, 41, 20, 'software', 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '2016-11-02 09:45:03'),
    (181, 49, 35, 'Multi-channelled', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2017-03-28 15:29:57'),
    (182, 52, 25, 'impactful', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2017-04-11 14:40:57'),
    (183, 33, 96, 'dynamic', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2016-07-02 16:31:00'),
    (184, 70, 81, 'Enhanced', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '2016-07-30 14:13:55'),
    (185, 48, 57, 'Multi-tiered', 'Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2017-01-15 23:44:04'),
    (186, 41, 72, 'Synchronised', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2016-11-18 10:52:48'),
    (187, 58, 47, 'even-keeled', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2016-05-24 16:32:09'),
    (188, 22, 82, 'installation', 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2017-02-12 15:28:00'),
    (189, 49, 38, 'instruction set', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2017-03-24 21:03:51'),
    (190, 5, 10, 'multimedia', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2017-02-21 00:19:31'),
    (191, 42, 62, 'website', 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.', '2016-06-25 04:36:40'),
    (192, 70, 82, 'emulation', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2016-08-27 00:14:06'),
    (193, 86, 64, 'application', 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Mauris viverra diam vitae quam.', '2017-01-12 18:18:37'),
    (194, 20, 17, 'Exclusive', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', '2016-04-28 11:31:05'),
    (195, 79, 27, 'foreground', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2016-11-27 21:09:14'),
    (196, 80, 27, 'zero defect', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2016-11-14 23:25:33'),
    (197, 72, 53, 'systemic', 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2016-10-28 02:08:01'),
    (198, 15, 99, 'actuating', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2017-02-25 18:40:39'),
    (199, 94, 81, 'policy', 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '2016-06-18 20:06:16'),
    (200, 6, 97, 'User-centric', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae, Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '2017-02-11 07:08:47');

SET IDENTITY_INSERT dbo.Messages OFF



------- Stored Procedures --------


GO



CREATE PROCEDURE spDeleteUser
    @UserID        int

AS

SET NOCOUNT ON

IF NOT EXISTS(
                SELECT NULL
                FROM Users
                WHERE UserID = @UserID AND Deleted != 0
            ) BEGIN

    UPDATE Users
    SET Deleted = 1
    WHERE UserID = @UserID
    
    RETURN 1

    END

ELSE BEGIN

RETURN 0

END

GO

CREATE PROCEDURE spUpdateUser
    @UserID            int,
    @UserName        varchar(20),
    @EmailAddress    varchar(50)

AS

SET NOCOUNT ON

IF NOT EXISTS(    
                SELECT NULL
                FROM Users
                WHERE UserID != @UserID AND (EmailAddress = @EmailAddress OR UserName = @UserName)
            ) BEGIN

    UPDATE Users
    SET UserName = @UserName, EmailAddress = @EmailAddress
    WHERE UserID = @UserID
    END

    SELECT * FROM Users WHERE UserID = @UserID

GO

CREATE PROCEDURE spCreateUser
    @UserName        varchar(20),
    @EmailAddress    varchar(50),
    @Password        varchar(20)

AS

SET NOCOUNT ON

IF NOT EXISTS(    
                SELECT NULL
                FROM Users
                WHERE UserName = @UserName OR EmailAddress = @EmailAddress

            ) BEGIN

    INSERT INTO Users (UserName, EmailAddress, Password, DateCreated, LastLogin)
    VALUES(@UserName, @EmailAddress, @Password, GETDATE(), GETDATE())

    SELECT UserName, EmailAddress
    FROM Users
    WHERE UserID = @@IDENTITY

    END

ELSE BEGIN

    SELECT [UserName] = '', [EmailAddress] = ''

END

GO

CREATE PROCEDURE spUpdateUserLastLogin
    @UserID        int

AS
SET NOCOUNT ON

IF EXISTS(    SELECT NULL
            FROM Users
            WHERE UserID = @UserID
            ) BEGIN

    UPDATE Users
    SET LastLogin = GETDATE()
    WHERE UserID = @UserID

    SELECT UserName, EmailAddress
    FROM Users
    WHERE UserID = @UserID

END

GO

CREATE PROCEDURE spUpdateUserPassword
    @UserID        int,
    @Password    varchar(20)

AS
SET NOCOUNT ON

IF EXISTS(    SELECT NULL
            FROM Users
            WHERE UserID = @UserID
            ) BEGIN

    UPDATE Users
    SET Password = @Password
    WHERE UserID = @UserID

    RETURN 1
END

ELSE BEGIN
RETURN 0
END

GO

CREATE PROCEDURE spUpdatePost
    @postID            int,
@topicID   int,
@userID    int,
    @title      varchar(100),
    @text    text,
@stickied   bit
AS
SET NOCOUNT ON
IF EXISTS(    
                SELECT NULL
                FROM Posts
                WHERE PostID = @postID
    AND EXISTS(SELECT NULL FROM Users WHERE UserID = @userID)
    AND EXISTS(SELECT NULL FROM Topics WHERE TopicID = @topicID)
            )
    BEGIN
    UPDATE Posts
    SET Title = @title, Text = @text, Stickied = @stickied, UserID = @userID, TopicID = @topicID
WHERE PostID = @postID
    END
    SELECT * FROM Posts WHERE PostID = @postID

GO

CREATE PROCEDURE spDeletePost
    @PostID        int
AS
SET NOCOUNT ON
IF NOT EXISTS(
                SELECT NULL
                FROM Posts
                WHERE PostID = @PostID AND Hidden = 1
            ) BEGIN
    UPDATE Posts
    SET Hidden = 1
    WHERE PostID = @PostID
    
    RETURN 1
    END
ELSE BEGIN
RETURN 0
END

GO


CREATE PROCEDURE spCreateReply
    @PostID      int,
    @UserID        int,
@Text   text,
@DateCreated date,
@Hidden   bit
AS
SET NOCOUNT ON

IF EXISTS(    
                SELECT NULL
                FROM Posts
                WHERE PostID = @PostID
            ) AND EXISTS (    
                SELECT NULL
                FROM Users
                WHERE UserID = @UserID
            )
BEGIN
    INSERT INTO Replies (PostID, UserID, Text, DateCreated, Hidden)
    VALUES(@PostID, @UserID, @Text, GETDATE(), 0)
    SELECT *
    FROM Users
    WHERE UserID = @@IDENTITY
    END
ELSE BEGIN
    SELECT [error] = 'Could not add user, check foreign keys'
END

GO

CREATE PROCEDURE spCreateReply
    @PostID      int,
    @UserID        int,
@Text   text,
@DateCreated date,
@Hidden   bit
AS
SET NOCOUNT ON

IF EXISTS(    
                SELECT NULL
                FROM Posts
                WHERE PostID = @PostID
            ) AND EXISTS (    
                SELECT NULL
                FROM Users
                WHERE UserID = @UserID
            )
BEGIN
    INSERT INTO Replies (PostID, UserID, Text, DateCreated, Hidden)
    VALUES(@PostID, @UserID, @Text, GETDATE(), 0)
    SELECT *
    FROM Users
    WHERE UserID = @@IDENTITY
    END
ELSE BEGIN
    SELECT [error] = 'Could not add user, check foreign keys'
END

GO



CREATE PROCEDURE [deleteMessage]
    @messageId int,
    @delete bit = 1

AS

SET NOCOUNT ON

    IF @delete = 1 BEGIN        --Delete existing reply
        DELETE FROM [Messages] WHERE MessageID = @messageId
        SELECT [success] = 1

    END ELSE BEGIN
        SELECT [success] = 0
END

GO




CREATE PROCEDURE [createMessage]
    @senderId int,
    @recipientId int,
    @subject varchar(30),
    @text varchar(max)

AS

SET NOCOUNT ON

BEGIN
    INSERT INTO Messages(SenderID, RecipientID, [Subject], [Text], DateCreated)
    VALUES (@senderId, @recipientId, @subject, @text, GETDATE())
    SELECT [success] = @text
END

GO


CREATE PROCEDURE [createPost]
    @topicId int,
    @userId int,
    @title varchar(30),
    @text varchar(max)

AS

SET NOCOUNT ON

BEGIN
    INSERT INTO Posts(TopicID, UserID, Title, [Text], DateCreated)
    VALUES (@topicId, @userId, @title, @text, GETDATE())
    SELECT [success] = @text
END
-----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [deleteReply]
    @replyId int,
    @delete bit = 1

AS

SET NOCOUNT ON

    IF @delete = 1 BEGIN        --Delete existing reply
        DELETE FROM Replies WHERE ReplyID = @replyId
        SELECT [success] = 1

    END ELSE BEGIN
        SELECT [success] = 0
END


------------------- GET_SP -------------------------------







GO







-- Stored Procedures
USE Forum
GO

--DROP PROCEDURE getMessagesSentByUser
--DROP PROCEDURE getMessagesReceivedByUser
------------------------------


GO

CREATE PROCEDURE getMessagesReceivedByUser
    @userId int,
    @limit int

AS

SET NOCOUNT ON

    SELECT TOP(@limit) [To] = r.UserName, [From] = s.UserName, m.DateCreated, m.Subject, m.Text
    FROM Messages m
        JOIN Users r
            ON r.UserID = RecipientID
        JOIN Users s
            ON s.UserID = SenderID    
    WHERE m.RecipientID = @userId
    GROUP BY s.UserName, m.DateCreated, m.Subject, m.Text, r.UserName
    ORDER BY m.DateCreated DESC

-----------------------------------------------------------------------------    

GO

CREATE PROCEDURE getMessagesSentByUser
    @userId int,
    @limit int

AS

SET NOCOUNT ON

    SELECT TOP(@limit)  [From] = s.UserName, [To] = r.UserName, m.DateCreated, m.Subject, m.Text
    FROM Messages m
        JOIN Users s
            ON s.UserID = SenderID
        JOIN Users r
            ON r.UserID = RecipientID    
    WHERE m.SenderID = @userId
    GROUP BY r.UserName, m.DateCreated, m.Subject, m.Text, s.UserName
    ORDER BY m.DateCreated DESC

----------------------------------------------------------------------------------
GO

CREATE PROCEDURE getRepliesByUser
    @userId int,
    @limit int

AS

    SELECT TOP(5) u.UserName, p.Title, r.Text
    FROM Replies r, Users u, Posts p
    WHERE    r.UserID = u.UserID 
            AND p.PostID = r.PostID
    ORDER BY r.DateCreated DESC
--------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [getRepliesByUser]
    @userId int,
    @limit int

AS

SET NOCOUNT ON

BEGIN

    SELECT TOP(@limit) *
    FROM Replies
    WHERE UserID = @userId AND [Hidden] = 0 
ORDER BY DateCreated DESC

END
--------------------------------------------------------------------------------------------------------------------------
GO

CREATE PROCEDURE [getRepliesByPost]
    @postId int,
    @limit int

AS

SET NOCOUNT ON

BEGIN

    SELECT TOP(@limit) *
    FROM Replies
    WHERE PostId = @postId AND [Hidden] = 0 
    ORDER BY DateCreated DESC

END
----------------------------------------------------------------------------------------------------------------------
GO



