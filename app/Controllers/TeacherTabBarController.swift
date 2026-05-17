import UIKit

class TeacherTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // 创建学生管理视图控制器
        let studentsVC = StudentViewController()
        let studentsNav = UINavigationController(rootViewController: studentsVC)
        studentsNav.tabBarItem = UITabBarItem(title: "学生管理", image: UIImage(systemName: "person.fill"), tag: 0)
        
        // 创建课程管理视图控制器
        let coursesVC = CourseViewController()
        let coursesNav = UINavigationController(rootViewController: coursesVC)
        coursesNav.tabBarItem = UITabBarItem(title: "课程管理", image: UIImage(systemName: "book.fill"), tag: 1)
        
        // 创建学生选课视图控制器
        let enrollmentVC = EnrollmentViewController()
        let enrollmentNav = UINavigationController(rootViewController: enrollmentVC)
        enrollmentNav.tabBarItem = UITabBarItem(title: "学生选课", image: UIImage(systemName: "checkmark.circle.fill"), tag: 2)
        
        // 创建成绩管理视图控制器
        let gradesVC = GradeViewController()
        let gradesNav = UINavigationController(rootViewController: gradesVC)
        gradesNav.tabBarItem = UITabBarItem(title: "成绩管理", image: UIImage(systemName: "star.fill"), tag: 3)
        
        // 设置标签页
        viewControllers = [studentsNav, coursesNav, enrollmentNav, gradesNav]
    }
}
