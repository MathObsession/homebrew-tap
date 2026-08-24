# MathObsession Homebrew Tap

Custom Homebrew formulas for the VicinusAI stack.

## Install

One command — the tap is added and trusted automatically:

```bash
brew install mathobsession/tap/vicinus-ai
```

Afterwards, installing or updating by short name also works:

```bash
brew install vicinus-ai
```

Updating later is just:

```bash
brew install vicinus-ai
```

This pulls in `turbo-fieldfare` (Swift + Metal Gemma 4 runtime) automatically.
Launch the whole stack with:

```bash
vicinus-ai
```

First run downloads the Gemma 4 model (~15 GB, once) to
`~/Library/Application Support/VicinusAI/gemma4.gturbo`, then serves the web
console at http://localhost:5001 with OpenAI-compatible inference on :8080.
`Ctrl+C` stops both servers.

## Formulas

| Formula | Purpose |
| --- | --- |
| `turbo-fieldfare` | Swift + Metal inference server and model installer |
| `vicinus-ai` | Flask/React console that orchestrates both servers |

Model weights are downloaded separately at runtime from their pinned Hugging
Face revision and remain governed by their source terms.
