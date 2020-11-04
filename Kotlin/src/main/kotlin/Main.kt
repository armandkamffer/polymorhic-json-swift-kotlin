import kotlinx.serialization.*
import kotlinx.serialization.json.Json

fun main() {
    println("****** Deserialization ******")
    val command1 = parseJson(revoteJson)
    val command2 = parseJson(startSessionJson)
    val command3 = parseJson(addTicketJson)

    executeCommand(command1)
    executeCommand(command2)
    executeCommand(command3)

    println("\n****** Serialization ******")
    println(Json.encodeToString(command1))
    println(Json.encodeToString(command2))
    println(Json.encodeToString(command3))
}

fun parseJson(json: String): Command {
    val format = Json {  }
    return format.decodeFromString(json)
}

fun executeCommand(command: Command?) {
    when(command) {
        is Command.Revote -> {
            println("Revote")
            println(command.uuid)
        }
        is Command.StartSession -> {
            println("StartSession")
            println(command.message.sessionName)
        }
        is Command.AddTicket -> {
            println("AddTicket")
            println(command.message.title)
        }
    }
}