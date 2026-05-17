import UIKit

class EnrollmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var students = [Student]()
    private var selectedStudent: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadStudents()
    }
    
    private func setupUI() {
        title = "学生选课"
        view.backgroundColor = .white
        
        // 设置表格视图
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StudentCell")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.id) - \(student.name)"
        cell.detailTextLabel?.text = "已选课程: \(student.courses.count)门"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = students[indexPath.row]
        selectedStudent = student
        showCourseSelectionAlert(student: student)
    }
    
    private func showCourseSelectionAlert(student: Student) {
        let alert = UIAlertController(title: "为学生选课", message: "学生: \(student.name) (\(student.id))", preferredStyle: .actionSheet)
        
        // 获取所有课程
        let allCourses = DataManager.shared.courses
        // 获取学生已选课程的ID
        let enrolledCourseIds = Set(student.courses.map { $0.courseId })
        
        // 添加可选择的课程
        for course in allCourses {
            if !enrolledCourseIds.contains(course.id) {
                alert.addAction(UIAlertAction(title: "\(course.id) - \(course.name) (\(course.credits)学分)", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    DataManager.shared.enrollStudent(studentId: student.id, courseId: course.id)
                    self.loadStudents()
                })
            }
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
}
