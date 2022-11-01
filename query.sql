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
  
  
  


--Before using query above
--Table users:
--INSERT INTO users (user_id, name) VALUES (1234567, 'Иван Иванов');
--INSERT INTO users (user_id, name) VALUES (1234568, 'Петр Петров');
--INSERT INTO users (user_id, name) VALUES (1234569, 'Семен Сидоров');
--INSERT INTO users (user_id, name) VALUES (1234570, 'Алексей Алексеев');
--INSERT INTO users (user_id, name) VALUES (1234571, 'Сергей Сергеев');

--Table domains:
--INSERT INTO u1614732_perl.domains (user_id, dname) VALUES (1234567, 'ivanivanov.com');
--INSERT INTO u1614732_perl.domains (user_id, dname) VALUES (1234567, 'ivanovivan.ru');
--INSERT INTO u1614732_perl.domains (user_id, dname) VALUES (1234567, 'vanyavanya.org');
--INSERT INTO u1614732_perl.domains (user_id, dname) VALUES (1234568, 'site.com');
--INSERT INTO u1614732_perl.domains (user_id, dname) VALUES (1234569, 'site.ru');
--INSERT INTO u1614732_perl.domains (user_id, dname) VALUES (1234570, 'domain.com');
--INSERT INTO u1614732_perl.domains (user_id, dname) VALUES (1234571, 'subdomain.net');
