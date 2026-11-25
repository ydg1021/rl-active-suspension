# Reinforcement Learning for Active Suspension Control

A quarter-car active suspension controlled by a reinforcement-learning agent, built in Simulink with the Reinforcement Learning Toolbox.
The same model runs a passive suspension and a PID controller side by side, so the three responses can be compared on identical road inputs.

<p align="center">
  <img src="docs/model_overview.png" alt="Overview of the Simulink model" width="460" />
  <br>
  <sub>Overview of the Simulink model: road inputs on the left, the three suspension variants and the RL agent on the right.</sub>
</p>

## Publications

- D.-G. Yuk, J. W. Sohn, "Active Suspension Control Using Reinforcement Learning," *J. Korean Soc. Precis. Eng.*, 41(3), 223–230, 2024. https://doi.org/10.7736/jkspe.023.141
- Conference presentations: KSNVE Spring Conference 2023, KSME Annual Meeting 2023.

## Repository structure

| Path | Purpose |
|---|---|
| `simulink/quartercar_RL_6_no_G.slx` | Quarter-car model with the RL agent, the PID and passive baselines, road-input generators and the reward block |
| `docs/model_overview.png` | Thumbnail of the model diagram |

## How it works

- The plant is a two-mass quarter-car model (sprung body, unsprung wheel) with a spring–damper suspension and a tire spring.
- The RL agent outputs the actuator force between the body and the wheel.
- The agent observes four signals: body acceleration, suspension displacement, body velocity, and body velocity minus tire velocity.
- The reward is built from squared terms of the body displacement, the body–wheel deflection, the control input and the body acceleration, each scaled by a gain (`Rho 1` to `Rho 5`).
- Road inputs are selectable with manual switches: a half-cosine bump defined by height, length and vehicle speed, a pulse, band-limited white noise, and a chirp.
- The model also contains a PID-controlled copy of the plant and a passive (uncontrolled) version, and logs all three responses to the workspace.

Plant parameters as set in the model:

| Parameter | Symbol | Value |
|---|---|---|
| Sprung mass | `Ms` | 365 kg |
| Unsprung mass | `Mu` | 43 kg |
| Suspension stiffness | `ks` | 24,000 N/m |
| Suspension damping | `bs` | 2,126 N·s/m |
| Tire stiffness | `kt` | 243,000 N/m |
| PID baseline gains | `P`, `I`, `D` | 0.8, 0.1, 0.5 |

Signals logged to the workspace:

| Variable | Meaning |
|---|---|
| `body_displacement`, `body_acc` | Response with the RL agent |
| `pid_displacement`, `pid_acc` | Response with the PID controller |
| `passive_displacement`, `passive_acc` | Response of the passive suspension |
| `road_displacement` | Road input |
| `control_force` | Actuator force from the RL agent |
| `reward` | Reward signal |

## Requirements

- MATLAB with Simulink.
- Reinforcement Learning Toolbox (the model uses the `RL Agent` block).

## Running

- The `RL Agent` block expects an agent object named `saved_agent` in the base workspace.
- The simulation stop time is read from a workspace variable named `Tf`.
- Create or load an agent, set `Tf`, then run the model and plot the logged variables.

## Data

- The trained agent (`saved_agent`) and the script that created and trained it are not included.

## Notes

- Research code kept as it was used; the model was last edited in November 2023.
