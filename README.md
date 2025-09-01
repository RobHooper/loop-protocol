# LOOP Protocol
A GMTK 2025 GameJam game by Bob H.

[Play the game on itch.io!](https://zyiu.itch.io/loop-protocol)


# The Idea:
* Asteroids but each attack rotates through a list of random abilities.
* Collect abilities 
* Loose abilities
* Like a deck re-shuffling

## Abilities:
* Simple shot
* Multi shot
* Fast shot
* Shield
* Super Saiyan
* Loop around border

# Assets downloaded:
https://screamingbrainstudios.itch.io/seamless-space-backgrounds
https://ravenmore.itch.io/pixel-space-shooter-assets


# Layers + Mask

| Object       | Phase           | Layer (is on) | Mask (collides with)                   |
| ------------ | --------------- | ------------- | -------------------------------------- |
| **Player**   | Always          | `3`           | `2, 4` (Asteroids, PowerUps)           |
| **Bullet**   | Always          | `1`           | `2` (Asteroids)                        |
| **PowerUp**  | Always          | `4`           | `3` (Player)                           |
| **Asteroid** | **During Fade** | `2`           | `1` (Bullets only)                     |
| **Asteroid** | **After Fade**  | `2`           | `1, 2, 3` (Bullets, Asteroids, Player) |
