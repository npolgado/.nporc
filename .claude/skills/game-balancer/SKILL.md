---
name: game-balancer
description: analyzes game source code and configuration values to estimate gameplay balance. It evaluates numeric parameters such as damage, health, cooldowns, spawn rates, economy values, and procedural difficulty, then suggests concrete balance improvements. Use to assist developers by identifying imbalance, estimating gameplay outcomes, and recommending parameter adjustments or systems to implement.
allowed-tools: Bash(git *), Read, Grep, Glob, Edit
---

# Game Balance Analyzer

Analyze the current game state for balancing issue

## Steps

1. **Read the docs** in the project root. Note any recent balancing changes, as well as the current parameters relevant to game difficulty.

2. **Identify relevant source code** for game mechanics, and where game parameters are used. this is vital for understanding the current balance of the game.
Example relevant game systems:
- Enemy or level scaling
- Enemy stat table
- Weapon damage definitions
- Ability cooldown system
- Spawn manager
- Currency/Scoring
- Death conditions (if any)
- Win conditions (if any)
- Difficulty scaling logic

3. **Extract Balance Parameters**. Important numeric values are extracted from the source.
Examples:
- Player HP
- Enemy HP
- Damage values
- Cooldowns
- Spawn intervals
- Loot drop probabilities
- Upgrade costs
- Difficulty multipliers

4. **Estimate Gameplay Outcomes** and extract gameplay estimates such as: 
- Combat Pacing: Estimate any combat or player/enemy interactions for death conditions
    - Example: Enemy Damage will not scale past total player HP until scaling reaches critical level/wave/round X
- Encounter Difficulty: Estimate enemy pressure from spawn rate, lifetime, damage per second (DPS), expected wave/population/round
    - Example: with an expected population of ~5-10 enemies, the player expected to get hit with about 50 DPS. expected death within 2-5 seconds, rated difficulty is hard. 
- Economy pacing estimation: given the economy / scoring system, does the pacing match the expected game mechanics at that score / bank roll? 
    - Example: the player can theoretically reach a 8x combo, and if they kill every enemy, reach a total score of 150k. This allows for elite enemy types at wave X which would not match the game pacing. 


5. **Identify Balance Issues** and flag any potentially game breaking or overbearing game balancing issues. identify root causes for these issues, as well as the parameters in play. 

6. **Suggest Balance Changes** Concrete changes should be suggested in configuration form whenever possible. only suggest source code changes if they modify the game balance. 

## Example

If invoked as `please review the game balance using /game-balancer`, and new commits added a new wave spawning mechanic as well as adjusted some spawn parameters. 

```
Current Game Balance == Stable!
- New wave mechanic is expected to only become difficult past wave 5, matching game difficulty. 
- New spawn rate is expected to raise difficulty from an expected highscore of 150k to 100k, or around 10k/wave

Concerns:
Wave total time is constant across waves, meaning wave 1 is just as long as wave 10, making it very easly to breeze through higher waves. 
Suggestion -> scale wave time (ex: add +10s each wave.)

```
