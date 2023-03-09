-- We want to reword the user who has boon cround the longest, Find the 5 oldest users.
SELECT * from users order by created_at limit 5 ;

-- To understand when to run the ad campaign, figure out the day of the work most users register on?
SELECT DAYNAME(created_at) AS day,
COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;

-- To target inactive users in an email ad campaign, find the users who have never postod a photo
SELECT DISTINCT id,username from users where id not in(select user_id from photos where photos.user_id=users.id);

-- Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
SELECT users.username,photos.user_id,photos.id,COUNT(*) AS Max_count FROM likes
LEFT JOIN photos ON likes.photo_id = photos.id
JOIN users ON users.id = photos.user_id
GROUP BY photo_id
ORDER BY Max_count DESC LIMIT 1;

-- The investors want to know how many times does the average user post.
SELECT ROUND((SELECT COUNT(*) FROM Photos) / (SELECT COUNT(*) FROM Users),2);

-- A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
SELECT tags.id,tags.tag_name,COUNT(*) AS Max_count FROM photo_tags
LEFT JOIN tags ON photo_tags.tag_id = tags.id
GROUP BY tag_id
ORDER BY COUNT(*) DESC LIMIT 5 ;

-- To find out if there are bots, find users who have liked every single photo on the site.
SELECT username,Count(*) AS num_likes 
FROM users 
INNER JOIN likes ON users.id = likes.user_id 
GROUP  BY likes.user_id 
HAVING num_likes = (SELECT Count(*) FROM photos); 

-- To know who the celebrities are, find users who have never commented on a photo.
select distinct id from users 
where id not in(select user_id from comments where comments.user_id=users.id)
order by id;

-- Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo
SELECT username,users.id,users.created_at as user_joining_date
FROM users 
LEFT JOIN comments ON users.id = comments.user_id 
WHERE comments.user_id IS NULL 
UNION ALL
SELECT username,users.id,Count(*) AS num_comments
FROM   users INNER JOIN comments ON users.id = comments.user_id 
GROUP  BY comments.user_id 
HAVING num_comments = (SELECT Count(*) FROM photos);
