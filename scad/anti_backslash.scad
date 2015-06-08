// Birdie CNC - AntiBacklash - a OpenSCAD 
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
use <PlateUtils.scad>

module AntiBacklash(width=35,height=22,thick=60)
{
	module covert()
	{
		translate([-width/2,0,0]) difference() {
				
			color(color_module_anitbacklash_cover) 
		   			cube([width,height,4],center=false);
			
			translate([width/2,height/2,-0.1]) rotate([0,0,0]) { 
				cylinder(r=4.9,h=5.5);
			}
			
			for(i=[-1, 1]) 
			{
				translate([i*11+width/2,height/2,-0.02])
				 	rotate([0,0,0])  M3Hole(l=5.5);
			}
		}
	}
	
	if (showExtra) translate([0,-thick/2-exploded*10,0]) rotate([90, 0, 0])  covert();
	else translate([0,-thick,0]) covert();
	
		
	if (showExtra) {
		for(i=[-1, 1]) { 
			translate([i*12,0,-9]) 
				rotate([0,180,90]) 	
					drawBoltLowProfile("M5x30", 25);

			translate([i*11,-thick/2-5,height/2])
				 rotate([90,0,0]) 
					drawScrew("M3x16");
		}
		translate([0,0,height/2])  rotate([90,0,0])  {
			cylinder(r=4, h=90, center=true);
			rotate([0,0,90]) {
				translate([0,0,23.1]) rotate([0,180,0]) drawNut("M8");
				translate([0,0,-16])  rotate([0,0,0]) drawNut("M8");
			}
			translate([0,0,-16]) comp_spring([ 12, 1.5, 20, 5], l=30);
		}
	}
	difference() 
	{
		color(color_module_anitbacklash) translate([-width/2,thick/2,0]) rotate([90,0,0]) difference() 
		{	
   			cube([width,height,thick-1],center=false);
			
			translate([width/2,height/2,-0.1]) rotate([0,0,0]) { 
				cylinder(r=4.5,h=thick+2);
				rotate([0,0,90])  {
					M8Hexa(l=thick-16);
					translate([0,0,thick-6.5]) M8Hexa(l=18);
				}
				
			}
		}
		for(i=[-1, 1]) 
		{
			translate([i*12,0,-0.1])
				rotate([0,0,90]) {
					M5Hole(l=height+2);
					translate([0,0,16]) M5RHexa(l=6.5);
				}
			translate([i*11,-thick/2-0.5,height/2])
			 	rotate([270,0,0])  M3Thread(l=18);
		}
		if (showExtra && cutView)  color(color_cut_view) {
			// Cut view antibacklash
			translate([10,0,26]) cube([20,55,30], center=true);
			translate([-23,0,25]) cube([20,20,30], center=true);
		}
	}
}

