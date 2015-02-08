// Endstop - a OpenSCAD library 
// Copyright (C) 2015  Gerard Valade

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

include <MCAD/materials.scad>
include <MCAD/units.scad>
include <bom.scad>;


module microswitch()
{
	color([0.9,0.9,0.9]) cube([13, 3, 5.80]);
	translate([0, 3, 0]) color([0.1,0.1,0.1]) cube([13, 3.65, 5.80]);
	translate([0, 6.67, 1]) rotate([0,0,15])  {
		color([0.7,0.7,0.7]) cube([16.67, 0.85, 3.80]);
	}
	
}


module endstop_hole()
{
	module hole()
	{
		cylinder(d=3.3,h=3);
	}
	
	translate([3, 3, -0.1]) {
		hole();
		translate([0, 10, 0]) {
			hole();
			translate([14.43, 0, 0]) hole();
			translate([33, 0, 0]) hole();
		}
		
	} 
}

module endstop()
{
	bom("endstop", "Endstop", ["electronic", "hardware"]);
	
	translate([-3,-13,0]) {
		color([1,0,0])
			difference() 
			{
				cube([39.45, 16, 1.70]);
				endstop_hole();
			}
		translate([20, 9.3, 1.70]) microswitch();
		translate([4.70, 1.73, 1.70]) color([0.91,0.91,0.91]) cube([6.88, 12.54, 6]);
	}
}

//endstop();