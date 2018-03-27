#!/usr/bin/python3

import argparse
import os
import pprint
import re

q = lambda string: '"' + string + '"'

pr = lambda obj: pprint.pprint(obj)

ini_hooks_section = "hooks"
ini_autopush_hook_key = "commit.autopush"
ini_autopush_hook_value = "hg push "


def find_in_lines(lines: list, reg_str: str, start_line: int=None, end_line: int=None) -> int:
    """
    @param lines: list of str
    @return: int|None first line number matching pattern
    """
    r = re.compile(reg_str)
    if start_line is None:
        start_line = 0
    if end_line is None:
        end_line = len(lines)
    for pos in range(start_line, end_line):
        if r.match(lines[pos]):
            return pos
    return None


def find_in_ini(ini_lines: list, section: str, key: str) -> (int, int, bool):
    """
    @param ini_lines: list of str
    @return section_pos: int|None, keyval_pos: int|None, commented_out: bool|None
    """
    section_pos = find_in_lines(ini_lines, "^\s*\[" + re.escape(section) + "\]\s*$")
    if section_pos is None:
        return section_pos, None, None
    # TODO ini_lines are passed by ref?
    next_section_pos = find_in_lines(ini_lines, "^\s*\[.*\]\s*$", section_pos+1)
    if next_section_pos is None:
        next_section_pos = len(ini_lines)
    keyval_pos = find_in_lines(ini_lines, "^\s*[#;]*\s*" + re.escape(key) + "\s*=.*$", section_pos+1, next_section_pos)
    if not keyval_pos:
        return section_pos, keyval_pos, None
    keyval_str = ini_lines[keyval_pos]
    commented_out = False if re.match("^\s*[#;]+.*=", keyval_str) is None else True
    return section_pos, keyval_pos, commented_out


def add_or_uncomment_ini_property(ini_lines: list, section: str, key: str, value: str):
    """
    @param ini_lines: list of str, may be changed
    """
    section_pos, keyval_pos, commented_out = find_in_ini(ini_lines, section, key)
    if not section_pos:
        print("adding section " + q(section))
        ini_lines.extend(["", "[" + section + "]"])
    if keyval_pos and not commented_out:
        print("already enabled")
        return False
    if not keyval_pos:
        print("adding key " + q(key))
        ini_lines.append(key + " = " + value)
    elif commented_out:
        print("uncommenting key " + q(key))
        keyval_line = ini_lines[keyval_pos]
        findings = re.match("\s*[;#]+", keyval_line)
        if findings.regs is not None and len(findings.regs):
            start_index, end_index = findings.regs[0]
            if start_index != 0:
                print("Error on searching comment position")
                return False
            ini_lines[keyval_pos] = keyval_line[end_index:]
    return True


def comment_ini_key(ini_lines: list, section: str, key: str):
    """
    @param ini_lines: list of str, may be changed
    """
    section_pos, keyval_pos, commented_out = find_in_ini(ini_lines, section, key)
    if keyval_pos and not commented_out:
        ini_lines[keyval_pos] = ";" + ini_lines[keyval_pos]
        return True
    print("already disabled")
    return False


def main():
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('action', nargs='?', help='[e]nable/[d]isable autohook')
    args = parser.parse_args()

    cwd = os.getcwd()
    hg_path = cwd + "/.hg"
    hgrc_path = hg_path + "/hgrc"
    if not os.path.isdir(hg_path):
        print("can't find mercurial repo ar " + q(cwd))
        return
    if not os.path.isfile(hgrc_path):
        print("can't find .hgrc at " + q(hgrc_path))
        return
    with open(hgrc_path) as ini_file:
        ini_lines = ini_file.read().splitlines(False)
        ini_file.close()

    action = args.action
    action_len = len(action) if isinstance(action, str) else 0

    def update_hgrc():
        with open(hgrc_path, "w") as ini_file_w:
            ini_file_w.write("\n".join(ini_lines))
            ini_file_w.close()

    if action_len > 0 and action == "enable"[:action_len]:
        print("enabling...")
        if add_or_uncomment_ini_property(ini_lines, ini_hooks_section, ini_autopush_hook_key, ini_autopush_hook_value):
            update_hgrc()
    elif action_len > 0 and action == "disable"[:action_len]:
        print("disabling...")
        if comment_ini_key(ini_lines, ini_hooks_section, ini_autopush_hook_key):
            update_hgrc()
    else:
        # default action: print status
        section_pos, keyval_pos, commented_out = find_in_ini(ini_lines, ini_hooks_section, ini_autopush_hook_key)
        status = "can't grok"
        if keyval_pos is None or commented_out is None:
            status = "No autopush hook found"
        elif commented_out:
            status = "autopush hook disabled"
        elif not commented_out:
            status = "autopush hook enabled"
        print("Checking status: " + status)
        #parser.print_help()
        print('(run with \"-h\" for help)')

if __name__ == "__main__":
    main()
