#!/usr/bin/env python
import argparse
import asyncio

from googletrans import Translator

# Till https://github.com/ssut/py-googletrans/issues/447 fixed
# `pip install -U googletrans` required
async def main():
    parser = argparse.ArgumentParser(
        description="Python Google Translator as a command-line tool"
    )
    parser.add_argument("text", help="The text you want to translate.")
    parser.add_argument(
        "-d",
        "--dest",
        default="en",
        help="The destination language you want to translate. (Default: en)",
    )
    parser.add_argument(
        "-s",
        "--src",
        default="auto",
        help="The source language you want to translate. (Default: auto)",
    )
    parser.add_argument("-c", "--detect", action="store_true", default=False, help="")
    args = parser.parse_args()
    translator = Translator()

    if args.detect:
        result = translator.detect(args.text)
        result = f"""
[{result.lang}, {result.confidence}] {args.text}
        """.strip()
        print(result)
        return

    # result = translator.translate(args.text, dest=args.dest, src=args.src)
    result = await translator.translate(args.text, dest=args.dest, src=args.src)
    result = f"""
[{result.src}] {result.origin}
    ->
[{result.dest}] {result.text}
[pron.] {result.pronunciation}
    """.strip()
    print(result)


if __name__ == "__main__":
    loop = asyncio.new_event_loop()
    loop.run_until_complete(main())
