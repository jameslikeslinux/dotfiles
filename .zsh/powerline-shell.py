#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import os
import sys

def warn(msg):
    print('[powerline-bash] ' + msg)

class Powerline:
    symbols = {
        'compatible': {
            'lock': 'RO',
            'network': 'SSH',
            'separator': u'\u25B6',
            'separator_thin': u'\u276F'
        },
        'patched': {
            'lock': u'\uE0A2',
            'network': u'\uE0A2',
            'separator': u'\uE0B0',
            'separator_thin': u'\uE0B1'
        },
        'flat': {
            'lock': '',
            'network': '',
            'separator': '',
            'separator_thin': ''
        },
    }

    color_templates = {
        'bash': '\\[\\e%s\\]',
        'zsh': '%%{%s%%}',
        'bare': '%s',
    }

    def __init__(self, args, cwd):
        self.args = args
        self.cwd = cwd
        mode, shell = args.mode, args.shell
        self.color_template = self.color_templates[shell]
        self.reset = self.color_template % '[0m'
        self.bold = self.color_template % '[1m'
        self.lock = Powerline.symbols[mode]['lock']
        self.network = Powerline.symbols[mode]['network']
        self.separator = Powerline.symbols[mode]['separator']
        self.separator_thin = Powerline.symbols[mode]['separator_thin']
        self.segments = []

    def color(self, prefix, code):
        return self.color_template % ('[%s;5;%sm' % (prefix, code))

    def fgcolor(self, code):
        return self.color('38', code)

    def bgcolor(self, code):
        return self.color('48', code)

    def append(self, content, fg, bg, separator=None, separator_fg=None, bold=False):
        self.segments.append((content, fg, bg, separator or self.separator,
            separator_fg or bg, bold))

    def draw(self):
        return (''.join(self.draw_segment(i) for i in range(len(self.segments)))
                + self.reset).encode('utf-8')

    def draw_segment(self, idx):
        segment = self.segments[idx]
        next_segment = self.segments[idx + 1] if idx < len(self.segments)-1 else None
        bold = segment[5]

        return ''.join((
            self.fgcolor(segment[1]) if segment[1] > -1 else self.reset,
            self.bgcolor(segment[2]),
            ''.join((self.bold, segment[0], self.reset)) if bold else segment[0],
            self.bgcolor(next_segment[2]) if next_segment else self.reset,
            self.fgcolor(segment[4]),
            segment[3]))

def get_valid_cwd():
    """ We check if the current working directory is valid or not. Typically
        happens when you checkout a different branch on git that doesn't have
        this directory.
        We return the original cwd because the shell still considers that to be
        the working directory, so returning our guess will confuse people
    """
    try:
        cwd = os.getcwd()
    except:
        cwd = os.getenv('PWD')  # This is where the OS thinks we are
        parts = cwd.split(os.sep)
        up = cwd
        while parts and not os.path.exists(up):
            parts.pop()
            up = os.sep.join(parts)
        try:
            os.chdir(up)
        except:
            warn("Your current directory is invalid.")
            sys.exit(1)
        warn("Your current directory is invalid. Lowest valid directory: " + up)
    return cwd


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--cwd-only', action='store_true',
            help='Only show the current directory')
    arg_parser.add_argument('--cwd-max-depth', action='store', type=int,
            default=5, help='Maximum number of directories to show in path')
    arg_parser.add_argument('--colorize-hostname', action='store_true',
            help='Colorize the hostname based on a hash of itself.')
    arg_parser.add_argument('--mode', action='store', default='patched',
            help='The characters used to make separators between segments',
            choices=['patched', 'compatible', 'flat'])
    arg_parser.add_argument('--shell', action='store', default='bash',
            help='Set this to your shell type', choices=['bash', 'zsh', 'bare'])
    arg_parser.add_argument('prev_error', nargs='?', type=int, default=0,
            help='Error code returned by the last command')
    args = arg_parser.parse_args()

    powerline = Powerline(args, get_valid_cwd())


class DefaultColor:
    """
    This class should have the default colors for every segment.
    Please test every new segment with this theme first.
    """
    USERNAME_FG = 250
    USERNAME_BG = 240

    HOSTNAME_FG = 250
    HOSTNAME_BG = 238

    HOME_SPECIAL_DISPLAY = True
    HOME_BG = 31  # blueish
    HOME_FG = 15  # white
    PATH_BG = 237  # dark grey
    PATH_FG = 250  # light grey
    CWD_FG = 254  # nearly-white grey
    SEPARATOR_FG = 244

    READONLY_BG = 124
    READONLY_FG = 254

    SSH_BG = 166 # medium orange
    SSH_FG = 254

    REPO_CLEAN_BG = 148  # a light green color
    REPO_CLEAN_FG = 0  # black
    REPO_DIRTY_BG = 161  # pink/red
    REPO_DIRTY_FG = 15  # white

    JOBS_FG = 39
    JOBS_BG = 238

    CMD_PASSED_BG = 236
    CMD_PASSED_FG = 15
    CMD_FAILED_BG = 161
    CMD_FAILED_FG = 15

    SVN_CHANGES_BG = 148
    SVN_CHANGES_FG = 22  # dark green

    VIRTUAL_ENV_BG = 35  # a mid-tone green
    VIRTUAL_ENV_FG = 00

class Color(DefaultColor):
    """
    This subclass is required when the user chooses to use 'default' theme.
    Because the segments require a 'Color' class for every theme.
    """
    pass


# Basic theme which only uses colors in 0-15 range

class Color(DefaultColor):
    USERNAME_FG = 0
    USERNAME_BG = 4
    ROOT_BG = 1
    USERNAME_SEPARATOR = 9

    HOSTNAME_FG = -1 # no color
    HOSTNAME_BG = 7  # medium gray

    HOME_SPECIAL_DISPLAY = False
    PATH_BG = 15 # dark gray
    PATH_FG = -1 # no color
    CWD_FG = -1  # no color
    SEPARATOR_FG = 7

    READONLY_BG = 11
    READONLY_FG = 0

    REPO_CLEAN_BG = 2  # green
    REPO_CLEAN_FG = 0  # black
    REPO_DIRTY_BG = 1  # red
    REPO_DIRTY_FG = 15 # white

    JOBS_FG = 0
    JOBS_BG = 10

    CMD_PASSED_BG = 8
    CMD_PASSED_FG = 15
    CMD_FAILED_BG = 11
    CMD_FAILED_FG = 0

    SVN_CHANGES_BG = REPO_DIRTY_BG
    SVN_CHANGES_FG = REPO_DIRTY_FG

    VIRTUAL_ENV_BG = 2
    VIRTUAL_ENV_FG = 0



import os

def add_username_segment():
    user = os.getenv('USER')

    if user not in ['root', 'jlee', 'jtl']:
        if powerline.args.shell == 'bash':
            user_prompt = ' \\u '
        elif powerline.args.shell == 'zsh':
            user_prompt = ' %n '
        else:
            user_prompt = ' %s ' % os.getenv('USER')

        powerline.append(user_prompt, Color.USERNAME_FG, Color.USERNAME_BG, bold = True)

add_username_segment()


def add_hostname_segment():
    if os.getenv('SSH_CLIENT'):
        if powerline.args.colorize_hostname:
            from lib.color_compliment import stringToHashToColorAndOpposite
            from lib.colortrans import rgb2short
            from socket import gethostname
            hostname = gethostname()
            FG, BG = stringToHashToColorAndOpposite(hostname)
            FG, BG = (rgb2short(*color) for color in [FG, BG])
            host_prompt = ' %s' % hostname.split('.')[0]

            powerline.append(host_prompt, FG, BG, bold = True)
        else:
            if powerline.args.shell == 'bash':
                host_prompt = ' \\h '
            elif powerline.args.shell == 'zsh':
                host_prompt = ' %m '
            else:
                import socket
                host_prompt = ' %s ' % socket.gethostname().split('.')[0]

            powerline.append(host_prompt, Color.HOSTNAME_FG, Color.HOSTNAME_BG, bold = True)


add_hostname_segment()


import os

def get_short_path(cwd):
    home = os.getenv('HOME')
    names = cwd.split(os.sep)
    if names[0] == '': names = names[1:]
#    path = ''
#    for i in range(len(names)):
#        path += os.sep + names[i]
#        if os.path.samefile(path, home):
#            return ['~'] + names[i+1:]
    if not names[0]:
        return ['/']
    return names

def add_cwd_segment():
    #cwd = powerline.cwd or os.getenv('PWD')
    cwd = os.getenv("UNIQ_PWD")
    names = get_short_path(cwd)

#    $max_depth = powerline.args.cwd_max_depth
#    if len(names) > max_depth:
#        names = names[:2] + [u'\u2026'] + names[2 - max_depth:]

    if not powerline.args.cwd_only:
        for n in names[:-1]:
            if n == '~' and Color.HOME_SPECIAL_DISPLAY:
                powerline.append(' %s ' % n, Color.HOME_FG, Color.HOME_BG)
            else:
                powerline.append(' %s ' % n, Color.PATH_FG, Color.PATH_BG,
                    powerline.separator_thin, Color.SEPARATOR_FG)

    if names[-1] == '~' and Color.HOME_SPECIAL_DISPLAY:
        powerline.append(' %s ' % names[-1], Color.HOME_FG, Color.HOME_BG, bold = True)
    else:
        powerline.append(' %s ' % names[-1], Color.CWD_FG, Color.PATH_BG, bold = True)

add_cwd_segment()


import os

def add_read_only_segment():
    cwd = powerline.cwd or os.getenv('PWD')

    if not os.access(cwd, os.W_OK):
        powerline.append(' %s ' % powerline.lock, Color.READONLY_FG, Color.READONLY_BG)

add_read_only_segment()


import os
import re
import subprocess

def add_jobs_segment():
    #pppid = subprocess.Popen(['ps', '-p', str(os.getppid()), '-opid'], stdout=subprocess.PIPE).communicate()[0].strip()
    output = subprocess.Popen(['ps', '-a', '-o', 'ppid'], stdout=subprocess.PIPE).communicate()[0]
    num_jobs = len(re.findall(str(os.getppid()), output.decode('utf-8'))) - 1

    if num_jobs > 0:
        powerline.append(' %d ' % num_jobs, Color.JOBS_FG, Color.JOBS_BG)

add_jobs_segment()


import os

def add_root_indicator_segment():
    root = os.getenv('USER') == 'root'
    admin = os.getenv('ADMIN')
    background = Color.ROOT_BG if root else Color.USERNAME_BG

    if root and admin:
        powerline.append('', Color.USERNAME_FG, background, powerline.separator_thin, Color.SEPARATOR_FG)
    else:
        powerline.append('', Color.USERNAME_FG, background)

    if admin:
        powerline.append('', Color.USERNAME_FG, Color.ROOT_BG)

add_root_indicator_segment()



output = powerline.draw()
try:
    sys.stdout.buffer.write(output)
except AttributeError:
    sys.stdout.write(output)
