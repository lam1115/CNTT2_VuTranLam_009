CREATE DATABASE office_staff_management_system;
USE office_staff_management_system;

CREATE TABLE Employees (
	employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15) UNIQUE,
    hire_date DATE DEFAULT (CURRENT_DATE),
    salary DECIMAL(18, 2) CHECK (salary > 0)
);

CREATE TABLE Employee_Details (
	detail_id INT PRIMARY KEY,
    employee_id INT UNIQUE,
    citizen_id VARCHAR(30) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    working_status VARCHAR(30),
    FOREIGN KEY(employee_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Departments  (
	department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Projects (
	project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    department_id INT,
    budget DECIMAL(18, 2) CHECK(budget > 0),
    project_status VARCHAR(30),
    FOREIGN KEY(department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Work_Assignments (
	assignment_id INT PRIMARY KEY,
    employee_id INT,
    project_id INT,
    start_date DATE NOT NULL,
    deadline DATE NOT NULL,
    completed_date DATE,
    FOREIGN KEY(employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY(project_id) REFERENCES Projects(project_id)
);

INSERT INTO Employees VALUES
(1, 'Nguyen Van A', 'anv@gmail.com', '0901234567', '2022-01-15', 12000000),
(2, 'Tran Thi B', 'btt@gmail.com', '0912345678', '2021-05-20', 18000000),
(3, 'Le Van C', 'cle@yahoo.com', '0922334455', '2023-02-10', 9500000),
(4, 'Pham Minh D', 'dpham@hotmail.com', '0933445566', '2020-11-05', 22000000),
(5, 'Hoang Anh E', 'ehoang@gmail.com', '0944556677', '2023-01-12', 15000000);

INSERT INTO Employee_Details VALUES
(1, 1, '123456789', 'Ha Noi', 'Active'),
(2, 2, '234567890', 'Hai Phong', 'Active'),
(3, 3, '345678901', 'Da Nang', 'Inactive'),
(4, 4, '456789012', 'Ho Chi Minh', 'Active'),
(5, 5, '567890123', 'Can Tho', 'Active');

INSERT INTO Departments VALUES
(1, 'IT', 'Phòng công nghệ thông tin'),
(2, 'HR', 'Phòng nhân sự'),
(3, 'Marketing', 'Phòng marketing'),
(4, 'Finance', 'Phòng tài chính'),
(5, 'Sales', 'Phòng kinh doanh');

INSERT INTO Projects VALUES 
(1, 'Website Company', 1, 50000000, 'Doing'),
(2, 'Recruitment 2025', 2, 20000000, 'Pending'),
(3, 'Ads Campaign', 3, 30000000, 'Doing'),
(4, 'Accounting System', 4, 45000000, 'Done'),
(5, 'Customer Expansion', 5, 25000000, 'Pending');

INSERT INTO Work_Assignments VALUES 
(101, 1, 1, '2024-01-10', '2024-02-10', NULL),
(102, 2, 2, '2024-02-01', '2024-03-01', '2024-02-25'),
(103, 3, 3, '2024-03-05', '2024-04-05', NULL),
(104, 4, 4, '2023-10-10', '2023-12-10', '2023-12-05'),
(105, 5, 5, '2024-04-01', '2024-05-01', NULL);

-- 1.2A Viết câu lệnh tăng thêm 5.000.000 VNĐ ngân sách cho các dự án thỏa mãn đồng thời: Thuộc phòng ban 'IT'.
UPDATE Projects
SET budget = budget + 5000000 WHERE department_id = 1;

-- 1.2B Viết câu lệnh xóa các bản ghi trong Work_Assignments thỏa mãn: Đã hoàn thành (completed_date IS NOT NULL) và có ngày bắt đầu trước năm 2024.
DELETE FROM Work_Assignments WHERE completed_date IS NOT NULL AND YEAR(start_date) < 2024;

-- 3.1: Liệt kê các thông tin dự án gồm project_id, project_name, budget của những dự án thuộc phòng ban 'IT' và có ngân sách lớn hơn 30.000.000.
SELECT project_id, project_name, budget 
FROM projects
WHERE department_id = 1 AND budget > 30000000;

-- 3.2:Liệt kê các thông tin nhân viên gồm employee_id, full_name, email của những nhân viên có ngày vào làm trong năm 2022 và email thuộc tên miền '@gmail.com'.
SELECT employee_id, full_name, email
FROM employees
WHERE email LIKE '%@gmail.com';

-- 3.3: Liệt kê danh sách nhân viên gồm employee_id, full_name, salary, trong đó danh sách được sắp xếp theo lương giảm dần và chỉ hiển thị 3 nhân viên bắt đầu từ người thứ 2 (bỏ qua người lương cao nhất).
SELECT employee_id, full_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3 OFFSET 1;

-- 4.1: Liệt kê các thông tin phân công gồm mã phân công, tên nhân viên, tên dự án, ngày bắt đầu, hạn hoàn thành, với dữ liệu được lấy từ các bảng liên quan và chỉ hiển thị các công việc chưa hoàn thành (completed_date IS NULL).
SELECT DISTINCT wa.assignment_id, e.full_name, p.project_name, wa.start_date, wa.deadline
FROM work_assignments wa
JOIN Employees e ON e.employee_id = wa.employee_id
JOIN Projects p ON p.project_id = wa.project_id
WHERE wa.completed_date IS NULL;

-- 4.2: Liệt kê tổng ngân sách dự án theo từng phòng ban gồm department_name và total_budget, chỉ hiển thị những phòng ban có tổng ngân sách lớn hơn 40.000.000.
SELECT department_name, SUM(budget) AS total_budget
FROM projects p
JOIN departments d ON d.department_id = p.department_id
GROUP BY department_name
HAVING total_budget > 40000000;

-- 4.3: Liệt kê các thông tin nhân viên gồm employee_id, full_name, working_status của những nhân viên có trạng thái làm việc là 'Active' nhưng chưa từng tham gia dự án nào có ngân sách lớn hơn 40.000.000.
SELECT e.employee_id, e.full_name, ed.working_status 
FROM employees e
JOIN work_assignments wa ON wa.employee_id = e.employee_id
JOIN projects p ON p.project_id = wa.project_id
JOIN employee_details ed ON ed.employee_id = e.employee_id
WHERE ed.working_status = 'Active' AND p.budget < 40000000; 

-- 5.1: Tạo một chỉ mục (index) tên idx_assignment_dates trên bảng Work_Assignments dựa trên hai cột start_date và completed_date nhằm tối ưu truy vấn.
CREATE INDEX idx_assignment_dates ON Work_Assignments(start_date, completed_date );

-- 5.2: Tạo một khung nhìn (view) tên vw_overdue_assignments hiển thị mã phân công, tên nhân viên, tên dự án, ngày bắt đầu và hạn hoàn thành, trong đó chỉ chứa các công việc chưa hoàn thành và đã quá hạn so với ngày hiện tại (CURDATE()).
CREATE VIEW vw_overdue_assignments AS
	SELECT DISTINCT wa.assignment_id, e.full_name, p.project_name, wa.start_date, wa.deadline 
    FROM employees e
	JOIN work_assignments wa ON wa.employee_id = e.employee_id
	JOIN projects p ON p.project_id = wa.project_id
	JOIN employee_details ed ON ed.employee_id = e.employee_id
    WHERE p.project_status <> 'Done' AND wa.deadline < NOW();

-- 6.3: Viết một trigger tên trg_after_assignment_insert sao cho khi thêm mới một phân công vào bảng Work_Assignments, hệ thống tự động cập nhật trạng thái dự án tương ứng thành 'Doing'.

-- 6.2: Viết một trigger tên trg_prevent_delete_employee ngăn chặn việc xóa nhân viên nếu nhân viên đó vẫn còn công việc chưa hoàn thành 


-- 7.1:Viết một stored procedure tên sp_check_project_budget nhận vào p_project_id và trả về p_message, trong đó: Nếu ngân sách < 20.000.000 → 'Ngân sách thấp' Nếu ngân sách từ 20.000.000 – 40.000.000 → 'Ngân sách trung bình'  Nếu ngân sách > 40.000.000 → 'Ngân sách cao'
DELIMITER //
CREATE PROCEDURE sp_check_project_budget (IN p_project_id INT)
BEGIN
	DECLARE v_budget DECIMAL(18, 2);
    
	SELECT budget INTO v_budget 
    FROM projects 
    WHERE project_id = p_project_id;
    
    IF v_budget < 20000000 THEN 
		SELECT 'Ngân sách thấp';
	ELSEIF v_budget < 40000000 THEN 
		SELECT 'Ngân sách trung bình';
	ELSE 
		SELECT 'Ngân sách cao';
    END IF;
END //
DELIMITER ;

-- 7.2: Viết một stored procedure tên sp_complete_assignment_transaction để xử lý hoàn thành công việc bằng Transaction, nhận vào p_assignment_id, gồm các bước:
-- Bước 1: Bắt đầu giao dịch (START TRANSACTION)
-- Bước 2: Kiểm tra công việc đã hoàn thành chưa — nếu completed_date IS NOT NULL → ROLLBACK + báo lỗi 'Công việc đã hoàn thành rồi'
-- Bước 3: Cập nhật completed_date = CURDATE()
-- Bước 4: Nếu tất cả công việc của dự án đã hoàn thành → cập nhật project_status = 'Done'
-- Bước 5: COMMIT nếu thành công, ROLLBACK nếu có lỗi
DELIMITER //
CREATE PROCEDURE sp_complete_assignment_transaction(IN p_assignment_id INT)
BEGIN
	DECLARE v_completed_date DATE;

	START TRANSACTION ;
		SELECT completed_date INTO v_completed_date
        FROM work_assignments WHERE assignment_id = p_assignment_id;
        
		IF v_completed_date IS NOT NULL THEN
			ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Công việc đã hoàn thành rồi';
		ELSE 
			UPDATE work_assignments 
            SET completed_date = CURDATE()
            WHERE assignment_id = P_assignment_id;
            
            IF v_completed_date IS NOT NULL THEN
				UPDATE projects
                SET project_status = 'Done'
                WHERE assignment_id = P_assignment_id;
			END IF;
		END IF;
        COMMIT;
END //
DELIMITER ;
