![Untamed Raids](https://i.imgur.com/m8yvCh9.png)


# Untamed Bait and Traps

Untamed Bait is a script that allows players to place bait to attract animals and set bear traps to capture NPCs in the game. Players can interact with the bait and traps using in-game prompts, and the script provides a configurable experience to fit various server needs.

## Features

- **Place Bait**: Players can place various types of bait, each attracting different animals.
- **Spawn Animals**: Configurable animals will spawn after a set time and approach the bait.
- **Bear Traps**: Players can set bear traps that instantly kill animals or trap NPCs.
- **Interact with Trapped NPCs**: Players can free trapped NPCs using prompts.
- **Configurable Options**: Extensive configuration options for bait types, spawn behavior, blacklist zones, and bear traps.
- **Debug Mode**: Enable debug prints for easier troubleshooting.

## Installation

1. **Download and Extract**: Download the script and extract it into your resources folder.
2. **Rename the Folder**: Ensure the folder is named `untamed_bait`.
3. **Add to Server Config**: Add `ensure untamed_bait` to your `resources.cfg`.
4. **Configuration**: Customize the script by editing the `config.lua` file to fit your server's needs.

## Configuration

Edit the `config.lua` file to configure bait items, blacklist zones, bear trap settings, spawn distances, interaction times, and localization strings.

## Usage

### Placing Bait

Players can use bait items to place bait on the ground. After placing the bait, an animal will spawn based on the configuration and approach the bait after a set time.

### Setting Bear Traps

Players can set bear traps that will instantly kill animals or trap NPCs that come close. Trapped NPCs can be freed by other players using a prompt.

### Interacting with Bait and Traps

- **Picking Up Bait**: Players can pick up placed bait if no animal has approached.
- **Freeing Trapped NPCs**: Players can free NPCs trapped in bear traps using in-game prompts.

## Contributing

If you wish to contribute to this project, feel free to fork the repository and make modifications. Pull requests are welcome!

## License

This project is licensed under the GNU General Public License. See the LICENSE file for details.
