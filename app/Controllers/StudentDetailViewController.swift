import UIKit

class StudentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var student: Student
    private var courses: [Course] = []
    
    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCourses()
    }
    
    private func setupUI() {
        title = "学生详情"
        view.backgroundColor = .white
        
        // 设置表格视图
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CourseCell")
        view.addSubview(tableView)
        
        // 设置布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // 添加编辑按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editStudent))
    }
    
    private func loadCourses() {
        // 加载学生的选课记录对应的课程信息
        courses = student.courses.compactMap { selection in
            DataManager.shared.getCourse(courseId: selection.courseId)
        }
        tableView.reloadData()
    }
    
    @objc private func editStudent() {
        let alert = UIAlertController(title: "编辑学生信息", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "姓名"
            textField.text = self.student.name
        }
        alert.addTextField { textField in
            textField.placeholder = "性别"
            textField.text = self.student.gender
        }
        alert.addTextField { textField in
            textField.placeholder = "年龄"
            textField.text = "\(self.student.age)"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { textField in
            textField.placeholder = "电话"
            textField.text = self.student.phone
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            guard let self = self,
                  let name = alert.textFields?[0].text,
                  let gender = alert.textFields?[1].text,
                  let ageText = alert.textFields?[2].text,
                  let age = Int(ageText),
                  let phone = alert.textFields?[3].text else {
                return
            }
            
            self.student.name = name
            self.student.gender = gender
            self.student.age = age
            self.student.phone = phone
            
            DataManager.shared.updateStudent(updatedStudent: self.student)
            self.tableView.reloadData()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "基本信息" : "已选课程"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "学号: \(student.id)"
            cell.detailTextLabel?.text = "姓名: \(student.name), 性别: \(student.gender), 年龄: \(student.age)岁, 电话: \(student.phone)"
        } else {
            let course = courses[indexPath.row]
            if let selection = student.courses.first(where: { $0.courseId == course.id }) {
                cell.textLabel?.text = "\(course.id) - \(course.name)"
                cell.detailTextLabel?.text = "学分: \(course.credits), 成绩: \(selection.grade)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let course = courses[indexPath.row]
            if let selection = student.courses.first(where: { $0.courseId == course.id }) {
                showGradeUpdateAlert(course: course, currentGrade: selection.grade)
            }
        }
    }
    
    private func showGradeUpdateAlert(course: Course, currentGrade: Double) {
        let alert = UIAlertController(title: "更新成绩", message: "课程: \(course.name)", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "成绩"
            textField.text = "\(currentGrade)"
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            guard let self = self,
                  let gradeText = alert.textFields?[0].text,
                  let grade = Double(gradeText) else {
                return
            }
            
            DataManager.shared.updateGrade(studentId: self.student.id, courseId: course.id, grade: grade)
            self.loadCourses()
        })
        
        present(alert, animated: true)
    }
}
