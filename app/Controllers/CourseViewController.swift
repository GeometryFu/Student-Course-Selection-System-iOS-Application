import UIKit

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCourses()
    }
    
    private func setupUI() {
        title = "课程管理"
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
        
        // 添加添加按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCourse))
    }
    
    private func loadCourses() {
        courses = DataManager.shared.courses
        tableView.reloadData()
    }
    
    @objc private func addCourse() {
        let alert = UIAlertController(title: "添加课程", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "课程号"
        }
        alert.addTextField { textField in
            textField.placeholder = "课程名称"
        }
        alert.addTextField { textField in
            textField.placeholder = "学分"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "添加", style: .default) { [weak self] _ in
            guard let self = self,
                  let id = alert.textFields?[0].text,
                  let name = alert.textFields?[1].text,
                  let creditsText = alert.textFields?[2].text,
                  let credits = Int(creditsText) else {
                return
            }
            
            let course = Course(id: id, name: name, credits: credits)
            DataManager.shared.addCourse(course: course)
            self.loadCourses()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        let course = courses[indexPath.row]
        cell.textLabel?.text = "\(course.id) - \(course.name)"
        cell.detailTextLabel?.text = "学分: \(course.credits)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let course = courses[indexPath.row]
        showEditCourseAlert(course: course)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] _, _, completion in
            guard let self = self else { return }
            let course = self.courses[indexPath.row]
            DataManager.shared.deleteCourse(courseId: course.id)
            self.loadCourses()
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func showEditCourseAlert(course: Course) {
        let alert = UIAlertController(title: "编辑课程", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "课程名称"
            textField.text = course.name
        }
        alert.addTextField { textField in
            textField.placeholder = "学分"
            textField.text = "\(course.credits)"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            guard let self = self,
                  let name = alert.textFields?[0].text,
                  let creditsText = alert.textFields?[1].text,
                  let credits = Int(creditsText) else {
                return
            }
            
            let updatedCourse = Course(id: course.id, name: name, credits: credits)
            DataManager.shared.updateCourse(updatedCourse: updatedCourse)
            self.loadCourses()
        })
        
        present(alert, animated: true)
    }
}
