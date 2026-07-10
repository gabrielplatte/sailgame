**Luffing mode:** Sail is edge-on to the wind. Very small drag force that gets stronger the further off precisely edge-on you get. Rippling animation that's faster at higher apparent wind speeds.

**Driving mode:** Sail is catching wind. Inefficient downwind drag force that increases the closer you get to perpendicular with apparent wind, and efficient orthogonal lift force that increases the closer you get to parallel with apparent wind. Billowing animation that strengthens at higher total force values.

**Wing force:** Strongest at a slight angle to the wind, when the sail is acting as a wing. Efficient. Force direction is on the normal axis. Force and efficiency peak at 90°.

**Parachute force:** Strongest near perpendicular to the wind, when sail is acting as a parachute. Inefficient. Force is applied directly towards downwind. Force and efficiency peak at 0° and 180°.
#### Convention:
the default "forward" normal vector for a fore-and-aft rigged sail is what would be the left/port facing face. this is 0 radians. the right/starboard face is PI radians
#### Process:
- 0° and 180° (zero and pi radians) are the faces of the sail. at these angles the wind would be experiencing the most resistance
- we make a normal vector for the sail, in the direction of its local -z axis. 
- To get the wind vector relative to the sail, we run
  `sail_normal.angle_to(apparent_wind)`
  *note: be sure to use [[apparent_wind]] rather than point_wind, as the latter doesn't take the sail's movement into account.*
- Next, we use the output of the angle_to function to select a sail mode. These values can be set using deg_to_rad
  *note: the following values are examples only, and may be tweaked:*
- between 85 and 95 degrees: luffing
- between 85 and 0, or between 95 and 180: driving 
- (low priority) Implement a delay on switching between sail modes. Shorten the delay at higher apparent wind speeds.
##### Driving process:
- Take the angle from the sail normal to the apparent wind vector, and call it the incidence angle.
**Wing force:**
- Scale force linearly based on incidence angle: from 1 × current base force value (at PI/2 rad) to 0 (at 0 rad or PI rad)
- If the incidence angle is less than 90°, wing force will be applied towards sail z (normal backward). If it's greater than 90°, multiply force by -1 so that wing force will be applied towards sail -z (normal forward).
**Parachute force:**
- Force is always applied in the same direction as apparent wind
- Scale force linearly based on incidence angle: from 1 × current base force value (incidence angle 0 rad) to 0 (incidence angle PI/2 rad) to 1 again (incidence angle PI rad)