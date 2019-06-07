#!/usr/bin/env python3

import argparse
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


def test_compress(args: argparse.Namespace) -> None:
    with open(args.reference, 'rb') as f:
        expected = f.read()

    with open(args.input, 'rb') as f:
        input_ = f.read()

    p = subprocess.run(
        [args.bzip2, args.bzip_arg],
        stdout=subprocess.PIPE,
        input=input_)
    if p.returncode != 0:
        sys.exit(1)


def test_decompress(args: argparse.Namespace) -> None:
    with open(args.input, 'rb') as f:
        input_ = f.read()

    p = subprocess.run(
        [args.bzip2, args.bzip_arg],
        stdout=subprocess.PIPE,
        input=input_)
    if p.returncode != 0:
        sys.exit(2)
    compressed = p.stdout
    dargs = '-d' if args.bzip_arg != '-3' else '-ds'
    p = subprocess.run(
        [args.bzip2, dargs],
        stdout=subprocess.PIPE,
        input=compressed,
    )
    if p.returncode != 0:
        sys.exit(1)


if __name__ == "__main__":
    main()