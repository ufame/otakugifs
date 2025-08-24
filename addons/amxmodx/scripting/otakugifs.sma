#include <amxmodx>
#include <json>
#include <easy_http>

new const OTAKU_REACTIONS[][] = {
  "airkiss", "angrystare", "bite", "bleh", "blush",
  "brofist", "celebrate", "cheers", "clap", "confused",
  "cool", "cry", "cuddle", "dance", "drool", "evillaugh",
  "facepalm", "handhold", "happy", "headbang", "hug", "kiss",
  "laugh", "lick", "love", "mad", "nervous", "no", "nom",
  "nosebleed", "nuzzle", "nyah", "pat", "peek", "pinch",
  "poke", "pout", "punch", "roll", "run", "sad", "scared",
  "shrug", "shy", "sigh", "sip", "slap", "sleep", "slowclap",
  "smack", "smile", "smug", "sneeze", "sorry", "stare", "stop",
  "surprised", "sweat", "thumbsup", "tickle", "tired", "wave",
  "wink", "woah", "yawn", "yay", "yes"
}

new const OTAKU_URL[] = "https://api.otakugifs.xyz/gif"
new const GIF_COMMAND[] = "/gif"

const Float: ANTISPAM_TIME = 10.0

new Float: g_lastPlayerUse[MAX_PLAYERS + 1]

public plugin_init() {
  register_plugin("OtakuGIFs", "1.0.1", "ufame")

  register_clcmd("say", "commandGif")
  register_clcmd("say_team", "commandGif")
}

public commandGif(id) {
  new args[32]
  read_argv(1, args, charsmax(args))

  if (!equal(args, GIF_COMMAND, 4))
    return PLUGIN_CONTINUE

  if ((g_lastPlayerUse[id] + ANTISPAM_TIME) > get_gametime())
    return PLUGIN_HANDLED

  new EzHttpOptions: httpOptions = ezhttp_create_options()

  //getting reaction by name or random if no match found
  trim(args[4])
  new reactionId = GetReactionId(args[4])

  ezhttp_option_set_header(httpOptions, "Content-Type", "application/json")
  ezhttp_option_add_url_parameter(httpOptions, "reaction", OTAKU_REACTIONS[reactionId])

  new JSON: userObject = json_init_object()
  json_object_set_string(userObject, "id", fmt("%d", id))
  json_object_set_string(userObject, "userId", fmt("%d", get_user_userid(id)))

  new userSerial[64]
  json_serial_to_string(userObject, userSerial, charsmax(userSerial))

  json_free(userObject)

  ezhttp_option_set_user_data(httpOptions, userSerial, charsmax(userSerial))

  ezhttp_get(OTAKU_URL, "completeRequest", httpOptions)

  g_lastPlayerUse[id] = get_gametime()

  return PLUGIN_HANDLED
}

public completeRequest(EzHttpRequest: httpRequest) {
  if (ezhttp_get_error_code(httpRequest) != EZH_OK) {
    new errorMessage[64]
    ezhttp_get_error_message(httpRequest, errorMessage, charsmax(errorMessage))

    server_print("Response error: %s", errorMessage);

    return
  }

  new userData[64]
  ezhttp_get_user_data(httpRequest, userData)

  new JSON: userObject = json_parse(userData)

  new playerId[3], userId[3]
  json_object_get_string(userObject, "id", playerId, charsmax(playerId))
  json_object_get_string(userObject, "userId", userId, charsmax(userId))

  json_free(userObject)

  new id = str_to_num(playerId)

  if (get_user_userid(id) != str_to_num(userId))
    return

  new resData[164]
  ezhttp_get_data(httpRequest, resData, charsmax(resData))

  new JSON: resObject = json_parse(resData)

  new gifAddress[128]
  json_object_get_string(resObject, "url", gifAddress, charsmax(gifAddress))

  json_free(resObject)

  showUserMotd(id, gifAddress)
}

showUserMotd(const id, const gifAddress[]) {
  new motdMessage[512]
  formatex(motdMessage, charsmax(motdMessage),
    "<!DOCTYPE html> \
    <html> \
    <head> \
      <style> \
        body { \
          background-color: #444547; \
        } \
        img { \
          display: block; \
          margin-left: auto; \
          margin-right: auto; \
          width: 50%; \
        } \
      </style> \
    <body> \
      <img src=^"%s^" alt=^"GIF^"> \
    </body> \
    </html>",
    gifAddress
  )

  show_motd(id, motdMessage, "UWU")
}

GetReactionId(const reaction[]) {
  for (new reactionId = 0; reactionId < sizeof OTAKU_REACTIONS; reactionId++) {
    if (equali(reaction, OTAKU_REACTIONS[reactionId]))
      return reactionId
  }

  return random_num(0, sizeof OTAKU_REACTIONS - 1)
}