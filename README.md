# Hayase Nix Flake

A Nix flake for [Hayase](https://github.com/ThaUnknown/miru) (formerly Miru) - a torrent streaming application for anime.

## Features

- **Automatic Updates**: GitHub Actions automatically check for new releases and update the flake
- **Multi-platform**: Supports x86_64-linux and aarch64-linux
- **Minimal**: Simple and clean flake structure
- **AppImage**: Uses the official AppImage releases

## Quick Start

### Run directly
```bash
nix run github:yourusername/hayase-flake
```

### Install to your system
```bash
nix profile install github:yourusername/hayase-flake
```

### Use in your NixOS configuration

Add to your `flake.nix`:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hayase.url = "github:yourusername/hayase-flake";
  };

  outputs = { self, nixpkgs, hayase, ... }: {
    nixosConfigurations.your-system = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          environment.systemPackages = [ hayase.packages.x86_64-linux.default ];
        }
      ];
    };
  };
}
```

### Use in Home Manager

Add to your `home.nix`:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    hayase.url = "github:yourusername/hayase-flake";
  };

  outputs = { nixpkgs, home-manager, hayase, ... }: {
    homeConfigurations.your-user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        {
          home.packages = [ hayase.packages.x86_64-linux.default ];
        }
      ];
    };
  };
}
```

## About Hayase

Hayase (formerly Miru) is a modern app for streaming anime torrents in real-time, with no waiting for downloads to finish. It features:

- 📚 Anime list integration (AniList, Kitsu, MAL, or local storage)
- ⚡ Instant torrent streaming
- 📴 Offline mode support
- 🎨 Modern, fast UI
- 🔄 Social platform features

## Development

To contribute or modify this flake:

```bash
git clone https://github.com/yourusername/hayase-flake.git
cd hayase-flake
nix develop
```

### Manual update

To manually trigger an update:

```bash
# In the repository
nix run .#update
```

Or trigger the GitHub Action manually from the Actions tab.

## License

This flake is provided under the same license as Hayase itself (GPL-3.0+).

## Troubleshooting

### AppImage doesn't run
If you encounter issues with the AppImage, try:
```bash
nix run github:yourusername/hayase-flake -- --appimage-extract-and-run
```

### Missing dependencies
The flake includes common dependencies, but if you encounter missing libraries, please open an issue.

## Contributing

1. Fork the repository
2. Make your changes
3. Test with `nix flake check`
4. Submit a pull request

## Automatic Updates

This repository uses GitHub Actions to automatically:
- Check for new Hayase releases every 6 hours
- Update the flake.nix with new versions and hashes
- Create new releases matching upstream
- Keep flake.lock updated

The update process is completely automated and requires no manual intervention.
