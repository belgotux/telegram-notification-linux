# Telegrtam notification
Script to notify text by Push Services, use it in any of your custom script!
## Installation

1. Copy `telegram-notification.sh` to `/usr/local/bin/`
2. Copy `telegram-notification.conf.example` to `/usr/local/etc/telegram-notification.conf`
3. Add your token (previously getting by add the contact @BotFather)
   `/start` : to start and get instruction
   `/newbot` : ask a new bot, follow the instruction to create a Name, a unique username finishing by `bot`
   `/mybots` : show your bots, you can add a description or a picture for example
4. Add the new contact to telegram and start (it print /start)
4. Get the chat ID with your browser or curl at `https://api.telegram.org/bot<YourBOTToken>/getUpdates`
```
{"ok":true,"result":[{"update_id":551184892,
"message":{"message_id":2,"from":{"id":1648779299,"is_bot":false,"first_name":"xxxx","language_code":"fr"},"chat":{"id":XXXXXXXXX,"first_name":"xxxx","type":"private"},"date":1670947477,"text":"/start","entities":[{"offset":0,"length":6,"type":"bot_command"}]}}]}%
```
4. Add this **SECRET** token and the chat ID in the `telegram-notification.conf` file
5. (optinnal) You can change the default official providerApi if you host a [local Bot API server](https://core.telegram.org/bots/api#using-a-local-bot-api-server).
## Usage
`telegram-notification.sh [-t "title"] -m "message with space" [-w|-c]`
`echo "message with space" | telegram-notification.sh [-t "title"] [-w|-c]`

Message is mandatory, input or -m

Options :
*  -t for a title
*  -w add a emoji warning icon
*  -c add a emoji critical icon

## Examples
```
telegram-notification.sh -m "Space disc critic" -t "test" -c
telegram-notification.sh -m "Space disc high" -t "test" -w 
telegram-notification.sh -m "service blabla need attention" -w
telegram-notification.sh -m "simple report"
telegram-notification.sh -m "simple report with title" -t "my title \xF0\x9F\x90\xA2" 
```
If you need Emoji, [go to Emoji Unicode Tables](https://apps.timwhitlock.info/emoji/tables/unicode)

## Improvement
Different chat or bot into one script is not implemented yet, because I don't need it. You can just duplicate the script and conf file for basic needs. But feel free to do a pull request.