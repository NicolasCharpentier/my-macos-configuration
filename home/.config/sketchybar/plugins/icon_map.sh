#!/usr/bin/env bash

__icon_map() {
  icon_result=":default:"
  [[ "$1" = "Live" ]] && icon_result=":ableton:" && return
  [[ "$1" = "Activity Monitor" ]] && icon_result=":activity_monitor:" && return
  [[ "$1" = "Aktivitätsanzeige" ]] && icon_result=":activity_monitor:" && return
  [[ "$1" = "Actual" ]] && icon_result=":actual:" && return
  [[ "$1" = "Adobe Bridge" ]] && icon_result=":adobe_bridge:" && return
  [[ "$1" = "AFFiNE" ]] && icon_result=":affine:" && return
  [[ "$1" = "Affinity Designer 2" ]] && icon_result=":affinity_designer_2:" && return
  [[ "$1" = "Affinity Designer" ]] && icon_result=":affinity_designer:" && return
  [[ "$1" = "Affinity Photo 2" ]] && icon_result=":affinity_photo_2:" && return
  [[ "$1" = "Affinity Photo" ]] && icon_result=":affinity_photo:" && return
  [[ "$1" = "Affinity Publisher 2" ]] && icon_result=":affinity_publisher_2:" && return
  [[ "$1" = "Affinity Publisher" ]] && icon_result=":affinity_publisher:" && return
  [[ "$1" = "Affinity" ]] && icon_result=":affinity:" && return
  [[ "$1" = "Airmail" ]] && icon_result=":airmail:" && return
  [[ "$1" = "Alacritty" ]] && icon_result=":alacritty:" && return
  [[ "$1" = "Alfred" ]] && icon_result=":alfred:" && return
  [[ "$1" = "AltTab" ]] && icon_result=":alttab:" && return
  [[ "$1" = "Android Messages" ]] && icon_result=":android_messages:" && return
  [[ "$1" = "Android Studio" ]] && icon_result=":android_studio:" && return
  [[ "$1" = "Anki" ]] && icon_result=":anki:" && return
  [[ "$1" = "AnyDesk" ]] && icon_result=":anydesk:" && return
  [[ "$1" = "Anytype" ]] && icon_result=":anytype:" && return
  [[ "$1" = "Apifox" ]] && icon_result=":apifox:" && return
  [[ "$1" = "App Eraser" ]] && icon_result=":app_eraser:" && return
  [[ "$1" = "App Store" ]] && icon_result=":app_store:" && return
  [[ "$1" = "Apple Books" ]] && icon_result=":apple_books:" && return
  [[ "$1" = "Books" ]] && icon_result=":apple_books:" && return
  [[ "$1" = "Arc" ]] && icon_result=":arc:" && return
  [[ "$1" = "Arduino" ]] && icon_result=":arduino:" && return
  [[ "$1" = "Arduino IDE" ]] && icon_result=":arduino:" && return
  [[ "$1" = "Aseprite" ]] && icon_result=":aseprite:" && return
  [[ "$1" = "Atom" ]] && icon_result=":atom:" && return
  [[ "$1" = "Audacity" ]] && icon_result=":audacity:" && return
  [[ "$1" = "BaiduNetdisk" ]] && icon_result=":baidunetdisk:" && return
  [[ "$1" = "百度网盘" ]] && icon_result=":baidunetdisk:" && return
  [[ "$1" = "Bambu Studio" ]] && icon_result=":bambu_studio:" && return
  [[ "$1" = "MoneyMoney" ]] && icon_result=":bank:" && return
  [[ "$1" = "Basecamp" ]] && icon_result=":basecamp:" && return
  [[ "$1" = "Battle.net" ]] && icon_result=":battle_net:" && return
  [[ "$1" = "Bazecor" ]] && icon_result=":bazecor:" && return
  [[ "$1" = "Bear" ]] && icon_result=":bear:" && return
  [[ "$1" = "Beekeeper Studio" ]] && icon_result=":beekeeper_studio:" && return
  [[ "$1" = "Beeper" ]] && icon_result=":beeper:" && return
  [[ "$1" = "Beeper Desktop" ]] && icon_result=":beeper:" && return
  [[ "$1" = "BetterTouchTool" ]] && icon_result=":bettertouchtool:" && return
  [[ "$1" = "Bilibili" ]] && icon_result=":bilibili:" && return
  [[ "$1" = "哔哩哔哩" ]] && icon_result=":bilibili:" && return
  [[ "$1" = "Bitwarden" ]] && icon_result=":bit_warden:" && return
  [[ "$1" = "Blender" ]] && icon_result=":blender:" && return
  [[ "$1" = "Blitzit" ]] && icon_result=":blitzit:" && return
  [[ "$1" = "Bluetooth File Exchange" ]] && icon_result=":bluetooth_file_exchange:" && return
  [[ "$1" = "BluOS Controller" ]] && icon_result=":bluos_controller:" && return
  [[ "$1" = "Calibre" ]] && icon_result=":book:" && return
  [[ "$1" = "Brave Browser" ]] && icon_result=":brave_browser:" && return
  [[ "$1" = "Broadcasts" ]] && icon_result=":broadcasts:" && return
  [[ "$1" = "Burn" ]] && icon_result=":burn:" && return
  [[ "$1" = "BusyCal" ]] && icon_result=":busycal:" && return
  [[ "$1" = "Calculator" ]] && icon_result=":calculator:" && return
  [[ "$1" = "Calculette" ]] && icon_result=":calculator:" && return
  [[ "$1" = "Rechner" ]] && icon_result=":calculator:" && return
  [[ "$1" = "Calendar" ]] && icon_result=":calendar:" && return
  [[ "$1" = "日历" ]] && icon_result=":calendar:" && return
  [[ "$1" = "Fantastical" ]] && icon_result=":calendar:" && return
  [[ "$1" = "Cron" ]] && icon_result=":calendar:" && return
  [[ "$1" = "Amie" ]] && icon_result=":calendar:" && return
  [[ "$1" = "Calendrier" ]] && icon_result=":calendar:" && return
  [[ "$1" = "カレンダー" ]] && icon_result=":calendar:" && return
  [[ "$1" = "Notion Calendar" ]] && icon_result=":calendar:" && return
  [[ "$1" = "Kalender" ]] && icon_result=":calendar:" && return
  [[ "$1" = "calibre" ]] && icon_result=":calibre:" && return
  [[ "$1" = "Caprine" ]] && icon_result=":caprine:" && return
  [[ "$1" = "ChatGPT Atlas" ]] && icon_result=":chatgpt_atlas:" && return
  [[ "$1" = "Cherry Studio" ]] && icon_result=":cherry_studio:" && return
  [[ "$1" = "Chess" ]] && icon_result=":chess:" && return
  [[ "$1" = "Amazon Chime" ]] && icon_result=":chime:" && return
  [[ "$1" = "Choosy" ]] && icon_result=":choosy:" && return
  [[ "$1" = "Cisco AnyConnect Secure Mobility Client" ]] && icon_result=":cisco_anyconnect:" && return
  [[ "$1" = "Citrix Workspace" ]] && icon_result=":citrix:" && return
  [[ "$1" = "Citrix Viewer" ]] && icon_result=":citrix:" && return
  [[ "$1" = "ClassIn" ]] && icon_result=":classin:" && return
  [[ "$1" = "Claude" ]] && icon_result=":claude:" && return
  [[ "$1" = "ClickUp" ]] && icon_result=":click_up:" && return
  [[ "$1" = "Clock" ]] && icon_result=":clock:" && return
  [[ "$1" = "coconutBattery" ]] && icon_result=":coconut_battery:" && return
  [[ "$1" = "Code" ]] && icon_result=":code:" && return
  [[ "$1" = "Code - Insiders" ]] && icon_result=":code:" && return
  [[ "$1" = "Electron" ]] && icon_result=":code:" && return
  [[ "$1" = "Cold Turkey Blocker" ]] && icon_result=":cold_turkey_blocker:" && return
  [[ "$1" = "Color Picker" ]] && icon_result=":color_picker:" && return
  [[ "$1" = "数码测色计" ]] && icon_result=":color_picker:" && return
  [[ "$1" = "Conductor" ]] && icon_result=":conductor:" && return
  [[ "$1" = "Console" ]] && icon_result=":console:" && return
  [[ "$1" = "Contacts" ]] && icon_result=":contacts:" && return
  [[ "$1" = "Copilot" ]] && icon_result=":copilot:" && return
  [[ "$1" = "CotEditor" ]] && icon_result=":coteditor:" && return
  [[ "$1" = "Craft" ]] && icon_result=":craft:" && return
  [[ "$1" = "Creative Cloud" ]] && icon_result=":creative_cloud:" && return
  [[ "$1" = "Cubase" ]] && icon_result=":cubase:" && return
  [[ "$1" = "Cubase Pro" ]] && icon_result=":cubase:" && return
  [[ "$1" = "CurseForge" ]] && icon_result=":curseforge:" && return
  [[ "$1" = "Cursor" ]] && icon_result=":cursor:" && return
  [[ "$1" = "Cypress" ]] && icon_result=":cypress:" && return
  [[ "$1" = "Dash" ]] && icon_result=":dash:" && return
  [[ "$1" = "DataGrip" ]] && icon_result=":datagrip:" && return
  [[ "$1" = "DataSpell" ]] && icon_result=":dataspell:" && return
  [[ "$1" = "DaVinci Resolve" ]] && icon_result=":davinciresolve:" && return
  [[ "$1" = "DBeaver" ]] && icon_result=":dbeaver:" && return
  [[ "$1" = "DeepSeek" ]] && icon_result=":deepseek:" && return
  [[ "$1" = "Deezer" ]] && icon_result=":deezer:" && return
  [[ "$1" = "Default" ]] && icon_result=":default:" && return
  [[ "$1" = "deno" ]] && icon_result=":deno:" && return
  [[ "$1" = "CleanMyMac X" ]] && icon_result=":desktop:" && return
  [[ "$1" = "DEVONthink 3" ]] && icon_result=":devonthink3:" && return
  [[ "$1" = "DEVONthink" ]] && icon_result=":devonthink3:" && return
  [[ "$1" = "Dia" ]] && icon_result=":dia:" && return
  [[ "$1" = "Dictionary" ]] && icon_result=":dictionary:" && return
  [[ "$1" = "DingTalk" ]] && icon_result=":dingtalk:" && return
  [[ "$1" = "钉钉" ]] && icon_result=":dingtalk:" && return
  [[ "$1" = "阿里钉" ]] && icon_result=":dingtalk:" && return
  [[ "$1" = "Discord" ]] && icon_result=":discord:" && return
  [[ "$1" = "Discord Canary" ]] && icon_result=":discord:" && return
  [[ "$1" = "Discord PTB" ]] && icon_result=":discord:" && return
  [[ "$1" = "Docker" ]] && icon_result=":docker:" && return
  [[ "$1" = "Docker Desktop" ]] && icon_result=":docker:" && return
  [[ "$1" = "GrandTotal" ]] && icon_result=":dollar:" && return
  [[ "$1" = "Receipts" ]] && icon_result=":dollar:" && return
  [[ "$1" = "Dorico" ]] && icon_result=":dorico:" && return
  [[ "$1" = "Dorico Pro" ]] && icon_result=":dorico:" && return
  [[ "$1" = "Double Commander" ]] && icon_result=":doublecmd:" && return
  [[ "$1" = "Downie 4" ]] && icon_result=":downie:" && return
  [[ "$1" = "Drafts" ]] && icon_result=":drafts:" && return
  [[ "$1" = "draw.io" ]] && icon_result=":draw_io:" && return
  [[ "$1" = "Dropbox" ]] && icon_result=":dropbox:" && return
  [[ "$1" = "DVD Player" ]] && icon_result=":dvd_player:" && return
  [[ "$1" = "Eagle" ]] && icon_result=":eagle:" && return
  [[ "$1" = "Element" ]] && icon_result=":element:" && return
  [[ "$1" = "Emacs" ]] && icon_result=":emacs:" && return
  [[ "$1" = "Evernote Legacy" ]] && icon_result=":evernote_legacy:" && return
  [[ "$1" = "FaceTime" ]] && icon_result=":face_time:" && return
  [[ "$1" = "FaceTime 通话" ]] && icon_result=":face_time:" && return
  [[ "$1" = "Feishu" ]] && icon_result=":feishu:" && return
  [[ "$1" = "飞书" ]] && icon_result=":feishu:" && return
  [[ "$1" = "飞书会议" ]] && icon_result=":feishu:" && return
  [[ "$1" = "Figma" ]] && icon_result=":figma:" && return
  [[ "$1" = "Final Cut Pro" ]] && icon_result=":final_cut_pro:" && return
  [[ "$1" = "Find My" ]] && icon_result=":find_my:" && return
  [[ "$1" = "Finder" ]] && icon_result=":finder:" && return
  [[ "$1" = "访达" ]] && icon_result=":finder:" && return
  [[ "$1" = "Bloom" ]] && icon_result=":finder:" && return
  [[ "$1" = "Firefox Developer Edition" ]] && icon_result=":firefox_developer_edition:" && return
  [[ "$1" = "Firefox Nightly" ]] && icon_result=":firefox_developer_edition:" && return
  [[ "$1" = "Firefox" ]] && icon_result=":firefox:" && return
  [[ "$1" = "Floorp" ]] && icon_result=":floorp:" && return
  [[ "$1" = "FL Studio" ]] && icon_result=":flstudio:" && return
  [[ "$1" = "Fluxer" ]] && icon_result=":fluxer:" && return
  [[ "$1" = "Folx" ]] && icon_result=":folx:" && return
  [[ "$1" = "Font Book" ]] && icon_result=":font_book:" && return
  [[ "$1" = "foobar2000" ]] && icon_result=":foobar2000:" && return
  [[ "$1" = "Fork" ]] && icon_result=":fork:" && return
  [[ "$1" = "ForkLift" ]] && icon_result=":forklift:" && return
  [[ "$1" = "Foxit PDF Reader" ]] && icon_result=":foxit_reader:" && return
  [[ "$1" = "Freeform" ]] && icon_result=":freeform:" && return
  [[ "$1" = "FSNotes" ]] && icon_result=":fsnotes:" && return
  [[ "$1" = "Fusion" ]] && icon_result=":fusion:" && return
  [[ "$1" = "Games" ]] && icon_result=":games:" && return
  [[ "$1" = "System Preferences" ]] && icon_result=":gear:" && return
  [[ "$1" = "System Settings" ]] && icon_result=":gear:" && return
  [[ "$1" = "系统设置" ]] && icon_result=":gear:" && return
  [[ "$1" = "Réglages Système" ]] && icon_result=":gear:" && return
  [[ "$1" = "システム設定" ]] && icon_result=":gear:" && return
  [[ "$1" = "Systemeinstellungen" ]] && icon_result=":gear:" && return
  [[ "$1" = "System­einstellungen" ]] && icon_result=":gear:" && return
  [[ "$1" = "Gemini" ]] && icon_result=":gemini:" && return
  [[ "$1" = "Google Gemini" ]] && icon_result=":gemini:" && return
  [[ "$1" = "Ghostty" ]] && icon_result=":ghostty:" && return
  [[ "$1" = "GitHub Desktop" ]] && icon_result=":git_hub:" && return
  [[ "$1" = "Godot" ]] && icon_result=":godot:" && return
  [[ "$1" = "GoLand" ]] && icon_result=":goland:" && return
  [[ "$1" = "GoodLinks" ]] && icon_result=":goodlinks:" && return
  [[ "$1" = "Goodnotes" ]] && icon_result=":goodnotes:" && return
  [[ "$1" = "Google Chat" ]] && icon_result=":google_chat:" && return
  [[ "$1" = "Chromium" ]] && icon_result=":google_chrome:" && return
  [[ "$1" = "Google Chrome" ]] && icon_result=":google_chrome:" && return
  [[ "$1" = "Google Chrome Canary" ]] && icon_result=":google_chrome:" && return
  [[ "$1" = "Grammarly Editor" ]] && icon_result=":grammarly:" && return
  [[ "$1" = "Granola" ]] && icon_result=":granola:" && return
  [[ "$1" = "Hammerspoon" ]] && icon_result=":hammerspoon:" && return
  [[ "$1" = "Hazel" ]] && icon_result=":hazel:" && return
  [[ "$1" = "HBO Max" ]] && icon_result=":hbo_max:" && return
  [[ "$1" = "Home Assistant" ]] && icon_result=":home_assistant:" && return
  [[ "$1" = "Home" ]] && icon_result=":home:" && return
  [[ "$1" = "Hyper" ]] && icon_result=":hyper:" && return
  [[ "$1" = "IntelliJ IDEA" ]] && icon_result=":idea:" && return
  [[ "$1" = "Adobe Illustrator" ]] && icon_result=":illustrator:" && return
  [[ "$1" = "Illustrator" ]] && icon_result=":illustrator:" && return
  [[ "$1" = "Image Playground" ]] && icon_result=":image_playground:" && return
  [[ "$1" = "ImHex" ]] && icon_result=":imhex:" && return
  [[ "$1" = "Adobe InDesign" ]] && icon_result=":indesign:" && return
  [[ "$1" = "InDesign" ]] && icon_result=":indesign:" && return
  [[ "$1" = "Infuse" ]] && icon_result=":infuse:" && return
  [[ "$1" = "Inkdrop" ]] && icon_result=":inkdrop:" && return
  [[ "$1" = "Inkscape" ]] && icon_result=":inkscape:" && return
  [[ "$1" = "Insomnia" ]] && icon_result=":insomnia:" && return
  [[ "$1" = "Instapaper" ]] && icon_result=":instapaper:" && return
  [[ "$1" = "iPhone Mirroring" ]] && icon_result=":iphone_mirroring:" && return
  [[ "$1" = "Iris" ]] && icon_result=":iris:" && return
  [[ "$1" = "iTerm" ]] && icon_result=":iterm:" && return
  [[ "$1" = "iTerm2" ]] && icon_result=":iterm:" && return
  [[ "$1" = "Product Portal" ]] && icon_result=":izotope:" && return
  [[ "$1" = "iZotope RX 9" ]] && icon_result=":izotope:" && return
  [[ "$1" = "iZotope RX 10" ]] && icon_result=":izotope:" && return
  [[ "$1" = "iZotope RX 11" ]] && icon_result=":izotope:" && return
  [[ "$1" = "iZotope RX 12" ]] && icon_result=":izotope:" && return
  [[ "$1" = "iZotope Ozone 9" ]] && icon_result=":izotope:" && return
  [[ "$1" = "iZotope Ozone 10" ]] && icon_result=":izotope:" && return
  [[ "$1" = "iZotope Ozone 11" ]] && icon_result=":izotope:" && return
  [[ "$1" = "Jane Reader" ]] && icon_result=":jane_reader:" && return
  [[ "$1" = "JDownloader" ]] && icon_result=":jdownloader:" && return
  [[ "$1" = "JDownloader2" ]] && icon_result=":jdownloader:" && return
  [[ "$1" = "JetBrains Gateway" ]] && icon_result=":jetbrains_gateway:" && return
  [[ "$1" = "JetBrains Toolbox" ]] && icon_result=":jetbrains_toolbox:" && return
  [[ "$1" = "Joplin" ]] && icon_result=":joplin:" && return
  [[ "$1" = "카카오톡" ]] && icon_result=":kakaotalk:" && return
  [[ "$1" = "KakaoTalk" ]] && icon_result=":kakaotalk:" && return
  [[ "$1" = "Kakoune" ]] && icon_result=":kakoune:" && return
  [[ "$1" = "Karabiner-Elements Settings" ]] && icon_result=":karabiner_elements:" && return
  [[ "$1" = "KeePassXC" ]] && icon_result=":kee_pass_x_c:" && return
  [[ "$1" = "Keyboard Maestro" ]] && icon_result=":keyboard_maestro:" && return
  [[ "$1" = "Keynote" ]] && icon_result=":keynote:" && return
  [[ "$1" = "Keynote 讲演" ]] && icon_result=":keynote:" && return
  [[ "$1" = "kitty" ]] && icon_result=":kitty:" && return
  [[ "$1" = "Kodi" ]] && icon_result=":kodi:" && return
  [[ "$1" = "LanguageTool for Desktop" ]] && icon_result=":languagetool_for_desktop:" && return
  [[ "$1" = "League of Legends" ]] && icon_result=":league_of_legends:" && return
  [[ "$1" = "LibreWolf" ]] && icon_result=":libre_wolf:" && return
  [[ "$1" = "Adobe Lightroom" ]] && icon_result=":lightroom:" && return
  [[ "$1" = "Lightroom Classic" ]] && icon_result=":lightroomclassic:" && return
  [[ "$1" = "LINE" ]] && icon_result=":line:" && return
  [[ "$1" = "Linear" ]] && icon_result=":linear:" && return
  [[ "$1" = "Little Snitch Mini" ]] && icon_result=":little_snitch_mini:" && return
  [[ "$1" = "Little Snitch" ]] && icon_result=":little_snitch:" && return
  [[ "$1" = "Little Snitch Network Monitor" ]] && icon_result=":little_snitch:" && return
  [[ "$1" = "LM Studio" ]] && icon_result=":lm_studio:" && return
  [[ "$1" = "LocalSend" ]] && icon_result=":localsend:" && return
  [[ "$1" = "Logic Pro" ]] && icon_result=":logicpro:" && return
  [[ "$1" = "Logseq" ]] && icon_result=":logseq:" && return
  [[ "$1" = "LuLu" ]] && icon_result=":lulu:" && return
  [[ "$1" = "Canary Mail" ]] && icon_result=":mail:" && return
  [[ "$1" = "HEY" ]] && icon_result=":mail:" && return
  [[ "$1" = "Mail" ]] && icon_result=":mail:" && return
  [[ "$1" = "Mailspring" ]] && icon_result=":mail:" && return
  [[ "$1" = "MailMate" ]] && icon_result=":mail:" && return
  [[ "$1" = "Superhuman" ]] && icon_result=":mail:" && return
  [[ "$1" = "Spark" ]] && icon_result=":mail:" && return
  [[ "$1" = "Spark Mail" ]] && icon_result=":mail:" && return
  [[ "$1" = "邮件" ]] && icon_result=":mail:" && return
  [[ "$1" = "メール" ]] && icon_result=":mail:" && return
  [[ "$1" = "MakeMKV" ]] && icon_result=":makemkv:" && return
  [[ "$1" = "MAMP" ]] && icon_result=":mamp:" && return
  [[ "$1" = "MAMP PRO" ]] && icon_result=":mamp:" && return
  [[ "$1" = "Maps" ]] && icon_result=":maps:" && return
  [[ "$1" = "Google Maps" ]] && icon_result=":maps:" && return
  [[ "$1" = "マップ" ]] && icon_result=":maps:" && return
  [[ "$1" = "Karten" ]] && icon_result=":maps:" && return
  [[ "$1" = "Marked 2" ]] && icon_result=":marked_2:" && return
  [[ "$1" = "Marta" ]] && icon_result=":marta:" && return
  [[ "$1" = "Matlab" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLABWindow" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2024b" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2024a" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2023b" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2023a" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2022b" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2022a" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2021b" ]] && icon_result=":matlab:" && return
  [[ "$1" = "MATLAB_R2021a" ]] && icon_result=":matlab:" && return
  [[ "$1" = "Mattermost" ]] && icon_result=":mattermost:" && return
  [[ "$1" = "Messages" ]] && icon_result=":messages:" && return
  [[ "$1" = "信息" ]] && icon_result=":messages:" && return
  [[ "$1" = "Nachrichten" ]] && icon_result=":messages:" && return
  [[ "$1" = "メッセージ" ]] && icon_result=":messages:" && return
  [[ "$1" = "Messenger" ]] && icon_result=":messenger:" && return
  [[ "$1" = "Microsoft Edge" ]] && icon_result=":microsoft_edge:" && return
  [[ "$1" = "Microsoft Excel" ]] && icon_result=":microsoft_excel:" && return
  [[ "$1" = "Microsoft PowerPoint" ]] && icon_result=":microsoft_power_point:" && return
  [[ "$1" = "Microsoft Remote Desktop" ]] && icon_result=":microsoft_remote_desktop:" && return
  [[ "$1" = "Microsoft Teams" ]] && icon_result=":microsoft_teams:" && return
  [[ "$1" = "Microsoft Teams (work or school)" ]] && icon_result=":microsoft_teams:" && return
  [[ "$1" = "Microsoft Word" ]] && icon_result=":microsoft_word:" && return
  [[ "$1" = "Mimestream" ]] && icon_result=":mimestream:" && return
  [[ "$1" = "Min" ]] && icon_result=":min_browser:" && return
  [[ "$1" = "Minecraft" ]] && icon_result=":minecraft:" && return
  [[ "$1" = "Minecraft Launcher" ]] && icon_result=":minecraft:" && return
  [[ "$1" = "Miro" ]] && icon_result=":miro:" && return
  [[ "$1" = "MongoDB Compass" ]] && icon_result=":mongodb:" && return
  [[ "$1" = "Moonlight" ]] && icon_result=":moonlight:" && return
  [[ "$1" = "Motrix" ]] && icon_result=":motrix:" && return
  [[ "$1" = "Movist Pro" ]] && icon_result=":movist_pro:" && return
  [[ "$1" = "mpv" ]] && icon_result=":mpv:" && return
  [[ "$1" = "Mullvad Browser" ]] && icon_result=":mullvad_browser:" && return
  [[ "$1" = "Music" ]] && icon_result=":music:" && return
  [[ "$1" = "音乐" ]] && icon_result=":music:" && return
  [[ "$1" = "Musique" ]] && icon_result=":music:" && return
  [[ "$1" = "ミュージック" ]] && icon_result=":music:" && return
  [[ "$1" = "Musik" ]] && icon_result=":music:" && return
  [[ "$1" = "Chromatix" ]] && icon_result=":music:" && return
  [[ "$1" = "Navicat Premium" ]] && icon_result=":navicat:" && return
  [[ "$1" = "Neovide" ]] && icon_result=":neovide:" && return
  [[ "$1" = "neovide" ]] && icon_result=":neovide:" && return
  [[ "$1" = "Neovim" ]] && icon_result=":neovim:" && return
  [[ "$1" = "neovim" ]] && icon_result=":neovim:" && return
  [[ "$1" = "nvim" ]] && icon_result=":neovim:" && return
  [[ "$1" = "网易云音乐" ]] && icon_result=":netease_music:" && return
  [[ "$1" = "NetEaseMusic" ]] && icon_result=":netease_music:" && return
  [[ "$1" = "Netflix" ]] && icon_result=":netflix:" && return
  [[ "$1" = "News" ]] && icon_result=":news:" && return
  [[ "$1" = "Nimble Commander" ]] && icon_result=":nimble_commander:" && return
  [[ "$1" = "NimbleCommander-Unsigned" ]] && icon_result=":nimble_commander:" && return
  [[ "$1" = "Noodl" ]] && icon_result=":noodl:" && return
  [[ "$1" = "NordVPN" ]] && icon_result=":nord_vpn:" && return
  [[ "$1" = "Notability" ]] && icon_result=":notability:" && return
  [[ "$1" = "Notes" ]] && icon_result=":notes:" && return
  [[ "$1" = "备忘录" ]] && icon_result=":notes:" && return
  [[ "$1" = "メモ" ]] && icon_result=":notes:" && return
  [[ "$1" = "Notizen" ]] && icon_result=":notes:" && return
  [[ "$1" = "Notion Mail" ]] && icon_result=":notion_mail:" && return
  [[ "$1" = "Notion" ]] && icon_result=":notion:" && return
  [[ "$1" = "Nova" ]] && icon_result=":nova:" && return
  [[ "$1" = "Numbers" ]] && icon_result=":numbers:" && return
  [[ "$1" = "Numbers 表格" ]] && icon_result=":numbers:" && return
  [[ "$1" = "nvALT" ]] && icon_result=":nvalt:" && return
  [[ "$1" = "Nvidia GeForce Now" ]] && icon_result=":nvidia_geforce_now:" && return
  [[ "$1" = "GeForceNOW" ]] && icon_result=":nvidia_geforce_now:" && return
  [[ "$1" = "Obsidian" ]] && icon_result=":obsidian:" && return
  [[ "$1" = "OBS" ]] && icon_result=":obsstudio:" && return
  [[ "$1" = "Ollama" ]] && icon_result=":ollama:" && return
  [[ "$1" = "OmniFocus" ]] && icon_result=":omni_focus:" && return
  [[ "$1" = "1Password" ]] && icon_result=":one_password:" && return
  [[ "$1" = "Open Video Downloader" ]] && icon_result=":open_video_downloader:" && return
  [[ "$1" = "OpenAI Translator" ]] && icon_result=":openai_translator:" && return
  [[ "$1" = "ChatGPT" ]] && icon_result=":openai:" && return
  [[ "$1" = "OpenVPN Connect" ]] && icon_result=":openvpn_connect:" && return
  [[ "$1" = "Opera" ]] && icon_result=":opera:" && return
  [[ "$1" = "OrbStack" ]] && icon_result=":orbstack:" && return
  [[ "$1" = "OrcaSlicer" ]] && icon_result=":orcaslicer:" && return
  [[ "$1" = "Orion" ]] && icon_result=":orion:" && return
  [[ "$1" = "Orion RC" ]] && icon_result=":orion:" && return
  [[ "$1" = "Overcast" ]] && icon_result=":overcast:" && return
  [[ "$1" = "Overleaf" ]] && icon_result=":overleaf:" && return
  [[ "$1" = "ShareLaTeX" ]] && icon_result=":overleaf:" && return
  [[ "$1" = "Pages" ]] && icon_result=":pages:" && return
  [[ "$1" = "Pages 文稿" ]] && icon_result=":pages:" && return
  [[ "$1" = "Parallels Desktop" ]] && icon_result=":parallels:" && return
  [[ "$1" = "Parcel" ]] && icon_result=":parcel:" && return
  [[ "$1" = "Parsec" ]] && icon_result=":parsec:" && return
  [[ "$1" = "Passwords" ]] && icon_result=":passwords:" && return
  [[ "$1" = "Passwörter" ]] && icon_result=":passwords:" && return
  [[ "$1" = "PDF Expert" ]] && icon_result=":pdf_expert:" && return
  [[ "$1" = "Pearcleaner" ]] && icon_result=":pearcleaner:" && return
  [[ "$1" = "Perplexity" ]] && icon_result=":perplexity:" && return
  [[ "$1" = "Phoenix Slides" ]] && icon_result=":phoenix_slides:" && return
  [[ "$1" = "Phone" ]] && icon_result=":phone:" && return
  [[ "$1" = "Photos" ]] && icon_result=":photos:" && return
  [[ "$1" = "Fotos" ]] && icon_result=":photos:" && return
  [[ "$1" = "Adobe Photoshop" ]] && icon_result=":photoshop:" && return
  [[ "$1" = "PhpStorm" ]] && icon_result=":php_storm:" && return
  [[ "$1" = "Pi-hole Remote" ]] && icon_result=":pihole:" && return
  [[ "$1" = "Pine" ]] && icon_result=":pine:" && return
  [[ "$1" = "Play" ]] && icon_result=":play:" && return
  [[ "$1" = "Plex" ]] && icon_result=":plex:" && return
  [[ "$1" = "Plexamp" ]] && icon_result=":plexamp:" && return
  [[ "$1" = "Podcasts" ]] && icon_result=":podcasts:" && return
  [[ "$1" = "播客" ]] && icon_result=":podcasts:" && return
  [[ "$1" = "PomoDone App" ]] && icon_result=":pomodone:" && return
  [[ "$1" = "Postman" ]] && icon_result=":postman:" && return
  [[ "$1" = "Premiere" ]] && icon_result=":premiere:" && return
  [[ "$1" = "Adobe Premiere" ]] && icon_result=":premiere:" && return
  [[ "$1" = "Adobe Premiere Pro 2024" ]] && icon_result=":premiere:" && return
  [[ "$1" = "Preview" ]] && icon_result=":preview:" && return
  [[ "$1" = "预览" ]] && icon_result=":preview:" && return
  [[ "$1" = "Skim" ]] && icon_result=":preview:" && return
  [[ "$1" = "zathura" ]] && icon_result=":preview:" && return
  [[ "$1" = "Aperçu" ]] && icon_result=":preview:" && return
  [[ "$1" = "プレビュー" ]] && icon_result=":preview:" && return
  [[ "$1" = "Vorschau" ]] && icon_result=":preview:" && return
  [[ "$1" = "Print Center" ]] && icon_result=":print_center:" && return
  [[ "$1" = "Druckzentrale" ]] && icon_result=":print_center:" && return
  [[ "$1" = "Proton Mail" ]] && icon_result=":proton_mail:" && return
  [[ "$1" = "Proton Mail Bridge" ]] && icon_result=":proton_mail:" && return
  [[ "$1" = "Proton VPN" ]] && icon_result=":proton_vpn:" && return
  [[ "$1" = "ProtonVPN" ]] && icon_result=":proton_vpn:" && return
  [[ "$1" = "PrusaSlicer" ]] && icon_result=":prusaslicer:" && return
  [[ "$1" = "SuperSlicer" ]] && icon_result=":prusaslicer:" && return
  [[ "$1" = "PyCharm" ]] && icon_result=":pycharm:" && return
  [[ "$1" = "qBittorrent" ]] && icon_result=":qbittorrent:" && return
  [[ "$1" = "QGIS" ]] && icon_result=":qgis:" && return
  [[ "$1" = "QQ" ]] && icon_result=":qq:" && return
  [[ "$1" = "QQ音乐" ]] && icon_result=":qqmusic:" && return
  [[ "$1" = "QQMusic" ]] && icon_result=":qqmusic:" && return
  [[ "$1" = "Quantumult X" ]] && icon_result=":quantumult_x:" && return
  [[ "$1" = "Quark" ]] && icon_result=":quark:" && return
  [[ "$1" = "夸克" ]] && icon_result=":quark:" && return
  [[ "$1" = "Quip" ]] && icon_result=":quip:" && return
  [[ "$1" = "qutebrowser" ]] && icon_result=":qute_browser:" && return
  [[ "$1" = "Raindrop.io" ]] && icon_result=":raindrop_io:" && return
  [[ "$1" = "Raspberry Pi Imager" ]] && icon_result=":raspberry_pi:" && return
  [[ "$1" = "Raycast" ]] && icon_result=":raycast:" && return
  [[ "$1" = "Reeder" ]] && icon_result=":reeder5:" && return
  [[ "$1" = "rekordbox" ]] && icon_result=":rekordbox:" && return
  [[ "$1" = "Remind Faster" ]] && icon_result=":remind_me_faster:" && return
  [[ "$1" = "Reminders" ]] && icon_result=":reminders:" && return
  [[ "$1" = "提醒事项" ]] && icon_result=":reminders:" && return
  [[ "$1" = "Rappels" ]] && icon_result=":reminders:" && return
  [[ "$1" = "リマインダー" ]] && icon_result=":reminders:" && return
  [[ "$1" = "Erinnerungen" ]] && icon_result=":reminders:" && return
  [[ "$1" = "Repo Prompt" ]] && icon_result=":repo_prompt:" && return
  [[ "$1" = "Rider" ]] && icon_result=":rider:" && return
  [[ "$1" = "JetBrains Rider" ]] && icon_result=":rider:" && return
  [[ "$1" = "Rio" ]] && icon_result=":rio:" && return
  [[ "$1" = "Royal TSX" ]] && icon_result=":royaltsx:" && return
  [[ "$1" = "RStudio" ]] && icon_result=":rstudio:" && return
  [[ "$1" = "Safari" ]] && icon_result=":safari:" && return
  [[ "$1" = "Safari浏览器" ]] && icon_result=":safari:" && return
  [[ "$1" = "Safari Technology Preview" ]] && icon_result=":safari:" && return
  [[ "$1" = "Sequel Ace" ]] && icon_result=":sequel_ace:" && return
  [[ "$1" = "Sequel Pro" ]] && icon_result=":sequel_pro:" && return
  [[ "$1" = "Session" ]] && icon_result=":session:" && return
  [[ "$1" = "Setapp" ]] && icon_result=":setapp:" && return
  [[ "$1" = "SF Symbols" ]] && icon_result=":sf_symbols:" && return
  [[ "$1" = "SF Symbole" ]] && icon_result=":sf_symbols:" && return
  [[ "$1" = "SF-Symbole" ]] && icon_result=":sf_symbols:" && return
  [[ "$1" = "Shapr3D" ]] && icon_result=":shapr3d:" && return
  [[ "$1" = "Signal" ]] && icon_result=":signal:" && return
  [[ "$1" = "sioyek" ]] && icon_result=":sioyek:" && return
  [[ "$1" = "Sketch" ]] && icon_result=":sketch:" && return
  [[ "$1" = "Skype" ]] && icon_result=":skype:" && return
  [[ "$1" = "Slack" ]] && icon_result=":slack:" && return
  [[ "$1" = "SnippetsLab" ]] && icon_result=":snippetslab:" && return
  [[ "$1" = "solidtime" ]] && icon_result=":solidtime:" && return
  [[ "$1" = "Spark Desktop" ]] && icon_result=":spark:" && return
  [[ "$1" = "Spotify" ]] && icon_result=":spotify:" && return
  [[ "$1" = "Spotlight" ]] && icon_result=":spotlight:" && return
  [[ "$1" = "Steam" ]] && icon_result=":steam:" && return
  [[ "$1" = "Studio 3T" ]] && icon_result=":studio_3t:" && return
  [[ "$1" = "Sublime Merge" ]] && icon_result=":sublime_merge:" && return
  [[ "$1" = "Sublime Text" ]] && icon_result=":sublime_text:" && return
  [[ "$1" = "Summoners War" ]] && icon_result=":summoners_war:" && return
  [[ "$1" = "superProductivity" ]] && icon_result=":superproductivity:" && return
  [[ "$1" = "Surfshark" ]] && icon_result=":surfshark:" && return
  [[ "$1" = "Swift Playground" ]] && icon_result=":swift_playground:" && return
  [[ "$1" = "T3 Chat" ]] && icon_result=":t3chat:" && return
  [[ "$1" = "Tabby" ]] && icon_result=":tabby:" && return
  [[ "$1" = "TablePlus" ]] && icon_result=":tableplus:" && return
  [[ "$1" = "Tailscale" ]] && icon_result=":tailscale:" && return
  [[ "$1" = "Tana" ]] && icon_result=":tana:" && return
  [[ "$1" = "TeamSpeak 3" ]] && icon_result=":team_speak:" && return
  [[ "$1" = "TeamViewer" ]] && icon_result=":teamviewer:" && return
  [[ "$1" = "Telegram" ]] && icon_result=":telegram:" && return
  [[ "$1" = "Terminal" ]] && icon_result=":terminal:" && return
  [[ "$1" = "终端" ]] && icon_result=":terminal:" && return
  [[ "$1" = "ターミナル" ]] && icon_result=":terminal:" && return
  [[ "$1" = "Typora" ]] && icon_result=":text:" && return
  [[ "$1" = "TextEdit" ]] && icon_result=":textedit:" && return
  [[ "$1" = "Microsoft To Do" ]] && icon_result=":things:" && return
  [[ "$1" = "Things" ]] && icon_result=":things:" && return
  [[ "$1" = "Thunderbird" ]] && icon_result=":thunderbird:" && return
  [[ "$1" = "Thunderbird Daily" ]] && icon_result=":thunderbird:" && return
  [[ "$1" = "TickTick" ]] && icon_result=":tick_tick:" && return
  [[ "$1" = "TIDAL" ]] && icon_result=":tidal:" && return
  [[ "$1" = "TigerVNC" ]] && icon_result=":tigervnc:" && return
  [[ "$1" = "Timery" ]] && icon_result=":timery:" && return
  [[ "$1" = "Tiny RDM" ]] && icon_result=":tinyrdm:" && return
  [[ "$1" = "Tips" ]] && icon_result=":tips:" && return
  [[ "$1" = "Todoist" ]] && icon_result=":todoist:" && return
  [[ "$1" = "Toggl Track" ]] && icon_result=":toggl_track:" && return
  [[ "$1" = "Tor Browser" ]] && icon_result=":tor_browser:" && return
  [[ "$1" = "Tot" ]] && icon_result=":tot:" && return
  [[ "$1" = "Tower" ]] && icon_result=":tower:" && return
  [[ "$1" = "Transmit" ]] && icon_result=":transmit:" && return
  [[ "$1" = "Trello" ]] && icon_result=":trello:" && return
  [[ "$1" = "TV" ]] && icon_result=":tv:" && return
  [[ "$1" = "Tweetbot" ]] && icon_result=":twitter:" && return
  [[ "$1" = "Twitter" ]] && icon_result=":twitter:" && return
  [[ "$1" = "Unity" ]] && icon_result=":unity:" && return
  [[ "$1" = "UTM" ]] && icon_result=":utm:" && return
  [[ "$1" = "VeraCrypt" ]] && icon_result=":veracrypt:" && return
  [[ "$1" = "Vesktop" ]] && icon_result=":vesktop:" && return
  [[ "$1" = "MacVim" ]] && icon_result=":vim:" && return
  [[ "$1" = "Vim" ]] && icon_result=":vim:" && return
  [[ "$1" = "VimR" ]] && icon_result=":vim:" && return
  [[ "$1" = "Vivaldi" ]] && icon_result=":vivaldi:" && return
  [[ "$1" = "VLC" ]] && icon_result=":vlc:" && return
  [[ "$1" = "VMware Fusion" ]] && icon_result=":vmware_fusion:" && return
  [[ "$1" = "Voice Memos" ]] && icon_result=":voice_memos:" && return
  [[ "$1" = "VSCodium" ]] && icon_result=":vscodium:" && return
  [[ "$1" = "Wave" ]] && icon_result=":waveterm:" && return
  [[ "$1" = "Weather" ]] && icon_result=":weather:" && return
  [[ "$1" = "Wetter" ]] && icon_result=":weather:" && return
  [[ "$1" = "WebStorm" ]] && icon_result=":web_storm:" && return
  [[ "$1" = "微信" ]] && icon_result=":wechat:" && return
  [[ "$1" = "WeChat" ]] && icon_result=":wechat:" && return
  [[ "$1" = "企业微信" ]] && icon_result=":wecom:" && return
  [[ "$1" = "WezTerm" ]] && icon_result=":wezterm:" && return
  [[ "$1" = "wezterm-gui" ]] && icon_result=":wezterm:" && return
  [[ "$1" = "WhatsApp" ]] && icon_result=":whats_app:" && return
  [[ "$1" = "‎WhatsApp" ]] && icon_result=":whats_app:" && return
  [[ "$1" = "Xcode" ]] && icon_result=":xcode:" && return
  [[ "$1" = "Yandex Browser" ]] && icon_result=":yandex_browser:" && return
  [[ "$1" = "Yandex Browser" ]] && icon_result=":yandex_browser:" && return
  [[ "$1" = "Yandex" ]] && icon_result=":yandex_browser:" && return
  [[ "$1" = "Yandex Music" ]] && icon_result=":yandex_music:" && return
  [[ "$1" = "Yazi" ]] && icon_result=":yazi:" && return
  [[ "$1" = "yazi" ]] && icon_result=":yazi:" && return
  [[ "$1" = "YouTube" ]] && icon_result=":youtube:" && return
  [[ "$1" = "Yubico Authenticator" ]] && icon_result=":yubico:" && return
  [[ "$1" = "Yuque" ]] && icon_result=":yuque:" && return
  [[ "$1" = "语雀" ]] && icon_result=":yuque:" && return
  [[ "$1" = "Zed" ]] && icon_result=":zed:" && return
  [[ "$1" = "Zen" ]] && icon_result=":zen_browser:" && return
  [[ "$1" = "Zen Browser" ]] && icon_result=":zen_browser:" && return
  [[ "$1" = "Twilight" ]] && icon_result=":zen_browser:" && return
  [[ "$1" = "Zeplin" ]] && icon_result=":zeplin:" && return
  [[ "$1" = "zoom.us" ]] && icon_result=":zoom:" && return
  [[ "$1" = "Zotero" ]] && icon_result=":zotero:" && return
  [[ "$1" = "Zulip" ]] && icon_result=":zulip:" && return
}
