# NpcTracker
This addon will track an NPC by executing another `.findnpc` command every time the NPC is found, and periodically.

This is useful, for example, if farming Oshu'gun Crystal Powder Sample from Shattered Rumbler, since you want to keep killing them for a while, not just once. Also, if looking for several NPCs, such as all rares in a zone.

### Usage
Available commands:
* `/track stop` - Stops tracking.
* `/track start` - Starts tracking the NPC list.
* `/track npc <npcName>` - Tracks npcName.
* `/track add <npcName>` - Adds npcName to the list of NPCs to track.
* `/track remove <npcName>` - Removes npcName from the list of NPCs to track.
* `/track clear` - Clears the list of NPCs to track.
* `/track list` - Lists NPCs in the list of NPCs to track.
* `/track interval <newInterval>` - Updates the tracking interval (<newInterval> in seconds).

`%t` can be used as a parameter when providing NPC names. List and tracking interval will be saved per character across sessions.

### Installation
Download this repository, then extract the `NpcTracker` subdirectory from the `src` directory into your `World of Warcraft/Interface/AddOns` directory.

### Download
[Github](https://github.com/BernatGames/NpcTracker)

### Additional comments
Thanks to all the people who have contributed addons to the server, they are very appreciated :). Also thanks to Scoots, Qt and Gescht, whose addons I've peeked into for developing this.
