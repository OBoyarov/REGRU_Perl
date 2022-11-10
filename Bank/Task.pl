#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use DBI;

#password for db: https://paste.reg.ru/48f9bc896bf7
my $dbh = DBI->connect("DBI:mysql:database=u1614732_perl;host=31.31.198.124;port=3306", "u1614732_perl", "see comment", { mysql_enable_utf8 => 1, RaiseError => 1, AutoCommit => 0 });

my $query_clients = "SELECT 
	cl.client_id,
    cl.name,
    cl.surname,
    cl.patronymic,
    cl.phone,
    cl.address,
    bl.balance
FROM 
	b_clients as cl
LEFT JOIN
	b_balances as bl
ON
	cl.client_id = bl.client_id";

my $query_client = $query_clients . " WHERE cl.client_id = ";

my $query_change_client = "SELECT
	client_id,
    name,
    surname,
    patronymic,
    phone,
	address 
FROM 
	u1614732_perl.b_clients
where
	client_id = ";


get '/' => sub {
	my $self = shift;
	my $sth = $dbh->prepare($query_clients);
	$sth->execute;
	$self->render(template => 'clients', sth => $sth);
};

get '/clients' => sub {
	my $self = shift;
	my $url = $self->req->url;
	my $url_query = $url->query;
	if (length($url_query) > 0) {
		if ($url =~ /\?action/) {
			my $action = $url_query->param('action');
			if ($action eq "add") {
				$self->render(template => 'client_add');
			} elsif ($action eq "change") {
				my $client_id = $url_query->param('id');
				my $query = $query_change_client . $client_id;
				my $sth = $dbh->prepare($query); $sth->execute;
				my $row = $sth->fetchrow_arrayref;
				if (defined $row) {
					my $name = @$row[1];
					my $surname = @$row[2];
					my $patronymic = @$row[3];
					my $phone = @$row[4];
					my $address = @$row[5];
					$self->render(template => 'client_change', client_id => $client_id, name => $name, surname => $surname, patronymic => $patronymic, phone => $phone, address => $address);
				} else {
					$self->render(text => 'Нет такого клиента!');
				}
			} elsif ($action eq "balance") {
				my $client_id = $url_query->param('id');
				my $query = $query_client . $client_id;
				my $sth = $dbh->prepare($query); $sth->execute;
				my $row = $sth->fetchrow_arrayref;
				if (defined $row) {
					my $name = @$row[1];
					my $surname = @$row[2];
					my $patronymic = @$row[3];
					my $balance = @$row[6];
					$self->render(template => 'client_balance', client_id => $client_id, name => $name, surname => $surname, patronymic => $patronymic, balance => $balance);
				} else {
					$self->render(text => 'Нет такого клиента!');
				}
			} else {
				$self->render(text => "Hacking attempt!");
			}
		} else {
			$self->render(text => "Hacking attempt!");
		}
	}
};

post '/client/add' => sub {
	my $self = shift;
	my $req = $self->req;
	my $name = $req->param('name');
	my $surname = $req->param('surname');
	my $patronymic = $req->param('patronymic');
	my $phone = $req->param('phone');
	my $address = $req->param('address');
	my $alert = '';

	if (length($name) == 0) {
		$alert = 'Отсутствует имя клиента!';
	} elsif (length($surname) == 0) {
		$alert = 'Отсутствует фамилия клиента!';
	} elsif (length($phone) == 0) {
		$alert = 'Отсутствует телефон клиента!';
	} elsif (length($address) == 0) {
		$alert = 'Отсутствует адрес клиента!';
	}

	if (length($alert) > 0) {
		$self->render(text => $alert);
	} else {
		my $sth = $dbh->prepare('SELECT CASE WHEN count(client_id) > 0 THEN ((SELECT client_id FROM b_clients ORDER BY client_id DESC LIMIT 1) + 1) ELSE 1000000 END as client_id FROM b_clients;');
		$sth->execute;
		my $last_id = $sth->fetchrow_arrayref->[0];
		if ($last_id =~ /^-?\d+$/) {
			eval {
			  $dbh->do('INSERT INTO b_clients (client_id, name, surname, patronymic, phone, address) VALUES (?, ?, ?, ?, ?, ?)', undef, $last_id, $name, $surname, $patronymic, $phone, $address);
			  $dbh->do('INSERT INTO b_balances (client_id) VALUES (?)', undef, $last_id);
			  $sth->finish;
			  $dbh->commit;
			  1;
			};
			if ($@) {
			  $dbh->rollback or warn "rollback failed";
			  $self->render(text => 'rollback failed');
			} else {
				my $query = $query_client . $last_id;
				my $sth = $dbh->prepare($query); $sth->execute;
				my $row = $sth->fetchrow_arrayref;

				my $client_id = @$row[0];
				my $name = @$row[1];
				my $surname = @$row[2];
				my $patronymic = @$row[3];
				my $phone = @$row[4];
				my $address = @$row[5];
				my $balance = @$row[6];
				$self->render(template => 'client_added', client_id => $client_id, name => $name, surname => $surname, patronymic => $patronymic, phone => $phone, address => $address, balance => $balance);
			}
		} else {
			$self->render(text => "Не удалось получить идентификатор клиента");
		}
	}	
};

post '/client/change' => sub {
	my $self = shift;
	my $req = $self->req;

	my $client_id = $req->param('id');
	my $name = $req->param('name');
	my $surname = $req->param('surname');
	my $patronymic = $req->param('patronymic');
	my $phone = $req->param('phone');
	my $address = $req->param('address');
	my $alert = '';

	if (length($client_id) == 0) {
		$alert = 'Отсутствует ID клиента!';
	} elsif (length($name) == 0) {
		$alert = 'Отсутствует имя клиента!';
	} elsif (length($surname) == 0) {
		$alert = 'Отсутствует фамилия клиента!';
	} elsif (length($phone) == 0) {
		$alert = 'Отсутствует телефон клиента!';
	} elsif (length($address) == 0) {
		$alert = 'Отсутствует адрес клиента!';
	}

	if (length($alert) > 0) {
		$self->render(text => $alert);
	} elsif ($client_id =~ /^-?\d+$/) {
		my $numrows = undef;
		eval {
			$dbh->do("UPDATE b_clients SET name = ?, surname = ?, patronymic = ?, phone = ?, address = ?, update_date = NOW() WHERE client_id = ?", undef, $name, $surname, $patronymic, $phone, $address, $client_id);
			$numrows = $dbh->commit;
			1;
		};
		if ($@) {
			$dbh->rollback or warn "rollback failed";
			$self->render(text => 'rollback failed');
		} else {
			if (defined $numrows) {
				my $query = $query_client . $client_id;
				my $sth = $dbh->prepare($query); $sth->execute;
				my $row = $sth->fetchrow_arrayref;

				$client_id = @$row[0];
				$name = @$row[1];
				$surname = @$row[2];
				$patronymic = @$row[3];
				$phone = @$row[4];
				$address = @$row[5];
				my $balance = @$row[6];
				$self->render(template => 'client_changed', client_id => $client_id, name => $name, surname => $surname, patronymic => $patronymic, phone => $phone, address => $address, balance => $balance);
			} else {
				$self->render(text => 'Не удалось обновить клиента!');
			}		
		}
	}
};

post '/client/delete' => sub {
	my $self = shift;
	my $req = $self->req;

	my $client_id = $req->param('id');
	my $alert = '';

	if (length($client_id) == 0) {
		$alert = 'Отсутствует ID клиента!';
	}

	if (length($alert) > 0) {
		$self->render(text => $alert);
	} else {
		my $numrows = undef;
		eval {
			$dbh->do("DELETE FROM b_clients WHERE client_id = ?", undef, $client_id);
			$dbh->do("DELETE FROM b_balances WHERE client_id = ?", undef, $client_id);
			$numrows = $dbh->commit;
			1;
		};
		if ($@) {
			$dbh->rollback or warn "rollback failed";
			$self->render(text => 'rollback failed');
		} else {
			if (defined $numrows) {
				$self->render(text => "Клиент $client_id успешно удален!");
			} else {
				$self->render(text => 'Не удалось обновить клиента!');
			}		
		}
	}
};

post '/balance/replenish' => sub {
	my $self = shift;
	my $req = $self->req;
	my $url = $self->req->url;

	my $client_id = $req->param('id');
	my $replenish = $req->param('replenish');
	my $alert = '';

	if (length($client_id) == 0) {
		$alert = 'Отсутствует ID клиента!';
	} elsif ($replenish <= 0) {
		$alert = 'Сумма перевода должна быть больше нуля!';
	}

	if (length($alert) > 0) {
		$self->render(text => $alert);
	} else {
		my $numrows = undef;
		eval {
			$dbh->do("UPDATE b_balances SET balance = balance + ?, update_date = NOW() WHERE client_id = ?;", undef, $replenish, $client_id);
			$numrows = $dbh->commit;
			1;
		};
		if ($@) {
			$dbh->rollback or warn "rollback failed";
			$self->render(text => 'rollback failed');
		} else {
			if (defined $numrows) {	
				$self->redirect_to('/clients?action=balance&id=' . $client_id);
			} else {
				$self->render(text => 'Не удалось пополнить баланс!');
			}		
		}
	}
};

post '/balance/transfer' => sub {
	my $self = shift;
	my $req = $self->req;
	my $url = $self->req->url;

	my $client_id = $req->param('id');
	my $balance = $req->param('balance');
	my $transfer_sum = $req->param('transfer');
	my $recipient_id = $req->param('recipient');
	my $alert = '';

	if (length($client_id) == 0) {
		$alert = 'Отсутствует ID клиента!';
	} elsif ($recipient_id < 1000000) {
		$alert = 'Неверный идентификатор получателя!';
	} elsif ($transfer_sum <= 0) {
		$alert = 'Сумма перевода должна быть больше нуля!';
	} elsif ($transfer_sum > $balance) {
		$alert = 'Сумма перевода не может быть больше баланса!';
	}

	if (length($alert) > 0) {
		$self->render(text => $alert);
	} else {
		my $numrows = undef;
		my $sth = $dbh->prepare("SELECT count(client_id) FROM b_balances WHERE client_id = $recipient_id");
		$sth->execute;
		my $recipient_exist = $sth->fetchrow_arrayref->[0];
		if ($recipient_exist == 1) {
			eval {
				$dbh->do("UPDATE b_balances SET balance = balance - ?, update_date = NOW() WHERE client_id = ?;", undef, $transfer_sum, $client_id);
				$dbh->do("UPDATE b_balances SET balance = balance + ?, update_date = NOW() WHERE client_id = ?;", undef, $transfer_sum, $recipient_id);
				$numrows = $dbh->commit;
				1;
			};
			if ($@) {
				$dbh->rollback or warn "rollback failed";
				$self->render(text => 'rollback failed');
			} else {
				if (defined $numrows) {	
					$self->redirect_to('/clients?action=balance&id=' . $client_id);
				} else {
					$self->render(text => 'Не удалось осуществить перевод!');
				}		
			}
		} else {
			self->render(text => 'Не найден идентификатор получателя!');
		}

	}
};

get '/client/:path' => sub {
	my $self = shift;
	$self->render(text => "Чего ты здесь забыл?");
};

app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
	<head>
		<title>Users</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	</head>
	<style>
		a {margin: 4px;}
	</style>
<body>
	<h3>Замечательный банк</h3>
	<div style="display: flex;">
		<a href="/clients" target="_blank"><button>Все клиенты</button></a>
		<a href="/clients?action=add" target="_blank"><button>Добавить нового клиента</button></a>
	</div>
</body>
</html>


@@ clients.html.ep
<!DOCTYPE html>
<html>
	<head>
		<title>Клиенты</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	</head>
<style>table, th, td {border: 1px solid; margin-top: -15px;}</style>
<body>
	<h2>Замечательный банк</h2>
	<p>Клиенты банка:</p>
	<div style="display: flex;">
		<table>
			<tr>
      			<th>client_id</th>
      			<th>name</th>
      			<th>surname</th>
      			<th>patronymic</th>
      			<th>phone</th>
      			<th>address</th>
      			<th>balance</th>
      			<th></th>
      			<th></th>
    		</tr>
    		% while (my $row = $sth->fetchrow_arrayref) {
	    		<tr>
		    		<td><%= $row->[0] %></td>
		    		<td><%= $row->[1] %></td>
		    		<td><%= $row->[2] %></td>
		    		<td><%= $row->[3] %></td>
		    		<td><%= $row->[4] %></td>
		    		<td><%= $row->[5] %></td>
		    		<td><%= $row->[6] %></td>
		    		<td><a href="/clients?action=change&id=<%= $row->[0] %>" target="_blank"><button>Редактировать</button></a></td>
		    		<td><a href="/clients?action=balance&id=<%= $row->[0] %>" target="_blank"><button>Баланс</button></a></td>
	    		</tr>
		    % }
		</table>
	</div>
	</br>
	<a href="/clients?action=add" target="_blank"><button>Добавить нового клиента</button></a>
</body>
</html>


@@ client_add.html.ep
<!DOCTYPE html>
<html>
	<head>
		<title>Клиенты</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	</head>
	<style>
		.input_box {
		    display: flex;
		    flex-direction: column;
		    position: relative;
		    margin-bottom: 15px;
		    max-width: 350px;
		}
		.name_input{
		    background: #fff;
		    padding: 8px;
		    border: 1px solid #6c6c6c;
		    color: #000;

		}
		.name_input_label{
		    position: absolute;
		    color: #6c6c6c;
		    top: -10px;
		    left: 20px;
		    background: #fff;
		    padding: 0 5px;
		}
	</style>
<body>	
	<h3>Добавить нового клиента</h3>
	<form action="/client/add" method="post">
		<div class="block">
			<div class="input_box">
				<label class="name_input_label">Имя</label>
				<input type="text" class="name_input" name="name" value="">
			</div>
			<div class="input_box">
				<label class="name_input_label">Фамилия</label>
				<input type="text" class="name_input" name="surname" value="">
			</div>
			<div class="input_box">
				<label class="name_input_label">Отчество</label>
				<input type="text" class="name_input" name="patronymic" value="">
			</div>
			<div class="input_box">
				<label class="name_input_label">Телефон</label>
				<input type="text" class="name_input" name="phone" value="">
			</div>
			<div class="input_box">
				<label class="name_input_label">Адрес</label>
				<input type="text" class="name_input" name="address" value="">
			</div>
			<a><button style="width: 350px;">Добавить</button></a>
		</div>
	</form>
</body>
</html>


@@ client_added.html.ep
<!DOCTYPE html>
<html>
	<head>
		<title>Новый клиент</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	</head>
<style>table, th, td {border: 1px solid; margin: 4px;}</style>
<body>	
	<h3>Добавлен новый клиент</h3>
	<div style="display: flex;">
		<table>
			<tr>
      			<th>client_id</th>
      			<th>name</th>
      			<th>surname</th>
      			<th>patronymic</th>
      			<th>phone</th>
      			<th>address</th>
      			<th>balance</th>
    		</tr>
			<tr>
      			<td><%= $client_id %></td>
      			<td><%= $name %></td>
      			<td><%= $surname %></td>
      			<td><%= $patronymic %></td>
      			<td><%= $phone %></td>
      			<td><%= $address %></td>
      			<td><%= $balance %></td>
    		</tr>
		</table>
	</div>
</body>
</html>


@@ client_change.html.ep
<!DOCTYPE html>
<html>
	<head>
		<title>Изменить данные клиента</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	</head>
	<style>
		.input_box {
		    display: flex;
		    flex-direction: column;
		    position: relative;
		    margin-bottom: 15px;
		    max-width: 350px;
		}
		.name_input{
		    background: #fff;
		    padding: 8px;
		    border: 1px solid #6c6c6c;
		    color: #000;

		}
		.name_input_label{
		    position: absolute;
		    color: #6c6c6c;
		    top: -10px;
		    left: 20px;
		    background: #fff;
		    padding: 0 5px;
		}
	</style>
<body>	
	<h3>Изменить данные клиента</h3>
	<form action="/client/change" method="post">
		<div class="block">
			<div class="input_box">
				<label class="name_input_label">ID клиента</label>
				<input readonly type="text" class="name_input" name="id" value="<%= $client_id %>">
			</div>
			<div class="input_box">
				<label class="name_input_label">Имя</label>
				<input type="text" class="name_input" name="name" value="<%= $name %>">
			</div>
			<div class="input_box">
				<label class="name_input_label">Фамилия</label>
				<input type="text" class="name_input" name="surname" value="<%= $surname %>">
			</div>
			<div class="input_box">
				<label class="name_input_label">Отчество</label>
				<input type="text" class="name_input" name="patronymic" value="<%= $patronymic %>">
			</div>
			<div class="input_box">
				<label class="name_input_label">Телефон</label>
				<input type="text" class="name_input" name="phone" value="<%= $phone %>">
			</div>
			<div class="input_box">
				<label class="name_input_label">Адрес</label>
				<input type="text" class="name_input" name="address" value="<%= $address %>">
			</div>
			<a><button style="width: 350px;">Сохранить</button></a>
			</br></br>
			
		</div>
	</form>
	<form action="/client/delete" method="post">
		<input hidden type="text" class="name_input" name="id" value="<%= $client_id %>">
		<a><button style="width: 350px;">Удалить</button></a>
	</form>
</body>
</html>

@@ client_changed.html.ep
<!DOCTYPE html>
<html>
	<head>
		<title>Изменить данные клиента</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	</head>
<style>table, th, td {border: 1px solid; margin: 4px;}</style>
<body>	
	<h3>Изменены данные клиента</h3>
	<div style="display: flex;">
		<table>
			<tr>
      			<th>client_id</th>
      			<th>name</th>
      			<th>surname</th>
      			<th>patronymic</th>
      			<th>phone</th>
      			<th>address</th>
      			<th>balance</th>
    		</tr>
			<tr>
      			<td><%= $client_id %></td>
      			<td><%= $name %></td>
      			<td><%= $surname %></td>
      			<td><%= $patronymic %></td>
      			<td><%= $phone %></td>
      			<td><%= $address %></td>
      			<td><%= $balance %></td>
    		</tr>
		</table>
	</div>
</body>
</html>


@@ client_balance.html.ep
<!DOCTYPE html>
<html>
	<head>
		<title>Баланс клиента</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	</head>
	<style>
		.input_box {
		    display: flex;
		    flex-direction: column;
		    position: relative;
		    margin-bottom: 15px;
		    max-width: 350px;
		}
		.name_input{
		    background: #fff;
		    padding: 8px;
		    border: 1px solid #6c6c6c;
		    color: #000;

		}
		.name_input_label{
		    position: absolute;
		    color: #6c6c6c;
		    top: -10px;
		    left: 20px;
		    background: #fff;
		    padding: 0 5px;
		}
	</style>
<body>	
	<h3>Баланс клиента: <%= $name . ' ' . $surname . ' ' . $patronymic %></h3>
	<form action="/balance/replenish" method="post">
		<div class="block">
			<div class="input_box">
				<label class="name_input_label">ID клиента</label>
				<input readonly type="text" class="name_input" name="id" value="<%= $client_id %>">
			</div>
			<div class="input_box">
				<label class="name_input_label">Текущий баланс</label>
				<input disabled type="number" class="name_input" name="balance" value="<%= $balance %>">
			</div>
			<div class="input_box">
				<label class="name_input_label">Пополнить баланс</label>
				<input type="number" class="name_input" name="replenish" value="0">
			</div>
			<a><button style="width: 350px;">Пополнить</button></a>
		</div>
	</form>
	</br>
	<hr>
	<h3>Перевод другому клиенту</h3>
	<form action="/balance/transfer" method="post">
		<div class="block">
			<div class="input_box">
				<label class="name_input_label">ID текущего клиента</label>
				<input readonly type="text" class="name_input" name="id" value="<%= $client_id %>">
				<input hidden type="number" class="name_input" name="balance" value="<%= $balance %>">
			</div>				
			<div class="input_box">
				<label class="name_input_label">Введите ID получателя</label>
				<input type="text" class="name_input" name="recipient" value="">
			</div>
			<div class="input_box">
				<label class="name_input_label">Сумма перевода</label>
				<input type="number" class="name_input" name="transfer" value="0">
			</div>
			<a><button style="width: 350px;">Перевести</button></a>
		</div>
	</form>
</body>
</html>
