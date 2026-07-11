### Physics code

**Driving mode:** Sail is catching wind. Inefficient downwind drag force that increases the closer you get to perpendicular with apparent wind, and efficient orthogonal lift force that increases the closer you get to parallel with apparent wind. Billowing animation that strengthens at higher total force values.

**Luffing mode:** Sail is edge-on to the wind. Very small drag force that gets stronger the further off precisely edge-on you get. Rippling animation that's faster at higher apparent wind speeds.

**Wing force:** Strongest at a slight angle to the wind, when the sail is acting as a wing. Efficient. Force direction is on the normal axis. Force and efficiency peak at 90° (though actually reaching 90º is impossible).

**Parachute force:** Strongest near perpendicular to the wind, when sail is acting as a parachute. Inefficient. Force is applied directly towards downwind. Force and efficiency peak at 0° and 180°.

**Deflection force:** Derived as a fraction of the parachute force's strength, and applied at a tangent to wind direction.

Convention: the default "forward" normal vector for a fore-and-aft rigged sail is what would be the left/port facing face. this is 0 radians. the right/starboard face is PI radians
#### Sail script:
- Get the wind vector at current coordinates
- Subtract current velocity from wind vector to get apparent wind, which will be used for all force calculations.
- 0° and 180° (zero and pi radians) are the faces of the sail. at these angles the wind would be experiencing the most resistance
- Make a normal vector for the sail, in the direction of its local -z axis.
- To get the wind vector relative to the sail, run
  `sail_normal.angle_to(apparent_wind)`
- Use the output of the angle_to function to decide whether the sail is luffing. These values can be set using deg_to_rad. For example, luffing may begin when the incidence angle is less than 95 degrees and greater than 85.
- (low priority) Implement a delay on coming out of luffing. Shorten the delay at higher apparent wind speeds.
- (when sail tension is implemented) Lengthen the above delay at higher looseness values, and introduce some randomness into the delay that also increases with looseness.
##### Driving process:
- Take the angle from the sail normal to the apparent wind vector, and call it the incidence angle.
- Run wing function
- Run parachute function
- Run deflection function
**Wing force:**
- if not luffing:
- Scale force linearly based on incidence angle: from 1 × current base force value (at PI/2 rad) to 0 (at 0 rad or PI rad)
- If the incidence angle is less than 90°, wing force will be applied towards sail z (normal backward). If it's greater than 90°, multiply force by -1 so that wing force will be applied towards sail -z (normal forward).
**Parachute force:**
- Force is always applied in the same direction as apparent wind
- Scale force linearly based on incidence angle: from 1 × current base force value (incidence angle 0 rad) to 0 (incidence angle PI/2 rad) to 1 again (incidence angle PI rad)
- Divide this force by a set value if luffing
- (when sail tension is implemented) Decrease the above value at higher looseness values
**Deflection force:**
- Force is applied at the tangent to the wind vector that is closest to the sail's normal vector or antinormal vector, depending on whether the incidence angle is below or above PI radians.
- Scale the force based on incidence angle so that it peaks at 45º and 135º, and drops to nothing at 0º, 90º, and 180º.
- (when sail tension is implemented) Decrease the overall force at higher looseness values
- Divide this force by a set value if luffing
- (when sail tension is implemented) Increase the above value at higher looseness values