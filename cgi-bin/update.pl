#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

## calculamos value de cuerpo

my $q = CGI->new;
my $titulo = $q->param('titulo');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.5";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT markdown FROM wiki WHERE nombrePag=?");
$sth->execute($titulo);

my @texto;
while (my @row = $sth->fetchrow_array){
  push (@texto,@row);
}

$sth->finish;
$dbh->disconnect;

print "Content-type: text/html\n\n";
print <<HTML;

<html>
	<head>
		<link rel="icon" href="../icon/UNSA.ico">
		<link rel = "stylesheet" href = "../css/estilos.css" >
		<title> Editando Pagina</title>
		<div = style="text-align: center;">
			<img src = "../img/logoUNSA.png" width = "500" height = "227" alt = "Logo UNSA">
			<address class="autor">
				<p>Autor: Jean Carlo Chara Condori.</p>
			</address>
		</div>
	</head>

	<body >
		<div style="text-align: center;">
			<p>Editando pagina - markdown</p><br><br>
			<a href="../paginaPrincipal.html"  class="boton" >Cancelar</a> <br><br><br>

			<h1>$titulo</h1>
			 
			<form style="margin-top: 30px;" method = "GET" action="new.pl">

				<textarea class = "cuerpo" type="text" name="cuerpo">@texto</textarea><br>
				
				<input class="boton" id ="bordes1" style="background-color: black;" type="submit" value="Enviar">
				<input type = "hidden" name = "titulo" value = "$titulo">

			</form>
		</div>
	</body>

	<script>
		setInterval(bordesAleatorios,1000);
		function bordesAleatorios(){
			var x = Math.floor(Math.random() * 256);
			var y = Math.floor(Math.random() * 256);
			var z = Math.floor(Math.random() * 256);
			var color = "rgb(" + x + "," + y + "," + z + ")";
			document.getElementById('bordes1').style.border = "thick solid "+color;
		}
	</script>
</html>

HTML
