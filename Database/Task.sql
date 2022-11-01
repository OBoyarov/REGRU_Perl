SELECT 
  d.dname as 'Имя домена',
  u.user_id as 'Идентификатор пользователя',
  u.name as 'Имя пользователя'
FROM 
  domains as d
LEFT JOIN
  users as u
ON
  d.user_id = u.user_id
WHERE
  u.name = N'Иван Иванов';
