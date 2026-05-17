import UIKit

class StudentProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadStudentInfo()
    }
    
    private func setupUI() {
        title = "个人信息"
        view.backgroundColor = .white
        
        // 设置表格视图
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
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
    
    private func loadStudentInfo() {
        // 这里简化处理，假设当前登录的是第一个学生
        // 实际应用中应该根据登录用户获取对应的学生信息
        if let firstStudent = DataManager.shared.students.first {
            student = firstStudent
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        guard let student = student else { return cell }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "学号"
            cell.detailTextLabel?.text = student.id
        case 1:
            cell.textLabel?.text = "姓名"
            cell.detailTextLabel?.text = student.name
        case 2:
            cell.textLabel?.text = "性别"
            cell.detailTextLabel?.text = student.gender
        case 3:
            cell.textLabel?.text = "年龄"
            cell.detailTextLabel?.text = "\(student.age)岁"
        case 4:
            cell.textLabel?.text = "电话"
            cell.detailTextLabel?.text = student.phone
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "基本信息"
    }
}
