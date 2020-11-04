import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed class Command {
    @Serializable
    @SerialName("REVOTE")
    class Revote(val uuid: String): Command()

    @Serializable
    @SerialName("START_SESSION")
    class StartSession(val uuid: String, val message: StartSessionCommandMessage): Command()

    @Serializable
    @SerialName("ADD_TICKET")
    class AddTicket(val uuid: String, val message: AddTicketCommandMessage): Command()
}

@Serializable
class StartSessionCommandMessage(val sessionName: String, val availableCards: Array<String>)

@Serializable
class AddTicketCommandMessage(val title: String, val description: String)