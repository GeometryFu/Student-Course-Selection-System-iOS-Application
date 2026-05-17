import Foundation

struct CourseSelection: Codable {
    let studentId: String
    let courseId: String
    var grade: Double
    
    init(studentId: String, courseId: String, grade: Double) {
        self.studentId = studentId
        self.courseId = courseId
        self.grade = grade
    }
}
