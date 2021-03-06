"""
This file will retrieve requirements text from a file.
"""

import vim
import re
from collections import defaultdict

REQUIREMENT_STRING = re.compile('R\d{8}')
def GetRequirementsFromVIM(buf_number):
    """
    This expects a Vim buffer and will query for the line information in that
    buffer.
    This is expected to be called from within a Vim script.

    Parameters:
        - buf_number: the number of the buffer to search for requirements in.
        
    Sets the buffer variable 'requirements' in buf_number to the following:
        A list where each element is a dictionary.  The dictionaries will have
        three keys:
            - requirement: The requirement number for the dictionary.
            - text: The text for the given requirement.
            - lines: a list of integers that indicates each line in the buffer
              where the requirement was seen.

        The list of requirements will be sorted by the 'requirement' key.
        The list of lines will be sorted by the line number.
    """
    buf = vim.buffers[buf_number]
    req_dict = defaultdict(list)
    for i, line in enumerate(buf):
        for requirement in re.finditer(REQUIREMENT_STRING, line):
            req_dict[requirement.group(0)].append(i)


    req_list = vim.List()
    # Now build up the return list
    for key in req_dict:
        local_dict = vim.Dictionary()
        local_dict['requirement'] = key
        local_dict['text'] = GetRequirement(key)
        local_dict['lines'] = vim.List(req_dict[key])
        req_list.extend([local_dict])

    buf.vars['requirements'] = req_list


def GetRequirement(requirement):
    """
    This function will get the requirement text for the given requirement.
    """
    return "The requirement text for: " + requirement
        


