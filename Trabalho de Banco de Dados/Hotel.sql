create database hotelaria;
use hotelaria;

/*ETAPA 01 => Criação das tabelas do MER*/
create table hospedagem(
cd_hospedagem integer primary key,
dt_entrada date,
ds_saida date,
fl_situacao char(1),
cd_cliente integer,
cd_funcionario integer,
nr_quarto integer,
foreign key(cd_funcionario) references funcionario(cd_funcionario),
foreign key(nr_quarto) references quarto(nr_quarto),
foreign key(cd_cliente) references cliente(cd_cliente)
);

create table reserva (
nr_reserva int, 
dt_reserva date,
dt_entrada date, 
qr_diarias int, 
fl_situacao char(1),
cd_cliente integer, 
nr_quarto integer, 
cd_funcionario integer,
foreign key (cd_funcionario) references funcionario(cd_funcionario),
foreign key(nr_quarto) references quarto(nr_quarto),
foreign key(cd_cliente) references cliente(cd_cliente)
);

create table hospedagem_servico(
cd_hospedagem int,
cd_servico int,
nr_sequencia int,
dt_solicitacao date,
primary key(cd_hospedagem, cd_servico, nr_sequencia),
foreign key(cd_servico) references servico(cd_servico),
foreign key(cd_hospedagem) references hospedagem(cd_hospedagem)
);

create table quarto(
nr_quarto integer primary key,
cd_categoria integer,
ds_quarto varchar(50),
nr_ocupantes integer,
foreign key(cd_categoria) references categoria(cd_categoria)
);

create table cliente (
cd_cliente integer primary key,
nm_cliente varchar(50),
ds_email varchar(50),
nr_telefone varchar(15)
);

CREATE TABLE funcionario (
cd_funcionario integer primary key,
cd_cargo integer,
nm_funcionario varchar(50),
foreign key(cd_cargo) references cargo(cd_cargo)
);

CREATE TABLE cargo(
cd_cargo integer primary key,
ds_cargo varchar(50)
);

CREATE TABLE servico(
cd_servico integer primary key,
ds_servico varchar(50)
);

CREATE TABLE categoria(
cd_categoria integer primary key,
ds_categoria varchar(50)
);

/*ETAPA 02 =>  Povoamento das seguintes estruturas com alguns 
registros: cargo, funcionário, serviço, categoria e quarto.*/

/*cargo*/
INSERT INTO cargo(cd_cargo, ds_cargo) VALUES(000, "Atendente");
INSERT INTO cargo(cd_cargo, ds_cargo) VALUES(001, "Gerente");
INSERT INTO cargo(cd_cargo, ds_cargo) VALUES(002, "Cozinheiro");
INSERT INTO cargo(cd_cargo, ds_cargo) VALUES(003, "Arrumadeira");
INSERT INTO cargo(cd_cargo, ds_cargo) VALUES(004, "Auxiliar Geral");

/*funcionario*/
INSERT INTO funcionario(cd_funcionario, cd_cargo, nm_funcionario) VALUES (001,000,"José da Silva");
INSERT INTO funcionario(cd_funcionario, cd_cargo, nm_funcionario) VALUES (000,001,"Maria da Silva");
INSERT INTO funcionario(cd_funcionario, cd_cargo, nm_funcionario) VALUES (002,002,"José Maria de Souza Cruz da Silva");
INSERT INTO funcionario(cd_funcionario, cd_cargo, nm_funcionario) VALUES (003,003,"Josefina de Souza da Silva");
INSERT INTO funcionario(cd_funcionario, cd_cargo, nm_funcionario) VALUES (004,004,"Fabiolina da Silva");

/*servico*/
INSERT INTO servico(cd_servico, ds_servico) VALUES (000, "Limpeza");
INSERT INTO servico(cd_servico, ds_servico) VALUES (001, "Guia Turistico");
INSERT INTO servico(cd_servico, ds_servico) VALUES (003, "Serviço de Quarto");
INSERT INTO servico(cd_servico, ds_servico) VALUES (004, "Atendimento Online");
INSERT INTO servico(cd_servico, ds_servico) VALUES (002, "Agendamento de reservas");

/*categoria*/
INSERT INTO categoria(cd_categoria, ds_categoria) VALUES (000, "Alimentacao");
INSERT INTO categoria(cd_categoria, ds_categoria) VALUES (001, "Premium");
INSERT INTO categoria(cd_categoria, ds_categoria) VALUES (002, "Basic");
INSERT INTO categoria(cd_categoria, ds_categoria) VALUES (003, "Executive");
INSERT INTO categoria(cd_categoria, ds_categoria) VALUES (004, "Medium Way");

/*quaerto*/
INSERT INTO quarto(nr_quarto, cd_categoria, nr_ocupantes) VALUES (000,000,2);
INSERT INTO quarto(nr_quarto, cd_categoria, nr_ocupantes) VALUES (001,001,2);
INSERT INTO quarto(nr_quarto, cd_categoria, nr_ocupantes) VALUES (002,002,2);
INSERT INTO quarto(nr_quarto, cd_categoria, nr_ocupantes) VALUES (003,003,2);
INSERT INTO quarto(nr_quarto, cd_categoria, nr_ocupantes) VALUES (004,004,2);


/*ETAPA 2 => Controle de Segurança
Para atender a Lei Geral de Proteção aos Dados (LGPD), o acesso a determinadas estruturas 
e dados serão limitados para alguns usuários. Para isso, são listadas algumas diretrizes:

a) Haverá 03 (três) grupos (papéis - roles) de usuários do sistema: Gerente, Recepcionista e o Atendente Geral;

b) O grupo "Gerente" poderá realizar qualquer operação sobre as estruturas e dados,
 além de definir acesso (dar direitos) a outros usuários.

c) O grupo "Recepcionista" poderá realizar todas as operações sobre as estruturas: 
cliente, reserva e hospedagem.

d) O grupo de usuários "Atendente Geral" poderá realizar apenas 
leitura dos dados do cliente (nome e número do quarto em que está hospedado)
 e realizar operações de inclusão e alteração na estrutura hospedagem serviço
 . Dica: avaliar possibilidade de utilização de uma visão (view) pra limitar o 
 acesso aos dados do cliente/hospedagem.*/

/*Considerando o exposto, pede-se à esta etapa 2, sentenças SQL para:

1) Criação dos papéis (roles); */
CREATE ROLE 'gerente', 'recepcionista', 'atendenteGeral';  


/*2) Designação dos privilégios para cada um dos papéis criados;*/
-- b) O grupo "Gerente" poderá realizar qualquer operação sobre as estruturas e dados,
 -- além de definir acesso (dar direitos) a outros usuários.
 GRANT ALL ON *. * TO gerente;

-- c) O grupo "Recepcionista" poderá realizar todas as operações sobre as estruturas: 
-- cliente, reserva e hospedagem.
GRANT ALL ON cliente TO recepcionista;
GRANT ALL ON reserva TO recepcionista;
GRANT ALL ON hospedagem TO recepcionista;

-- d) O grupo de usuários "Atendente Geral" poderá realizar apenas 
-- leitura dos dados do cliente (nome e número do quarto em que está hospedado)
--  e realizar operações de inclusão e alteração na estrutura hospedagem serviço
GRANT SELECT ON cliente TO atendenteGeral;
GRANT INSERT,UPDATE ON hospedagem_servico TO atendenteGeral;


/*3) Criação de, no mínimo, um usuário para cada papel criado;*/
 -- Irei realizar a cricao de 03 usuarios => gerente, recepcionista e atendenteGeral
 CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'gerente';
 CREATE USER 'recepcionista'@'localhost' IDENTIFIED BY 'recepcionista';
 CREATE USER 'atendenteGeral'@'localhost' IDENTIFIED BY 'atendenteGeral';
 
GRANT gerente TO 'gerente'@'localhost';
GRANT recepcionista TO 'recepcionista'@'localhost';
GRANT atendenteGeral TO 'atendenteGeral'@'localhost';

/*4) Efetuar o login na interface de sua preferência (ferramenta de interação: ex. HeidiSQL) com um usuário de cada papel, realizando sequência de comandos para validar os mecanismos de segurança implementados. É necessário o registro de cada operação por meio de prints de tela exibindo mensagem de sucesso/insucesso em cada operação simulada.*/

