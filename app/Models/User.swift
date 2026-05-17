import Foundation

enum UserType {
    case student
    case teacher
}

struct User: Codable {
    let id: String
    let username: String
    let password: String
    let type: UserType
    
    init(id: String, username: String, password: String, type: UserType) {
        self.id = id
        self.username = username
        self.password = password
        self.type = type
    }
    
    // 编码和解码UserType枚举
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case password
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        let typeString = try container.decode(String.self, forKey: .type)
        type = typeString == "student" ? .student : .teacher
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(type == .student ? "student" : "teacher", forKey: .type)
    }
}
