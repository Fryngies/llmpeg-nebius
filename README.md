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

This package provides `withApiKey` function that allows to provide path to a file containing your API key.

```nix
home.packages = with pkgs; [
    # using static path
    (llmpeg-nebius.withApiKey "/path/to/file")
    # or using sops-nix
    # (llmpeg-nebius.withApiKey config.sops.secrets.nebiusApiKey.path)
];
```
