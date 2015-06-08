// Birdie CNC - ZAxisPlateMotorHolder - a OpenSCAD 
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

module ZAxisPlateMotorHolder(width=70, height=75,thick=8, nemaHight=40, posNema=22, mat=[[-1, 1],[1, 1],[1,-1],[-1,-1]])
{
	module endStop(bolt=false)
	{
			translate([-25,48,thick/2]) {
				if (!bolt)
				difference() {
					rotate([0,0,45]) translate([0,-2,0]) cube([12,15,thick], center=true);
					translate([0,0,-5]) M3Hole(l=10);
					translate([0,0,-11.5]) M3Hexa();
				}
				if (bolt)
				 translate([0,0,10]) drawBolt("M3x16", 11.5);
			}
	}

	difference() 
	{	
		color(color_module_nema_holder) union() {
			
			translate([0,28,thick/2]) { 
				assign(wp=width/2,hp=height/2,hp2=25) {
					linear_extrude(height = thick, center = true, convexity = 0, twist = 0)
					polygon(points=[[-wp,-hp],[wp,-hp],[wp,0],[10,hp2],[-10,hp2],[-wp,0]], paths=[[0,1,2,3,4,5]]);
				}
			}
			endStop(false);
			translate([0,posNema,thick])  rotate([0,0,45]) {
				/*translate([16,-11,0]) rotate([90,0,90])
					linear_extrude(height = 3, center = true, convexity = 0, twist = 0)  
					polygon(points=[[0,0],[23,nemaHight-12],[23,nemaHight-2],[0,10]], paths=[[0,1,2,3]]);
				translate([-11,15,0]) rotate([90,0,0])
					linear_extrude(height = 3, center = true, convexity = 0, twist = 0)  
					polygon(points=[[0,0],[23,nemaHight-12],[23,nemaHight-2],[0,10]], paths=[[0,1,2,3]]);*/
				for (i = mat) 
				{
					translate([i[0]*NEMA17HolesSpacing/2,i[1]*NEMA17HolesSpacing/2,0]) {
						difference()
						{
							rotate([0,0,45]) cylinder(d=12.5,h=nemaHight, $fn=6);
							M3Hole(l=nemaHight+1);
						}
					}
				}
			}
		
		}

		translate([0,posNema,-1]) rotate([0,0,45]) {
			cylinder(r=12.4, h=thick+2);
			for (i = mat) 
			{
				translate([i[0]*NEMA17HolesSpacing/2,i[1]*NEMA17HolesSpacing/2,0]) cylinder(d=6.2, h=nemaHight-thick+3);
			}
		}		
		for(i=[-1, 1]) 
		{
			translate([i*10,0,thick/2]) rotate([0,0,0]) drawHul("M5", l=thick+2, gap=4);
		}
		if (showExtra && cutView) color(color_cut_view) {
			// Cut view name holder pillar
			translate([26,25,35]) cube([10,15,35], center=true);
			translate([-26,25,35]) cube([10,15,35], center=true);
			translate([0,48,35]) cube([15,10,35], center=true);
		}
	}
	if (showExtra) {
		translate([0,posNema,thick+nemaHight]) rotate([180,0,0]) NemaHolder(depth=0, showMotor=205, rot=45, mat=[[-1, 1],[-1, -1],[1,-1]]);
		endStop(true);
	}
}
	
