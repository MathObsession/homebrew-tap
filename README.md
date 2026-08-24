# MathObsession Homebrew Tap

Custom Homebrew formulas for the VicinusAI stack.

## Install

One line:

```bash
curl -fsSL https://raw.githubusercontent.com/MathObsession/VicinusAI/main/install.sh | bash
```

Or manually:

```bash
brew tap MathObsession/tap https://github.com/MathObsession/homebrew-tap
brew trust mathobsession/tap          # one-time Homebrew 6 requirement
brew install vicinus-ai               # short form works once tapped
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
