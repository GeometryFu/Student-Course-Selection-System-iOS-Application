import UIKit

class StudentTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // 创建个人信息视图控制器
        let profileVC = StudentProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "个人信息", image: UIImage(systemName: "person.fill"), tag: 0)
        
        // 创建已选课程视图控制器
        let coursesVC = StudentCoursesViewController()
        let coursesNav = UINavigationController(rootViewController: coursesVC)
        coursesNav.tabBarItem = UITabBarItem(title: "已选课程", image: UIImage(systemName: "book.fill"), tag: 1)
        
        // 创建成绩查询视图控制器
        let gradesVC = StudentGradesViewController()
        let gradesNav = UINavigationController(rootViewController: gradesVC)
        gradesNav.tabBarItem = UITabBarItem(title: "成绩查询", image: UIImage(systemName: "star.fill"), tag: 2)
        
        // 设置标签页
        viewControllers = [profileNav, coursesNav, gradesNav]
    }
}
