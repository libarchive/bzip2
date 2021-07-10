#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--mode', choices={'compress', 'decompress'})
    parser.add_argument('bzip2')
    parser.add_argument('bzip_arg')
    parser.add_argument('input')
    parser.add_argument('reference', nargs='?')
    args = parser.parse_args()

    if args.mode == 'compress':
        test_compress(args)
    else:
        test_decompress(args)

def get_slice(data, line_no, size):
    if len(data) / size > line_no:
        return data[line_no:line_no + size]
    elif len(data) / size == line_no:
        return data[line_no:line_no + len(data) % size]
    else:
        return []

def print_binary(data, size):
    '''
    Print hex
    '''
    lines = int(len(data) / size)

    def render_slice(to_print, size):
        line = ''
        for byte in range(0, size):
            if byte == size / 2:
                line += ' '
            if byte < len(to_print):
                line += '{:02x}'.format(to_print[byte])
            else:
                line += '   '
        return line

    for line in range(0, lines):
        print(render_slice(get_slice(data, line, size), size))
    print('')

def print_binary_compare(actual, expected, size):
    '''
    Print hex comparison of two buffers
    '''
    a_lines = int(len(actual) / size)
    e_lines = int(len(expected) / size)
    lines = max(a_lines, e_lines)

    def render_slice(to_print, to_compare):
        line = ''
        for byte in range(0, size):
            if byte == size / 2:
                line += ' '
            if byte < len(to_print):
                if byte >= len(to_compare) or to_print[byte] != to_compare[byte]:
                    line += '\x1b[1;33m{:02x}\x1b[0m'.format(to_print[byte])  # bold yellow
                else:
                    line += '{:02x}'.format(to_print[byte])                   # plain
            else:
                line += '  '
        return line

    for line in range(0, lines):
        a_line = get_slice(actual, line, size)
        e_line = get_slice(expected, line, size)
        text_line = '{}  {}'.format(
            render_slice(a_line, e_line),
            render_slice(e_line, a_line)
        )
        print(text_line)
    print('')


def test_compress(args: argparse.Namespace) -> None:
    with open(args.reference, 'rb') as f:
        expected = f.read()

    with open(args.input, 'rb') as f:
        input_ = f.read()

    command = '{bzip2} {arg}'.format(
        bzip2=args.bzip2,
        arg=args.bzip_arg
    )

    print('\nRunning:  {}\n  with {} bytes of input from {}\n'.format(command, len(input_), args.input))

    p = subprocess.run(
        command.split(' '),
        stdout=subprocess.PIPE,
        input=input_)
    if p.returncode != 0:
        print('bzip2 failed to run')
        sys.exit(1)

    actual = p.stdout
    if actual != expected:
        print('comparison of actual and expected output failed')
        print(' actual:' + ' ' * 60 + 'expected:')
        print_binary_compare(actual, expected, 32)
        sys.exit(1)


def test_decompress(args: argparse.Namespace) -> None:
    with open(args.input, 'rb') as f:
        input_ = f.read()

    p = subprocess.run(
        [args.bzip2, args.bzip_arg],
        stdout=subprocess.PIPE,
        input=input_)
    if p.returncode != 0:
        print('bzip2 failed to compress')
        sys.exit(1)
    compressed = p.stdout
    dargs = '-d' if args.bzip_arg != '-3' else '-ds'

    command = '{bzip2} {arg}'.format(
        bzip2=args.bzip2,
        arg=dargs
    )

    print('\nRunning:  {}\n  with {} bytes of input from {}\n'.format(command, len(input_), args.input))

    p = subprocess.run(
        command.split(' '),
        stdout=subprocess.PIPE,
        input=compressed,
    )
    if p.returncode != 0:
        print('bzip2 failed to decompress')
        sys.exit(1)

    actual = p.stdout
    if input_ != actual:
        print('comparison of actual and expected output failed')
        print(' actual:' + ' ' * 60 + 'input:')
        print_binary_compare(actual, input_, 32)
        sys.exit(1)


if __name__ == "__main__":

    # Prevent OS environment variables from affecting the test suite.
    os.environ.pop('BZIP', None)
    os.environ.pop('BZIP2', None)

    main()
