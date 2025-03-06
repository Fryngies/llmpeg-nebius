# LLMPEG

Allows for simple usage of ffmpeg via an llm. 

## Example 

`llmpeg remove audio from exampleVid.mov`

### Demo
![llmpeg](https://github.com/user-attachments/assets/a26eb71f-7246-447e-a64d-587530c0b461)


## Requirements
* ffmpeg
* jq
* [an AI Studio API key environment variable set](https://docs.nebius.com/studio/api/authentication)

### Usage with Nix

Set NEBIUS_API_KEY property via `overrideAttrs` function when referencing in your configuration, like so:

```nix
inputs.llmpeg-nebius.packages.x86_64-linux.default.overrideAttrs (_: {
    NEBIUS_API_KEY = "your_api_key";
})
```
