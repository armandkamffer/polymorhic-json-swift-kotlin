const val revoteJson = """
{
    "uuid": "99914ed0-987b-443d-8c43-bd73fa93a0a6",
	"type": "REVOTE"
}
"""

const val startSessionJson = """
{
    "uuid": "99914ed0-987b-443d-8c43-bd73fa93a0a6",
	"type": "START_SESSION",
    "message": {
        "sessionName": "Kotlin Test",
        "availableCards": ["ONE", "TWO"]
    }
}
"""

const val addTicketJson = """
{
    "uuid": "99914ed0-987b-443d-8c43-bd73fa93a0a6",
    "type": "ADD_TICKET",
    "message": {
        "title": "DM-10000",
        "description": "A ticket to size"
    }
}
"""