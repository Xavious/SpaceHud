# SpaceHud

An Eve Online-inspired spreadsheet view of ships in space for [Legends of the Jedi](https://www.legendsofthejedi.com/), a Star Wars-themed MUD.

SpaceHud provides real-time tracking of ships, projectiles, and spatial coordinates in an intuitive, sortable HUD window. Never lose track of targets in the heat of space combat again.

## Features

- **Real-time Ship Tracking**: Automatically captures and displays all ships detected by your sensors
- **Sortable Columns**: Click column headers to sort by ship type, name, proximity, position, or velocity
- **Coordinate Tracking**: Shows X, Y, Z coordinates with directional indicators (+/-) for movement
- **Projectile Detection**: Tracks incoming and outgoing missiles, rockets, and torpedoes with visual alerts
- **Right-Click Actions**: Context menu for quick access to `status`, `info`, `locate`, `target`, and `calculate` commands
- **Customizable Display**: Adjust column widths through an in-game settings panel
- **Auto-Hide/Show**: HUD automatically appears when you launch and disappears when you land

## Installation

### Prerequisites

- [Mudlet](https://www.mudlet.org/) (MUD client)
- Legends of the Jedi character with access to a ship

### Install from Release

1. Download the latest `SpaceHud.mpackage` from the [Releases](../../releases) page
2. In Mudlet, go to **Package Manager** (toolbar or `Ctrl+Shift+P`)
3. Click **Install** and select the downloaded `.mpackage` file
4. The package will install and activate automatically

### Build from Source

If you want to modify or contribute:

1. Clone this repository:
   ```bash
   git clone https://github.com/YourUsername/SpaceHud.git
   cd SpaceHud
   ```

2. Install [muddler](https://github.com/demonnic/muddler):
   ```bash
   # See muddler documentation for installation instructions
   ```

3. Build the package:
   ```bash
   muddle
   ```

4. Install `build/SpaceHud.mpackage` in Mudlet

## Usage

### Basic Commands

| Command | Description |
|---------|-------------|
| `helpspace` | Display help screen with all available commands |
| `showspace` | Show the SpaceHud window |
| `hidespace` | Hide the SpaceHud window |
| `clearships` | Clear all tracked ships from the display |

### Mouse Interactions

- **Left-click column headers**: Sort ships by that column (click again to reverse order)
- **Right-click ship rows**: Open context menu with quick actions:
  - **Status**: View ship status
  - **Info**: Get detailed ship information
  - **Locate**: Run `locateship` command
  - **Target**: Target the ship for weapons
  - **Calculate to**: Calculate jump coordinates to ship location

### Settings

Click the **Settings** button in the HUD to adjust column widths:
- Type width
- Name width
- XYZ coordinate width
- Proximity width
- Position width
- Velocity width

After adjusting values, click **Save** to apply changes and refresh the display.

### Debugging

For troubleshooting or development:

```
spacedebug 1    # Enable debug mode (prints diagnostic messages)
spacedebug 0    # Disable debug mode
dumpships       # Print internal ship data tables
```

## How It Works

SpaceHud uses regex pattern matching to capture ship information from game output:

1. **Radar Scans**: When you run `radar`, `recon`, or similar commands, the package captures ship coordinates
2. **Real-time Updates**: As proximity alerts and velocity readings appear, the display updates automatically
3. **Smart Reconciliation**: Ships are added, updated, or removed based on each radar sweep
4. **Movement Tracking**: Coordinate changes are detected and displayed as directional indicators

The HUD uses a two-phase tracking system:
- **Candidate collection**: Gather all ships detected in current scan
- **Reconciliation**: Compare with previous data to update, add, or remove ships

## Color Coding

- **Cyan**: Ship types and names
- **Red**: Coordinates (X, Y, Z) and incoming projectiles
- **Yellow**: Proximity values
- **Orange**: Position indicators
- **Purple**: Velocity readings
- **White**: Outgoing projectiles

## Development

### Project Structure

```
SpaceHud/
├── src/
│   ├── aliases/        # User command definitions and scripts
│   ├── scripts/        # Core logic (functions.lua, spacehud.lua)
│   ├── triggers/       # Game output pattern matchers
│   └── resources/      # Third-party libraries (ftext)
├── build/              # Generated package files (not in git)
├── mfile               # Muddler configuration
└── README.md
```

### Contributing

Contributions are welcome! Areas for improvement:

- Additional sorting options
- Filtering capabilities (show only enemies, only capitals, etc.)
- Distance-to-target calculations
- Threat level indicators
- Jump time estimates
- Fleet formation tracking

Please open an issue to discuss major changes before submitting a pull request.

### Building

The project uses [muddler](https://github.com/demonnic/muddler) as its build system. The `mfile` in the root directory contains package metadata.

To build:
```bash
muddle
```

Output files are generated in `build/`:
- `SpaceHud.xml` - XML package format
- `SpaceHud.mpackage` - Binary package format (install this one)

## Credits

- **Author**: Xavious
- **ftext Library**: [demonnic](https://github.com/demonnic) - Used for formatted table rendering
- **Inspiration**: Eve Online's spreadsheet-in-space aesthetic

## License

This project uses the ftext library by demonnic, which is licensed under the MIT License. See `src/resources/LICENSE.lua` for details.

## Support

For bugs, feature requests, or questions:
- Open an [Issue](../../issues)
- Contact Xavious in-game on Legends of the Jedi

## See Also

- [Legends of the Jedi](https://www.legendsofthejedi.com/) - The MUD this package is designed for
- [Mudlet](https://www.mudlet.org/) - The MUD client platform
- [muddler](https://github.com/demonnic/muddler) - Build tool for Mudlet packages
