import UIKit

class GradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadStudents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudents()
    }
    
    private func setupUI() {
        title = "成绩管理"
        view.backgroundColor = .white
        
        // 设置表格视图
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GradeCell")
        view.addSubview(tableView)
        
        // 设置布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadStudents() {
        students = DataManager.shared.students
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let student = students[section]
        return "\(student.id) - \(student.name)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students[section].courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GradeCell", for: indexPath)
        let student = students[indexPath.section]
        let selection = student.courses[indexPath.row]
        
        if let course = DataManager.shared.getCourse(courseId: selection.courseId) {
            cell.textLabel?.text = "\(course.id) - \(course.name)"
            cell.detailTextLabel?.text = "成绩: \(selection.grade)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = students[indexPath.section]
        let selection = student.courses[indexPath.row]
        
        if let course = DataManager.shared.getCourse(courseId: selection.courseId) {
            showGradeUpdateAlert(student: student, course: course, currentGrade: selection.grade)
        }
    }
    
    private func showGradeUpdateAlert(student: Student, course: Course, currentGrade: Double) {
        let alert = UIAlertController(title: "更新成绩", message: "学生: \(student.name) - 课程: \(course.name)", preferredStyle: .alert)
        
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
            
            DataManager.shared.updateGrade(studentId: student.id, courseId: course.id, grade: grade)
            self.loadStudents()
        })
        
        present(alert, animated: true)
    }
}
