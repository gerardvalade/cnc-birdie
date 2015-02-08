// calibration - calibration of some screws - a OpenSCAD 
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

include <scad/PlateAxis.scad>

$fn=30;

calibration();

module calibration()
{
	difference() 
	{
		translate([-1,-1,0]) cube([33,54,6], center=false);
		#translate([0,0,10.1]) {
			
			translate([17,6,0]) {
				rotate([180,0,0])  M3Hole(l=10.3);
				rotate([180,0,0])  M3Hexa(l=_get_nut_height("M3x5") );
				
			}

			 translate([7,17,0]) drawM3HoleThrought(l=10,h=_get_head_height("M3x5"));

			translate([7,6,0]) {
				rotate([180,0,0])  rotate([180,0,0]) _MXHole(name="M2.5", l=10.3);
				rotate([180,0,0])  rotate([180,0,0]) _MXHexa(name="M2.5", l=_get_nut_height("M2.5x8"));
			}

			translate([18,17,0]) {
				rotate([180,0,0])  rotate([180,0,0]) _MXHole(name="M4", l=10.3);
				rotate([180,0,0])  rotate([180,0,0]) _MXHexa(name="M4", l=_get_nut_height("M4x8"));
			}

			translate([7,28,0]) drawM5HoleThrought(l=10,h=_get_head_height("M5x8"));

			translate([19,28,0]) {
				rotate([180,0,0])  M5Hole(l=10.3);
				rotate([180,0,0])  M5RHexa(l=_get_nut_height("M5x8"));
			}
			
			
			translate([10,42,0]) {
				rotate([180,0,0])  M8Hexa(l=11);
			}
			
			translate([0,0,-5]) {
			translate([25,5,0]) drawHul(name="M2.5", l=10.3, gap=2);
			translate([25,13,0]) drawHul(name="M3", l=10.3, gap=2);
			translate([26,21,0]) drawHul(name="M4", l=10.3, gap=2);
			translate([26,34,0]) drawHul(name="M5", l=10.3, gap=2);
			translate([24,44,0]) drawHul(name="M8", l=10.3, gap=2);
			}
		}
	}
} 