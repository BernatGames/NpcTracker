# NpcTracker
This addon will track an NPC by executing another `.findnpc` command every time the NPC is found.

This is useful, for example, if farming Oshu'gun Crystal Powder Sample from Shattered Rumbler, since you want to keep killing them for a while, not just once.

### Usage
Available commands:
* `/track npcName` - Tracks an NPC until asked to stop.
* `/untrack` - Stops tracking an NPC.
`/track %t` works if you're targetting the NPC.
The re-tracking feature might fail if you reach the destination and the NPC is not up. Since there's no in-game message, I still haven't found how to re-track in this scenario. This is typically the case for scarce or single spawn NPCs.

### Installation
Download this repository, then extract the `NpcTracker` subdirectory from the `src` directory into your `World of Warcraft/Interface/AddOns` directory.

### Download
[Github](https://github.com/BernatGames/NpcTracker)

### Additional comments
Thanks to all the people who have contributed addons to the server, they are very appreciated :). Also thanks to Scoots, Qt and Gescht, whose addons I've peeked into for developing this.
Disclaimer: this is my first addon.
