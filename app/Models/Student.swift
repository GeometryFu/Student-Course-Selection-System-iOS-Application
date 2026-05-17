import Foundation

struct Student: Codable {
    let id: String
    var name: String
    var gender: String
    var age: Int
    var phone: String
    var courses: [CourseSelection] = []
    
    init(id: String, name: String, gender: String, age: Int, phone: String) {
        self.id = id
        self.name = name
        self.gender = gender
        self.age = age
        self.phone = phone
    }
    
    mutating func addCourse(course: Course, grade: Double) {
        let selection = CourseSelection(studentId: id, courseId: course.id, grade: grade)
        courses.append(selection)
    }
    
    mutating func removeCourse(courseId: String) {
        courses.removeAll { $0.courseId == courseId }
    }
    
    mutating func updateGrade(courseId: String, grade: Double) {
        if let index = courses.firstIndex(where: { $0.courseId == courseId }) {
            courses[index].grade = grade
        }
    }
}
