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

CREATE TABLE IF NOT EXISTS `endereco`(
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

CREATE TABLE IF NOT EXISTS `material`(
	`id_material` INT AUTO_INCREMENT NOT NULL,
    `id_tipoMaterial` INT NOT NULL,
    `id_status` INT NOT NULL,
    `nome_material` VARCHAR(100) NOT NULL,
    `estoqueMinimo_material` INT NOT NULL,
    `estoqueTotal_material` INT NOT NULL,
    
    PRIMARY KEY(`id_material`),
    CONSTRAINT `fk_tipo_material` FOREIGN KEY (`id_tipoMaterial`) REFERENCES `tipo_material`(`id_tipo`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT,
	CONSTRAINT `fk_status_material` FOREIGN KEY(`id_status`) REFERENCES `status`(`id_status`)
		ON UPDATE RESTRICT
        ON DELETE RESTRICT
    
);

CREATE TABLE IF NOT EXISTS `preco_material`(
	`id_preco` INT AUTO_INCREMENT NOT NULL,
    `id_material` INT NOT NULL,
    `valorMaterial_preco` DECIMAL(10, 2) NOT NULL,
    `dataAplicacao_preco` DATE NOT NULL,
    
    PRIMARY KEY(`id_preco`),
    CONSTRAINT `fk_material_preco` FOREIGN KEY (`id_material`) REFERENCES `material`(`id_material`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `orcamento`(
	`id_orcamento` INT AUTO_INCREMENT NOT NULL,
    `id_cliente` INT NOT NULL,
    `id_status` INT NOT NULL,
    `total_orcamento` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    `data_orcamento` DATE NOT NULL,
    
    PRIMARY KEY(`id_orcamento`),
    CONSTRAINT `fk_cliente_orcamento` FOREIGN KEY(`id_cliente`) REFERENCES `cliente`(`id_cliente`)
		ON UPDATE RESTRICT
        ON DELETE RESTRICT,
	CONSTRAINT `fk_status_orcamento` FOREIGN KEY(`id_status`) REFERENCES `status`(`id_status`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
); 

CREATE TABLE IF NOT EXISTS `item_orcamento`(
	`id_item` INT AUTO_INCREMENT NOT NULL,
    `id_orcamento` INT NOT NULL,
    `id_ambiente` INT NOT NULL,
    `id_status` INT NOT NULL,
    `quantidade_item` INT NOT NULL,
    `especificacao_item` VARCHAR(200) NOT NULL,
    `comprimento_item` DOUBLE NOT NULL,
    `largura_item` DOUBLE NOT NULL,
    `total_item` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    
    PRIMARY KEY(`id_item`),
	CONSTRAINT `fk_orcamento_item` FOREIGN KEY(`id_orcamento`) REFERENCES `orcamento`(`id_orcamento`)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT,
	CONSTRAINT `fk_ambiente_item` FOREIGN KEY(`id_ambiente`) REFERENCES `ambiente`(`id_ambiente`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT,
	CONSTRAINT `fk_status_item` FOREIGN KEY(`id_status`) REFERENCES `status`(`id_status`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `historico_cliente`(
	`id_historico` INT AUTO_INCREMENT NOT NULL,
    `id_cliente` INT NOT NULL,
    `id_item` INT,
    `id_orcamento` INT NOT NULL,
    `data_histotico` DATE NOT NULL,
    `tipoAcao_historico` VARCHAR(50) NOT NULL,
    
    PRIMARY KEY(`id_historico`),
    CONSTRAINT `fk_cliente_historico` FOREIGN KEY(`id_cliente`) REFERENCES `cliente`(`id_cliente`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT,
	CONSTRAINT `fk_item_historico` FOREIGN KEY(`id_item`) REFERENCES `item_orcamento`(`id_item`)
		ON UPDATE RESTRICT
        ON DELETE RESTRICT,
	CONSTRAINT `fk_orcamento` FOREIGN KEY(`id_orcamento`) REFERENCES `orcamento`(`id_orcamento`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `funcionario`(
	`id_funcionario` INT AUTO_INCREMENT NOT NULL,
    `id_categoria` INT NOT NULL,
    `id_status` INT NOT NULL,
    `nome_funcionario` VARCHAR(150) NOT NULL,
    `cpf_funcionario` VARCHAR(11) NOT NULL,
    `dataNascimento_funcionario` DATE NOT NULL,
    `dataEfetivacao_funcionario` DATE NOT NULL,
    
    PRIMARY KEY(`id_funcionario`),
    UNIQUE KEY(`cpf_funcionario`),
    CONSTRAINT `fk_acesso_funcionario` FOREIGN KEY(`id_categoria`) REFERENCES `categoria_acesso`(`id_categoria`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT,
	CONSTRAINT `fk_status_funcionario` FOREIGN KEY(`id_status`) REFERENCES `status`(`id_status`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `atividade_funcionario`(
	`id_atividade` INT AUTO_INCREMENT NOT NULL,
    `id_funcionario` INT NOT NULL,
    `tipoAcao_atividade` VARCHAR(50),
    `valoresNovos` TEXT,
    `valoresAntigos` TEXT,
    
	PRIMARY KEY(`id_atividade`),
    CONSTRAINT `fk_funcionario_atividade` FOREIGN KEY(`id_funcionario`) REFERENCES `funcionario`(`id_funcionario`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `salario_funcionario`(
	`id_salario` INT AUTO_INCREMENT NOT NULL,
    `id_funcionario` INT NOT NULL,
    `valor_salario` DECIMAL(10, 2) NOT NULL,
    `dataAplicacao_salario` DATE NOT NULL,
    
    PRIMARY KEY(`id_salario`),
    CONSTRAINT `fk_funcionario_salario` FOREIGN KEY(`id_funcionario`) REFERENCES `funcionario`(`id_funcionario`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `pagamento`(
	`id_pagamento` INT AUTO_INCREMENT NOT NULL,
    `id_orcamento` INT,
    `id_funcionario` INT,
    `id_status` INT NOT NULL,
    `data_pagamento` DATE NOT NULL,
    `valor_pagamento` DECIMAL(10, 2) NOT NULL,
    
    PRIMARY KEY(`id_pagamento`),
    CONSTRAINT `fk_orcamento_pagamento` FOREIGN KEY(`id_orcamento`) REFERENCES `orcamento`(`id_orcamento`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT,
	CONSTRAINT `fk_funcionario_pagamento` FOREIGN KEY(`id_funcionario`) REFERENCES `funcionario`(`id_funcionario`)
		ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

/*
	CREATES
*/
/*
	TRIGGERS
*/

DELIMITER //
CREATE TRIGGER `tr_insertBefore_funcionario`
BEFORE INSERT ON `funcionario`
FOR EACH ROW
BEGIN
END//
DELIMITER ;




/*
	TRIGGERS
*/
