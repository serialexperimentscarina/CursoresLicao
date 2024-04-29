CREATE DATABASE cursores_licao_de_casa
GO
USE cursores_licao_de_casa
GO
create table envio (
CPF varchar(20),
NR_LINHA_ARQUIV int,
CD_FILIAL int,
DT_ENVIO datetime,
NR_DDD int,
NR_TELEFONE varchar(10),
NR_RAMAL varchar(10),
DT_PROCESSAMENT datetime,
NM_ENDERECO varchar(200),
NR_ENDERECO int,
NM_COMPLEMENTO varchar(50),
NM_BAIRRO varchar(100),
NR_CEP varchar(10),
NM_CIDADE varchar(100),
NM_UF varchar(2))
GO
create table endereço(
CPF varchar(20),
CEP varchar(10),
PORTA int,
ENDERECO varchar(200),
COMPLEMENTO varchar(100),
BAIRRO varchar(100),
CIDADE varchar(100),
UF Varchar(2))
GO
create procedure sp_insereenvio
as
declare @cpf as int
declare @cont1 as int
declare @cont2 as int
declare @conttotal as int
set @cpf = 11111
set @cont1 = 1
set @cont2 = 1
set @conttotal = 1
while @cont1 <= @cont2 and @cont2 < = 100
begin
insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
values (cast(@cpf as varchar(20)), @cont1,GETDATE())
insert into endereço (CPF,PORTA,ENDERECO)
values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
set @cont1 = @cont1 + 1
set @conttotal = @conttotal + 1
if @cont1 > = @cont2
begin
set @cont1 = 1
set @cont2 = @cont2 + 1
set @cpf = @cpf + 1
end
end
GO
exec sp_insereenvio
GO
select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc

-- Procedure com cursor
CREATE PROCEDURE sp_mover_dados
AS
DECLARE @cont AS INT,
		@nm_endereco AS VARCHAR(200),
		@nr_endereco AS INT,
		@nm_complemento AS VARCHAR(50),
		@nm_bairro AS VARCHAR(100),
		@nr_cep AS VARCHAR(10),
		@nm_cidade AS VARCHAR(100),
		@nm_uf AS VARCHAR(2)
SET @cont = 1
DECLARE c CURSOR FOR
	SELECT ENDERECO, PORTA, COMPLEMENTO, BAIRRO, CEP, CIDADE, UF FROM endereço ORDER BY CPF ASC
OPEN C
FETCH NEXT FROM C
	INTO @nm_endereco, @nr_endereco, @nm_complemento, @nm_bairro, @nr_cep, @nm_cidade, @nm_uf
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE envio SET NM_ENDERECO = @nm_endereco, NR_ENDERECO  = @nr_endereco, NM_COMPLEMENTO = @nm_complemento, NM_BAIRRO = @nm_bairro, NR_CEP = @nr_cep,
		NM_CIDADE = @nm_cidade, NM_UF = @nm_uf WHERE NR_LINHA_ARQUIV = @cont
	FETCH NEXT FROM C
		INTO @nm_endereco, @nr_endereco, @nm_complemento, @nm_bairro, @nr_cep, @nm_cidade, @nm_uf
	SET @cont = @cont + 1
END
CLOSE C
DEALLOCATE C

EXEC sp_mover_dados