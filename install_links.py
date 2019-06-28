#!/usr/bin/env python3

"""Create a symlink or a copy of an installed file."""

import argparse
import os
import shutil


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('bindir')
    parser.add_argument('source')
    parser.add_argument('dest', nargs='+')
    parser.add_argument('--use-links', action='store_true')
    args = parser.parse_args()

    os.chdir(os.environ['MESON_INSTALL_DESTDIR_PREFIX'])
    os.chdir(args.bindir)

    # Windows doesn't really use symlinks, just copy in that case. Windows
    # before vista (xp) doesn't have symlinks at all.
    if args.use_links:
        func = os.symlink
        verb = 'Linking'
    else:
        func = shutil.copy
        verb = 'Copying'

    # at least os.symlink will fail if the destination already exists, just
    # remove the dest if it already exists.
    for dest in args.dest:
        if os.path.exists(dest):
            os.unlink(dest)

        func(args.source, dest)
        print('{} {} to {}'.format(verb, args.source, dest))


if __name__ == "__main__":
    main()