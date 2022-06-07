
INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_lspd', 'LSPD', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_lspd', 'LSPD', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_lspd', 'LSPD', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
	('lspd', 'LSPD')
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('lspd', 0, 'cadet', 'Cadet', 20, '{}', '{}'),
	('lspd', 1, 'officer', 'Officier', 40, '{}', '{}'),
	('lspd', 2, 'sergent', 'Sergent', 60, '{}', '{}'),
	('lspd', 3, 'sergent_chef', 'Sergent-Chef', 60, '{}', '{}'),
	('lspd', 4, 'caporal', 'Caporal', 60, '{}', '{}'),
	('lspd', 5, 'caporal_chef', 'Caporal-Chef', 60, '{}', '{}'),
	('lspd', 6, 'lieutenant', 'Lieutenant', 85, '{}', '{}'),
	('lspd', 7, 'capitaine', 'Capitaine', 85, '{}', '{}'),
	('lspd', 8, 'boss','Commandant', 100, '{}', '{}');
