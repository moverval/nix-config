#!/usr/bin/env python3
import sys
import os
from openai import OpenAI

api_key = os.getenv("OPENROUTER_API_KEY")

request = sys.argv[1]

if len(sys.argv) < 2:
    print("Request missing")
    sys.exit(1)

def modify_prompt(request):
    return f'''
Help to modify data. Nothing more.
REQUEST: '{request}'

--- DATA ---
'''

def resolve_prompt(request):
    return f'''
Answer the request. Nothing more.
REQUEST: '{request}'
'''

def build_prompt(request):
    """Build the prompt from a request.

    If stdin is not a TTY (i.e., piped input exists), prepend the prompt to the
    piped stdin content. Otherwise, resolve the request to a prompt.

    Args:
        request: The request used to construct or resolve the prompt.

    Returns:
        str: The final prompt string.
    """
    if not sys.stdin.isatty():
        return modify_prompt(request) + sys.stdin.read().strip()
    else:
        return resolve_prompt(request)

if not api_key or api_key.strip() == "":
    print("No API Key")
    sys.exit(1)

client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=api_key,
)

prompt = build_prompt(request)

if not prompt:
    print("No prompt")
    sys.exit(1)

try:
    completion = client.chat.completions.create(
        model="openrouter/auto",
        extra_body = {
            "preset": "@preset/cli"
        },
        messages=[{"role": "user", "content": prompt}]
    )

    print(completion.choices[0].message.content)
except Exception as e:
    print(f"API-Error: {e}", file=sys.stderr)
    sys.exit(1)
