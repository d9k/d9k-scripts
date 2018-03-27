#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: set fileencoding=utf8

# by Alan Franzoni.
# this code is released in the public domain.

# from https://www.keepassx.org/forum/viewtopic.php?f=2&t=1707#p3443

import sys
from time import strptime
from xml.etree.ElementTree import parse, ElementTree

class KPMerger(object):
    """
    Merge keepassx xml-format dbs.

    Some details:
    entry title + username is considered the "primary key". entries from the
    two dbs are considered the same if such couplet is the same.
    keepassx supports a sort of entry history, which saves "old" versions of an
    entry. in order to perform the merge, the latest entry, i.e. the one with
    the more recent lastmod, is compared.
    the lastmod value is central to the comparison; the most recent entry
    overwrites the older one.

    Possible todos/improvements:
    - check for conflicts: if an entry appears in a db but it's not in the
      histroy of another, it might be a conflict that should be manually
      solved.
    - check for deletion: if an entry is available in the Backup group but it's
      not in any other main group, it has was probably deleted and should not
      be merged back.

    Warning:
     use something like a ramdisk and/or shred/safely delete xml files after
     use, because they're NOT encrypted.
    """

    SEP = "$$$" # mustn't appear in title nor usernames
    KP_TIMEFORMAT = "%Y-%m-%dT%H:%M:%S"

    def get_entry_lastmod_time(self, entry):
        return strptime(entry.find("lastmod").text, self.KP_TIMEFORMAT)

    def get_entry_key(self, entry):
        """
        the key for an entry is title + username combo. $$$ is used as a sort of
        escape.
        """
        return (entry.find("title").text or "") + self.SEP + (
                entry.find("username").text or "")

    def sorted_dict_items(self, d):
        # sort by key lexicographical order.
        return sorted(d.iteritems(), key=lambda x:x[0])

    def get_group_entries(self, elem):
        """
        for comparison's sake, take the most recent entry.
        """
        d = {}
        for entry in elem.findall("entry"):
            key = self.get_entry_key(entry)
            old_entry = d.get(key, None)
            if old_entry:
                # check the lastmod attribute
                if self.get_entry_lastmod_time(entry) > self.get_entry_lastmod_time(
                        old_entry):
                        # overwrite with the most recent.
                        d[key] = entry
            else:
                d[key] = entry

        return d

    def get_subgroup_names(self, elem):
        # don't modify backups
        return dict([(group.find("title").text, group) for group in
            elem.findall("group") if group.find("title").text != "Backup"])


    def add_missing_groups(self, source, dest):
        """
        if there's a group in source but not in dest, add it to dest.
        renames will cause duplication.
        """
        dest_groups = self.get_subgroup_names(dest)
        for source_group_name, source_group_obj in self.get_subgroup_names(
                source).iteritems():
            if source_group_name in dest_groups:
                # check and add potentially missing subgroups.
                self.add_missing_groups(source_group_obj,
                        dest_groups[source_group_name])
            else:
                dest.append(source_group_obj)

    def merge_entry(self, first, second, d_group, key):
        if self.get_entry_lastmod_time(first) > self.get_entry_lastmod_time(second):
            print "Entry %s/%s was changed." % tuple(key.split(self.SEP))
            second_entry_index = list(d_group).index(second)
            d_group.insert(second_entry_index+1, first)

    def merge_entries(self, source, dest):
        """
        # rules:
        # if an entry is in source but not in dest, it is added.
        # if an entry is both in source and dest:
        # if the content is the same, do nothing and be happy.
        # if the content differs, fully take the one with the most recent lastmod.
        """
        s_groups = self.get_subgroup_names(source)
        for group_name, s_group in s_groups.items():
            s_entries = self.get_group_entries(s_group)

            d_groups = self.get_subgroup_names(dest)
            d_group = d_groups[group_name]
            d_entries = self.get_group_entries(d_group)

            for s_entry_key, s_entry in s_entries.items():
                if not (s_entry_key in d_entries):
                    print "missing %s/%s in dest, appending" % tuple(
                            s_entry_key.split(self.SEP))
                    d_group.append(s_entry)
                else:
                    d_entry = d_entries[s_entry_key]
                    self.merge_entry(s_entry, d_entry, d_group, s_entry_key)

            self.merge_entries(s_group, d_group)

    def merge_databases(self, first_xml_db_filename, second_xml_db_filename,
            destination_filename):
        first_xml_db = parse(first_xml_db_filename).getroot()
        second_xml_db = parse(second_xml_db_filename).getroot()

        self.add_missing_groups(first_xml_db, second_xml_db)
        self.merge_entries(first_xml_db, second_xml_db)
        ElementTree(second_xml_db).write(destination_filename)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print ("Usage:\n%s first_xml_db second_xml_db destination_xml_db\n" %
                sys.argv[0])
        sys.exit(1)

    m = KPMerger()
    m.merge_databases(*sys.argv[1:])
