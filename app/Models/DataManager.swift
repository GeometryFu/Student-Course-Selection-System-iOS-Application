import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let studentsKey = "students"
    private let coursesKey = "courses"
    private let usersKey = "users"
    
    var students: [Student] = []
    var courses: [Course] = []
    var users: [User] = []
    
    private init() {
        loadData()
        // 添加示例数据
        if users.isEmpty {
            addSampleData()
        }
    }
    
    private func loadData() {
        if let studentsData = UserDefaults.standard.data(forKey: studentsKey),
           let loadedStudents = try? JSONDecoder().decode([Student].self, from: studentsData) {
            students = loadedStudents
        }
        
        if let coursesData = UserDefaults.standard.data(forKey: coursesKey),
           let loadedCourses = try? JSONDecoder().decode([Course].self, from: coursesData) {
            courses = loadedCourses
        }
        
        if let usersData = UserDefaults.standard.data(forKey: usersKey),
           let loadedUsers = try? JSONDecoder().decode([User].self, from: usersData) {
            users = loadedUsers
        }
    }
    
    private func saveData() {
        if let studentsData = try? JSONEncoder().encode(students) {
            UserDefaults.standard.set(studentsData, forKey: studentsKey)
        }
        
        if let coursesData = try? JSONEncoder().encode(courses) {
            UserDefaults.standard.set(coursesData, forKey: coursesKey)
        }
        
        if let usersData = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(usersData, forKey: usersKey)
        }
    }
    
    private func addSampleData() {
        // 添加示例课程
        let course1 = Course(id: "C001", name: "高等数学", credits: 4)
        let course2 = Course(id: "C002", name: "大学物理", credits: 3)
        let course3 = Course(id: "C003", name: "计算机基础", credits: 2)
        let course4 = Course(id: "C004", name: "英语", credits: 3)
        
        courses = [course1, course2, course3, course4]
        
        // 添加示例学生
        let student1 = Student(id: "S001", name: "张三", gender: "男", age: 18, phone: "13800138001")
        let student2 = Student(id: "S002", name: "李四", gender: "女", age: 19, phone: "13800138002")
        let student3 = Student(id: "S003", name: "王五", gender: "男", age: 18, phone: "13800138003")
        
        // 为学生添加课程
        student1.addCourse(course: course1, grade: 85.5)
        student1.addCourse(course: course2, grade: 90.0)
        student2.addCourse(course: course3, grade: 78.0)
        student2.addCourse(course: course4, grade: 82.5)
        student3.addCourse(course: course1, grade: 92.0)
        student3.addCourse(course: course3, grade: 88.0)
        
        students = [student1, student2, student3]
        
        // 添加示例用户
        let user1 = User(id: "U001", username: "student1", password: "123456", type: .student)
        let user2 = User(id: "U002", username: "student2", password: "123456", type: .student)
        let user3 = User(id: "U003", username: "student3", password: "123456", type: .student)
        let user4 = User(id: "U004", username: "teacher", password: "123456", type: .teacher)
        
        users = [user1, user2, user3, user4]
        
        saveData()
    }
    
    // 学生相关操作
    func addStudent(student: Student) {
        students.append(student)
        saveData()
    }
    
    func updateStudent(updatedStudent: Student) {
        if let index = students.firstIndex(where: { $0.id == updatedStudent.id }) {
            students[index] = updatedStudent
            saveData()
        }
    }
    
    func deleteStudent(studentId: String) {
        students.removeAll { $0.id == studentId }
        saveData()
    }
    
    func getStudent(studentId: String) -> Student? {
        return students.first { $0.id == studentId }
    }
    
    // 课程相关操作
    func addCourse(course: Course) {
        courses.append(course)
        saveData()
    }
    
    func updateCourse(updatedCourse: Course) {
        if let index = courses.firstIndex(where: { $0.id == updatedCourse.id }) {
            courses[index] = updatedCourse
            saveData()
        }
    }
    
    func deleteCourse(courseId: String) {
        courses.removeAll { $0.id == courseId }
        // 同时从所有学生的选课记录中移除该课程
        for student in students {
            student.removeCourse(courseId: courseId)
        }
        saveData()
    }
    
    func getCourse(courseId: String) -> Course? {
        return courses.first { $0.id == courseId }
    }
    
    // 选课相关操作
    func enrollStudent(studentId: String, courseId: String, grade: Double = 0.0) {
        if let student = getStudent(studentId: studentId),
           let course = getCourse(courseId: courseId) {
            // 检查是否已经选过该课程
            if !student.courses.contains(where: { $0.courseId == courseId }) {
                student.addCourse(course: course, grade: grade)
                saveData()
            }
        }
    }
    
    func dropCourse(studentId: String, courseId: String) {
        if let student = getStudent(studentId: studentId) {
            student.removeCourse(courseId: courseId)
            saveData()
        }
    }
    
    func updateGrade(studentId: String, courseId: String, grade: Double) {
        if let index = students.firstIndex(where: { $0.id == studentId }) {
            var student = students[index]
            student.updateGrade(courseId: courseId, grade: grade)
            students[index] = student
            saveData()
        }
    }
    
    // 用户相关操作
    func authenticate(username: String, password: String) -> User? {
        return users.first { $0.username == username && $0.password == password }
    }
    
    func addUser(user: User) {
        users.append(user)
        saveData()
    }
    
    func getUser(userId: String) -> User? {
        return users.first { $0.id == userId }
    }
    
    func getUserByUsername(username: String) -> User? {
        return users.first { $0.username == username }
    }
}
