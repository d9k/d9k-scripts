#!/usr/bin/python3

import argparse
import subprocess
import pprint
import os.path
import configparser

home = os.path.expanduser("~")
profiles_mozilla_path = home + r"/.mozilla/firefox"
profiles_ini_path = profiles_mozilla_path + r"/profiles.ini"
backup_cfg_folder_path = home + r"/scripts/cfg/firefox"
backup_cfg_path = backup_cfg_folder_path + r"/userContent.css"
backup_cfg_chrome_path = backup_cfg_folder_path + r"/userChrome.css"
#TODO список утилит + проверка через which + задание из параметра
edit_tool = "sublime-text"
merge_tool = "meld"
merge_in_bg = True


q = lambda string: '"' + string + '"'

pr = lambda obj: pprint.pprint(obj)

bg = lambda _bool: "&" if _bool else ""


#TODO: try add bg non-required named param
def bash(*command_parts):
    subprocess.call(["bash", "-c", " ".join(command_parts)])
    pass


def ini_get(ini: configparser.RawConfigParser, section: str, option: str):
    if not ini.has_option(section, option):
        return None
    return ini.get(section, option)


def get_profile_from_firefox_ini(ini_path):
    ini = configparser.RawConfigParser()
    ini.read(ini_path)

    for section in ini.sections():
        if ini_get(ini, section, 'Default') == 1:
            return ini[section]['Path']

    for section in ini.sections():
        if ini_get(ini, section, 'Name') == "default":
            return ini[section]['Path']

    return None


def main():
    parser = argparse.ArgumentParser(description='this script creates firefox css file')
    parser.add_argument(
        '--edit', '-e',
        help='just edit file no merge',
        action='store_true'
    )
    parser.add_argument(
        '--background', '-b',
        help="open editor in background",
        action='store_true'
    )
    parser.add_argument(
        '--chrome', '-c',
        help="edit userChrome.css, not userContent.css",
        action='store_true'
    )
    args = parser.parse_args()
    #pprint.pprint(args)
    if not os.path.isfile(profiles_ini_path):
        print("File", q(profiles_ini_path), "not found")
        return
    profile_name = get_profile_from_firefox_ini(profiles_ini_path)
    if not profile_name:
        print("No profile-name found in", q(profiles_ini_path))
        return
    profile_path = profiles_mozilla_path + '/' + profile_name
    if not os.path.isdir(profile_path):
        print("No profile folder at " + q(profile_path))
        return
    user_css_folder_path = profile_path + "/chrome"
    user_css_path = user_css_folder_path + "/userContent.css"
    user_chrome_path = user_css_folder_path + "/userChrome.css"

    bash("mkdir", "-p", user_css_folder_path)
    bash("touch", user_css_path)
    print("""
          Example:

          @-moz-document domain(example.com) {
              img{opacity: 0.05 !important;}
          }
          """)

    print("User css path: " + user_css_path)

    if args.chrome:
      css_path = user_chrome_path
      backup_path = backup_cfg_chrome_path
    else:
      css_path = user_css_path
      backup_path = backup_cfg_path

    if args.edit:
        bash(edit_tool, css_path, bg(args.background))
    else:
        bash(merge_tool, css_path, backup_path, bg(args.background))

if __name__ == "__main__":
    main()
