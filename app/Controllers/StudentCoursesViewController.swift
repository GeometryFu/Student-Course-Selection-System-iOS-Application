import UIKit

class StudentCoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var student: Student?
    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCourses()
    }
    
    private func setupUI() {
        title = "已选课程"
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
    }
    
    private func loadCourses() {
        // 这里简化处理，假设当前登录的是第一个学生
        // 实际应用中应该根据登录用户获取对应的学生信息
        if let firstStudent = DataManager.shared.students.first {
            student = firstStudent
            // 加载学生的已选课程
            courses = firstStudent.courses.compactMap { selection in
                DataManager.shared.getCourse(courseId: selection.courseId)
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        let course = courses[indexPath.row]
        
        cell.textLabel?.text = "\(course.id) - \(course.name)"
        cell.detailTextLabel?.text = "学分: \(course.credits)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "已选课程列表"
    }
}
