DROP DATABASE IF EXISTS AI ;
CREATE DATABASE IF NOT EXISTS 		AI;
-- use
USE AI;
-- DROP TABLE 
	DROP TABLE IF EXISTS Work_Done;
	DROP TABLE IF EXISTS Project_Modules;
	DROP TABLE IF EXISTS Projects;
	DROP TABLE IF EXISTS Employee;
    
-- create table
DROP TABLE IF EXISTS 	Employee;
CREATE TABLE		 Employee (
		EmployeeID				TINYINT AUTO_INCREMENT PRIMARY KEY,
        EmployeeLastName		NVARCHAR(20) NOT NULL,
        EmployeeFistName		NVARCHAR(10) NOT NULL,
        EmployeeHireDate		DATE NOT NULL,
        EmployeeStatus			VARCHAR(20),
        SupervisorID			TINYINT NOT NULL,
        SocialSecurityNumber	INT NOT NULL
);

CREATE TABLE  		Projects (
		ProjectID 					CHAR(20)  PRIMARY KEY,
        EmployeeID					TINYINT NOT NULL,
        Projectname					NVARCHAR(30) NOT NULL,
        ProjectStartDate			DATE NOT NULL,
        ProjectDescription			VARCHAR(50) NOT NULL,
        ProjectDetailt				VARCHAR(30) NOT NULL,
        ProjectCompletedOn			DATE NOT NULL,
		FOREIGN KEY ( EmployeeID) REFERENCES  Employee(EmployeeID)
        );
        
CREATE TABLE 		Project_Modules (
			ModuleID 						CHAR(20)  PRIMARY KEY,
            ProjectID 						CHAR(20) NOT NULL,
			EmployeeID						TINYINT NOT NULL,
			ProjectModulesDate				DATE NOT NULL,
            ProjectModulesCompledOn			DATE NOT NULL,
            ProjectModulesDescription		VARCHAR(500) NOT NULL,
		FOREIGN KEY ( EmployeeID) REFERENCES  Employee(EmployeeID),
		FOREIGN KEY ( ProjectID) REFERENCES  Projects( ProjectID)
        ON DELETE CASCADE 
);

CREATE TABLE		Work_Done (
			WorkDoneID				TINYINT  AUTO_INCREMENT  PRIMARY KEY,
            EmployeeID				TINYINT NOT NULL,
            ModuleID				CHAR(20) NOT NULL,
            WorkDoneDate			DATE ,
            WorkDoneDescription		VARCHAR(50) NOT NULL,
            WorkDoneStatus			VARCHAR(50) NOT NULL,
			FOREIGN KEY ( EmployeeID) REFERENCES  Employee(EmployeeID),
            FOREIGN KEY ( ModuleID) REFERENCES  Project_Modules(ModuleID) ON DELETE CASCADE
);

-- them ban ghi du lieu
INSERT INTO   Employee (EmployeeLastName,  EmployeeFistName,  EmployeeHireDate, EmployeeStatus,  SupervisorID, SocialSecurityNumber)
VALUES					('nguyen van ',       	'a',		  '1999-02-04',		'đã nghỉ'	,			2,			1111),
						('nguyen van',			'b',		  '1999-03-05',		'đã nghỉ',              1,		    2222),
						('nguyen van ',			'c',		  '1998-04-06',		'đang làm việc',		2,			3333),
						('nguyen van ',			'd',		  '1998-05-07',		'đang nghỉ',			3,			4444),
						('nguyen van',			'e',		  '1998-06-08',		'đang làm việc',		2,			5555);
						
INSERT INTO   Projects(ProjectID, EmployeeID, Projectname,  ProjectStartDate, ProjectDescription, ProjectDetailt, ProjectCompletedOn )
VALUES					( 'DA1', 		1,			'game',		'1999-04-02',		'MT 1',			'CV 1',		'2019-09-03'),	
						( 'DA2', 		3,			'co',       '1999-02-02',		'MT 2',			'CV 2',		'2019-10-04'),	
						( 'DA3', 		2,			'xay dung',	'1999-01-03',		'MT 3',			'CV 3',		'2019-12-05'),	
						( 'DA4', 		5,			'ha nam',   '1999-03-04',		'MT 4',			'CV 4',		'2019-11-06'),	
						( 'DA5', 		4,			'zalo ',	'1999-05-05',		'MT 5',			'CV 5',		'2019-11-07');
                    
INSERT INTO Project_Modules
						(ModuleID ,  ProjectID,   EmployeeID,	ProjectModulesDate,  ProjectModulesCompledOn,  ProjectModulesDescription )

VALUES					('XD1',		'DA1',			3,			'2011-04-02',			'2003-04-07',			'PMD 1'),
						('XD2',		'DA2',			1,			'2012-05-03',			'2004-03-08',			'PMD 2'),
						('XD3',		'DA3',			2,			'2013-06-04',			'2005-01-09',			'PMD 3'),
						('XD4',		'DA4',			2,			'2014-07-15',			'2006-02-11',			'PMD 4'),
						('XD5',		'DA5',			4,			'2015-08-02',			'2007-07-12',			'PMD 5');
                                

INSERT INTO Work_Done(EmployeeID,  ModuleID, WorkDoneDate, WorkDoneDescription, WorkDoneStatus )                     	
VALUES					( 3,		'XD1',		'2008-08-03',	 'game 1', 	'hoan thanh 10%   game'),
						( 2,		'XD2',			null,		 'game 2',	'hoan thanh 20%   game'),
						( 1,		'XD3',		'2016-09-05',	 'game 3',	'hoan thanh 30%   game'),
						( 4,		'XD4',		'2020-06-07',	 'game 5',	'hoan thanh 100%  game'),
						( 5,		'XD5',			null,		 'game 4',	'hoan thanh 90%   game');
      

-- EX2 : Viết stored procedure (không có parameter) để Remove tất cả thông tin project đã hoàn thành sau 3 tháng kể từ ngày hiện. 
-- In số lượng record đã remove từ các table liên quan trong khi removing (dùng lệnh printf)

-- use
USE AI;
-- drop
DROP PROCEDURE IF EXISTS get_Projects;
DELIMITER $$
CREATE PROCEDURE get_Projects()
BEGIN 
		-- B1: tìm ra các ProjectID cần xóa   
			-- khai báo 1 biến để lưu lại kết quả ProjectID cần xóa
            DROP TABLE IF EXISTS 	ProjectIDCanXoa;
			CREATE TEMPORARY TABLE 	ProjectIDCanXoa (
											ProjectID CHAR(10)
			); 
            -- gán data vào biến 
			INSERT INTO ProjectIDCanXoa (ProjectID)
				SELECT  ProjectID
				FROM 	Projects
				WHERE 	SUBDATE(CURDATE(), INTERVAL 90 DAY) > ProjectCompletedOn;
        -- B2: tìm các moduleID cần xóa
			-- khai báo 1 biến để lưu lại kết quả ProjectID cần xóa
				DROP TABLE IF EXISTS 		ModuleIDCanXoa;
				CREATE TEMPORARY TABLE		ModuleIDCanXoa (
														ModuleID CHAR(20)
				); 
						-- gán data vào biến                                         
				INSERT INTO 		ModuleIDCanXoa (ModuleID)
					SELECT 	  		ModuleID
					FROM			Project_Modules
					WHERE 			ProjectID IN (	SELECT	ProjectID 
													FROM 	ProjectIDCanXoa
													);
        -- START TRANSACTION
        START TRANSACTION;
			-- B3: xóa workdone dựa vào workdoneID
			DELETE 
			FROM  	Work_Done
			WHERE 	ModuleID IN (	SELECT 	ModuleID 
									FROM 	ModuleIDCanXoa
									); 
			
			-- B4: xóa Project_Modules dựa vào ModuleID
			DELETE   
			FROM 	 	Project_Modules
			WHERE		ModuleID IN (	SELECT 	ModuleID
										FROM 	ModuleIDCanXoa
									) ;
								
			-- B5: xóa project dựa vào ProjectID
			DELETE   
			FROM 	 	Projects
			WHERE 		ProjectID IN (	SELECT 	ProjectID
										FROM 	ProjectIDCanXoa
										);
		-- END TRANSACTION
        COMMIT;
END $$
DELIMITER ;
CALL get_Projects;

-- EX 3 Viết stored procedure (có parameter) để in ra các module đang được thực hiện)
DROP PROCEDURE IF EXISTS get_module;
DELIMITER $$
CREATE PROCEDURE get_module()
BEGIN
			SELECT 	ModuleID
            FROM 	Project_Modules 
            WHERE  ProjectModulesCompledOn > CURDATE();
			
		END$$
DELIMITER ;
CALL  get_module();

-- EX4 Viết hàm (có parameter) trả về thông tin 1 nhân viên đã tham gia làm mặc dù không ai giao việc cho nhân viên đó (trong bảng Works) 

DROP FUNCTION IF EXISTS get_employee;
DELIMITER $$
CREATE FUNCTION get_employee()  RETURNS TINYINT
BEGIN
		DECLARE 			out_EmployeeID TINYINT(20);
        
		SELECT 				W.EmployeeID  INTO out_EmployeeID
        FROM				Project_Modules PM
        RIGHT JOIN			Work_Done W ON (PM.EmployeeID = W.EmployeeID)
        WHERE				PM.EmployeeID IS NULL;
        
        RETURN out_EmployeeID;
	END$$
DELIMITER ;
SELECT 	get_employee();
