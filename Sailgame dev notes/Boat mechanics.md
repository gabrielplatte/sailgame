#### Buoyant force:
- As children of the boat, make an array "floaters" of Raycast3D nodes and set up a `for floater in floaters` function
- Place them at or just below deck level, and make each one about as long as the distance from deck to keel at that spot.
- Set them to only collide with the water surface (collision layers are amazing)
- Each frame, update all floaters to point straight downwards.
- For each raycast, get its length, then measure the collision point
- Apply an upward force to the boat at the location of each floater, and scale it linearly based on how close the collision point is. 
- A longer raycast at the same point pointing upwards will deal with cases where the floater becomes submerged.

Two floaters should do the job, but we'll have to test that and see how well it self-rights. Wave implementation may also make a two-floater setup sink too low going over a crest, so more floaters inline may be needed.

Earlier prototypes used floaters low in the hull that pointed up, to actually detect submersion of a point on the boat, but those were never stable. This should be simpler to keep track of. 

