CREATE TABLE `aterrizar`.`usuario` (
  `idusuario` INT NOT NULL AUTO_INCREMENT,
  `nombreUsuario` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  `emailVerificado` TINYINT(1) NOT NULL DEFAULT 0,
  `contrasenia` VARCHAR(45) NOT NULL,
  `codigoEmail` VARCHAR(45) NOT NULL,

  PRIMARY KEY (`idusuario`),
  UNIQUE INDEX `nombreUsuario_UNIQUE` (`nombreUsuario` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC));
  ALTER TABLE `aterrizar`.`usuario`
ADD COLUMN `fechaNacimiento` DATETIME NULL DEFAULT NULL AFTER `codigoEmail`;
