import UIKit

class StudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        title = "学生管理"
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
        
        // 添加添加按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStudent))
    }
    
    private func loadStudents() {
        students = DataManager.shared.students
        tableView.reloadData()
    }
    
    @objc private func addStudent() {
        let alert = UIAlertController(title: "添加学生", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "学号"
        }
        alert.addTextField { textField in
            textField.placeholder = "姓名"
        }
        alert.addTextField { textField in
            textField.placeholder = "性别"
        }
        alert.addTextField { textField in
            textField.placeholder = "年龄"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { textField in
            textField.placeholder = "电话"
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "添加", style: .default) { [weak self] _ in
            guard let self = self,
                  let id = alert.textFields?[0].text,
                  let name = alert.textFields?[1].text,
                  let gender = alert.textFields?[2].text,
                  let ageText = alert.textFields?[3].text,
                  let age = Int(ageText),
                  let phone = alert.textFields?[4].text else {
                return
            }
            
            let student = Student(id: id, name: name, gender: gender, age: age, phone: phone)
            DataManager.shared.addStudent(student: student)
            self.loadStudents()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.id) - \(student.name)"
        cell.detailTextLabel?.text = "\(student.gender), \(student.age)岁, \(student.phone)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = students[indexPath.row]
        let detailVC = StudentDetailViewController(student: student)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] _, _, completion in
            guard let self = self else { return }
            let student = self.students[indexPath.row]
            DataManager.shared.deleteStudent(studentId: student.id)
            self.loadStudents()
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
