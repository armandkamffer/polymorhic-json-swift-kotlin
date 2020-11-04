import Foundation

// MARK: - JSON
let revoteJson = """
{
    "uuid": "99914ed0-987b-443d-8c43-bd73fa93a0a6",
    "type": "REVOTE"
}
"""

let startSessionJson = """
{
    "uuid": "99914ed0-987b-443d-8c43-bd73fa93a0a6",
    "type": "START_SESSION",
    "message": {
        "sessionName": "Swift Test",
        "availableCards": ["ONE", "TWO"]
    }
}
"""

let addTicketJson = """
{
    "uuid": "99914ed0-987b-443d-8c43-bd73fa93a0a6",
    "type": "ADD_TICKET",
    "message": {
        "title": "DM-10000",
        "description": "A ticket to size"
    }
}
"""

// MARK: - Models
enum CommandKey: String {
    case revote = "REVOTE"
    case startSession = "START_SESSION"
    case addTicket = "ADD_TICKET"
}

enum Command: Codable {
    case revote(uuid: UUID)
    case startSession(uuid: UUID, message: StartSessionCommandMessage)
    case addTicket(uuid: UUID, message: AddTicketCommandMessage)
    
    var rawValue: String {
        switch self {
        case .revote: return CommandKey.revote.rawValue
        case .startSession: return CommandKey.startSession.rawValue
        case .addTicket: return CommandKey.addTicket.rawValue
        }
    }
}

extension Command {
    private enum CodingKeys: String, CodingKey {
        case uuid
        case type
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        
        guard let commandKey = CommandKey(rawValue: type) else {
            throw DecodingError.keyNotFound(CodingKeys.message, DecodingError.Context(codingPath: [], debugDescription: "Invalid key: \(type)"))
        }
        
        switch commandKey {
        case .revote:
            self = .revote(uuid: uuid)
        case .startSession:
            let message = try container.decode(StartSessionCommandMessage.self, forKey: .message)
            self = .startSession(uuid: uuid, message: message)
        case .addTicket:
            let message = try container.decode(AddTicketCommandMessage.self, forKey: .message)
            self = .addTicket(uuid: uuid, message: message)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .type)
        
        switch self {
        case .revote(let uuid):
            try container.encode(uuid, forKey: .uuid)
        case .startSession(let uuid, let message):
            try container.encode(uuid, forKey: .uuid)
            try container.encode(message, forKey: .message)
        case .addTicket(let uuid, let message):
            try container.encode(uuid, forKey: .uuid)
            try container.encode(message, forKey: .message)
        }
    }
}

struct StartSessionCommandMessage: Codable {
    let sessionName: String
    let availableCards: [String]
}

struct AddTicketCommandMessage: Codable {
    let title: String
    let description: String
}

// MARK: - Methods
func parse(json: String) -> Command? {
    guard let data = json.data(using: .utf8) else { return nil }
    return try? JSONDecoder().decode(Command.self, from: data)
}

func toJson(command: Command?) -> String? {
    guard
        let command = command,
        let data = try? JSONEncoder().encode(command)
    else { return nil }
    return String(data: data, encoding: .utf8)
}

func execute(command: Command?) {
    guard let command = command else { return }
    switch command {
    case .revote(let uuid):
        print("\nRevote")
        print(uuid)
    case .startSession(let uuid, let message):
        print("\nStartSession")
        print(uuid)
        print(message.sessionName)
    case .addTicket(let uuid, let message):
        print("\nAddTicket")
        print(uuid)
        print(message.title)
    }
}

// MARK: - Encoding and Decoding
let uuid = UUID().uuidString

print("****** Deserialization ******")
let command1 = parse(json: revoteJson)
let command2 = parse(json: startSessionJson)
let command3 = parse(json: addTicketJson)

execute(command: command1)
execute(command: command2)
execute(command: command3)

print("\n****** Serialization ******")
print(toJson(command: command1))
print(toJson(command: command2))
print(toJson(command: command3))
