// Birdie CNC - Plate Y Axis - a OpenSCAD 
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


//include <plate_axis_def.scad>

module frameYAxisPlate()
{
	
	module XAxisMountOnY(posX, posY, TopAxisMount_w)
	{
		for (i = [-1, 0]) 
		{
			translate([posX,posY+i*20,PlateThickness/2]) rotate([0,0,90]) drawHul("M5", l=Hole_Plate, gap=TopAxisMount_w);
		}
		translate([posX-TopAxisMount_w/2-5.5,posY+5.5,-PlateThickness/2]) rotate([0,0,0]) cube([15,2.5,20]);
		//#translate([posX-TopAxisMount_w/2+8,posY+6.25,PlateThickness/2]) rotate([0,0,90]) drawHul("M2.5", l=Hole_Plate+20, gap=15);
		//#translate([posX-TopAxisMount_w/2-4,posY+5,-PlateThickness/2]) rotate([0,0,0]) cube([10,3,20]);
	}
	
	module XAxisEndstop(endstop)
	{
		translate([0,0,0]) {
			translate([0,plate_height(type)-6,9+exploded*25]) rotate([-90,0,90]) {
				if (endstop==1 && showModule) {
					XAxisEndstopHolder();
				} else if (endstop==0) {
					XAxisEndstopHolder(hole=true);
				}
				
			}

		}
	}


	module CableChain()
	{
		if (showModule && ModuleTypeYAxisRight(type))
		{
			//translate([plate_width(type) -2, 40, 8+plate_thickness(type)]) rotate([0,-90,-90]) chain_link_yaxis_mobil(0);

			translate([12, 40, 8+plate_thickness(type)]) rotate([0,-90,-90]) {
				chain_link_yaxis_mobil2(0);
			 	translate([20,0,10]) rotate([0,180,0])  {
			 		for(i=[1: 10])  chain_link(pos=i);
			 		chain_link(pos=11, rot=45);
		 		}
			}

		}
	}
	
	if (addBrims) {
		drawBrims();
	}
	
	hh=45;
	ww=plate_extra_width(type);
	
	difference() 
	{
		color(color_module_plateY)  union() {
		
			if(VSlotSpacingAdjustPartType==1)
			{
				VSlotSpacingAdjustPart();
			}

			difference() 
			{
				
				union() {
   					cube([plate_width(type),plate_height(type),PlateThickness]);
   					translate([-ww,plate_height(type)-hh,0]) cube([ww,hh,PlateThickness]);
   					//translate([-ww-6.5,plate_height(type)-hh,-0.1]) cube([20,42,PlateThickness]);
   					
					assign(wp=8) {
						hp=wp;
						translate([-wp,plate_height(type)-hh-hp,0]) 
							rotate([0,0,0]) linear_extrude(height = PlateThickness, center = false, convexity = 0, twist = 0)
							polygon(points=[[wp,0],[wp,hp],[0,hp]]);
					}
				}
				
				
				translate([plate_width(type)/2+10,plate_height(type)-50,-1]) 
					assign(wp=50.1,hp=50.1) {
							rotate([0,0,0]) linear_extrude(height = PlateThickness+2, center = false, convexity = 0, twist = 0)
							polygon(points=[[wp,0],[wp,hp],[0,hp]]);
					}

				translate([plate_width(type)/2+7,plate_height(type)-50,-1]) 
					assign(wp=34.1,hp=34.1,hh=16) {
							rotate([0,0,0]) linear_extrude(height = PlateThickness+2, center = false, convexity = 0, twist = 0)
							polygon(points=[[wp,0],[0,hp],[0,hp-hh],[wp-hh,0]]);
					}

				if(VSlotSpacingAdjustPartType==2) {
					assign(w1=plate_width(type)/3) {
						translate([-0.1,-0.1,-0.1])	
						cube([w1,30,PlateThickness+2]);
						translate([plate_width(type)-w1+0.1,-0.1,-1])	
						cube([w1,30,PlateThickness+2]);
					}
				}
				
				translate([plate_width(type)/2, 45, -0.02]) 
					hull () {
						translate([-25, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
						translate([25, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
					}
				
			}
		} // end union

		translate([plate_width(type)/2,VSlotWheelMount_refY]) 
			VSlotWheelAndNemaMotor(width=plate_width(type)-15, withNemaMotor=true);
		
	
		translate([-ww,0,0]) {
			//XAxisMountOnY(40, plate_height(type)-11, 45);
			//XAxisMountOnY(39, plate_height(type)-11, 42);
			//XAxisMountOnY(33, plate_height(type)-11, 42);
			XAxisMountOnY(33, plate_height(type)-11, 42);
			//#XAxisEndstop(0);
		}
		ToolMounting(plate_width(type));
		
	
		drawExtractor();
	
		// Plate Spring part
		if(VSlotSpacingAdjustPartType==1||VSlotSpacingAdjustPartType==3)
		{
			VSlotSpacingAdjustPart(partType=1);
		}
	
		

	} // end difference
	
	
//		#translate([posX+i*(posX-15),posY+11,posZ+6])
//		rotate([0,90,(i+1)*90]) { 
//			drawBolt("M3x16", 14);
//		}
		
	
	
	mountWheel(withNemaMotor=true);
	
	if (ModuleTypeYAxisLeft(type)) {
		translate([-ww,0,0]) XAxisEndstop(1);
	}
	
	CableChain();
	
	if(VSlotSpacingAdjustPartType==2)
	{
		VSlotSpacingAdjustPart2();
	}
}

