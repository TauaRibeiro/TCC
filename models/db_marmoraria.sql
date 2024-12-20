CREATE DATABASE IF NOT EXISTS db_marmoraria;
USE db_marmoraria;

/*
	CREATES
*/

CREATE TABLE IF NOT EXISTS `status`(
	`id_status` INT AUTO_INCREMENT NOT NULL,
    `nome_staus` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`id_status`)
);

CREATE TABLE IF NOT EXISTS `categoria_acesso`(
	`id_categoria` INT AUTO_INCREMENT NOT NULL,
    `nome_categoria` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`id_categoria`)
);

CREATE TABLE IF NOT EXISTS `tipo_material`(
	`id_tipo` INT AUTO_INCREMENT NOT NULL,
    `nome_material` VARCHAR(50),
    PRIMARY KEY(`id_tipo`)
);

CREATE TABLE IF NOT EXISTS `ambiente`(
	`id_ambiente` INT NOT NULL,
    `nome_ambiente` VARCHAR(50),
    PRIMARY KEY(`id_ambiente`)
);

CREATE TABLE IF NOT EXISTS `endreco`(
	`id_endereco` INT AUTO_INCREMENT NOT NULL,
    `id_status` INT NOT NULL,
    `cep_endereco` VARCHAR(8) NOT NULL,
    `logradouro_endereco` VARCHAR(150) NOT NULL,
    `estado_endereco` VARCHAR(2) NOT NULL,
    `rua_endereco` VARCHAR(150) NOT NULL,
    `bairro_endereco` VARCHAR(150) NOT NULL,
    `numero_endereco` INT NOT NULL,
    
    UNIQUE KEY(`cep_endereco`),
    PRIMARY KEY(`id_endereco`),
    CONSTRAINT `fk_status_endereco` FOREIGN KEY(`id_status`) REFERENCES `status`(`id_status`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
); 

CREATE TABLE IF NOT EXISTS `cliente`(
	`id_cliente` INT AUTO_INCREMENT NOT NULL,
    `id_status` INT NOT NULL,
    `id_endereco` INT NOT NULL,
    `nome_cliente` VARCHAR(150) NOT NULL,
    `email_cliente` VARCHAR(100) NOT NULL,
    `dataNascimento_cliente` DATE NOT NULL,
    `telefone_cliente` VARCHAR(13) NOT NULL,
    `whatsapp_cliente` VARCHAR(13) NOT NULL,
    `cpf_cliente` VARCHAR(11),
    `cnpj_cliente` VARCHAR(14),
    
    UNIQUE KEY(`email_cliente`, `telefone_cliente`, `whatsapp_cliente`, `cpf_cliente`, `cnpj_cliente`),
    PRIMARY KEY(`id_cliente`),
    CONSTRAINT `fk_status_cliente` FOREIGN KEY (`id_status`) REFERENCES `status`(`id_status`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT,
	CONSTRAINT `fk_endereco_cliente` FOREIGN KEY (`id_endereco`) REFERENCES `endereco`(`id_endereco`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);
-- A terminar
CREATE TABLE IF NOT EXISTS `material`(
	`id_material` INT AUTO_INCREMENT NOT NULL,
    `id_tipoMaterial` INT NOT NULL,
    `id_status` INT NOT NULL,
    `nome_material` VARCHAR(100),
    `estoqueMinimo_material` INT NOT NULL,
    `estoqueTotal_material` INT NOT NULL,
    
    PRIMARY KEY(`id_material`)
);
-- A terminar
CREATE TABLE IF NOT EXISTS `atividade_funcionario`(
	`id_atividade` INT AUTO_INCREMENT NOT NULL,
    `id_funcionairo` INT NOT NULL,
    `tipoAcao_atividade` VARCHAR(50),
    `valoresNovos` TEXT,
    `valoresAntigos` TEXT,
	PRIMARY KEY(`id_atividade`, `id_funcionario`),
    CONSTRAINT `fk_funcionario_atividade` FOREIGN KEY(`id_funcionario`) REFERENCES ``
)