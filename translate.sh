languages="
Arabic ar
Belarusian be
Chinese zh-CN
Taiwanese zh-TW
Croatian hr
Czech cs
Danish da
Dutch nl
English en
Estonian et
Finnish fi
French fr
German de
Greek el
Hebrew iw
Hungarian hu
Italian it
Japanese ja
Korean ko
Latin la
Norwegian no
Persian fa
Polish pl
Portuguese pt
Punjabi pa
Romanian ro
Russian ru
Serbian sr
Slovak sk
Slovenian sl
Spanish es
Swedish sv
Turkish tr
Ukrainian uk
Yiddish yi
"

# turn languages into lowercase
languages=( "${languages[@],,}" )

# display language selection menu
lang=$(echo "$languages" | rofi -dmenu | cut -d ' ' -f 2)

if [ -z "$lang" ]; then
    exit 0
fi

# display text input box
text=$(rofi -dmenu -p "Text to translate:")

if [ -z "$text" ]; then
    exit 0
fi

json=$(curl -s "https://trap.her.st/api/translate/?engine=google" --data-urlencode "to=$lang" --data-urlencode "text=$text")
translation=$(echo $json | jq -r '.["translated-text"]')
xdotool type "$translation"
