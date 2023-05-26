# OtakuGifs - Random anime gif in MOTD

<p align="center" width="100%">
  <img src="https://dev-cs.ru/data/resource_icons/1/1594.jpg?1685095563">
</p>

Getting a random ANIME GIF in MOTD!

[![YouTube](http://img.youtube.com/vi/BWe7mTzaFq0/0.jpg)](http://www.youtube.com/watch?v=BWe7mTzaFq0 "Demo")

## Credits

- [OtakuGifs API](https://otakugifs.xyz) - The best anime GIF collection,
in a free API.
- [Next21Team](https://github.com/Next21Team) - The best HTTP module [AmxxEasyHttp](https://dev-cs.ru/resources/1314/)

## Requirements

- [Amx Mod X 1.9.0](https://dev-cs.ru/resources/405/) or higher
- [AmxxEasyHttp](https://dev-cs.ru/resources/1314/)

## Usage

1. Put the contents of the `addons/amxmodx/scripting` folder in the directory of your server (your_server_folder/cstrike/addons/amxmodx/scripting)
2. Compile `otakugifs.sma` [how to compile?](https://dev-cs.ru/threads/246/)
4. Add `otakugifs.amxx` into your `plugins.ini` file
5. Restart server or change map
6. Type `/gif` in chat.
7. Be happy!

## Config

### In the source code:

Set your anti-spam float value, above which players will not be able to use the `/gif` command.

```Pawn
const Float: ANTISPAM_TIME = 10.0
```
