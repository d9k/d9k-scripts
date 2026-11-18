#!/usr/bin/env python
import argparse
import asyncio
import httpx

from googletrans import Translator
from httpx_curl_cffi import AsyncCurlTransport

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
    # https://github.com/ssut/py-googletrans/issues/457#issuecomment-5486047879
    translator = Translator(raise_exception=True)

    # https://github.com/ssut/py-googletrans/issues/457#issuecomment-5809692261
    transport = AsyncCurlTransport(
        impersonate="chrome",
        default_headers=True,
    )

    translator.client = httpx.AsyncClient(
        transport=transport,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/140.0.0.0 Safari/537.36"
            ),
        },
    )

    # googletrans' TokenAcquirer was created with the original
    # client, so point it at the replacement client as well.
    translator.token_acquirer.client = translator.client

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
