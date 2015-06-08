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

module addSpacer(wheel, h=PlateThickness)
{
	module M5BoltSpacer()
	{
		translate([0, 0, -39]) shim(10,5,60,"spacer", "Spacer");
		translate([0, 0, -2.5])  drawBolt("M5x80", 73);
	}

	
	module spacerHole(wheel)
	{
		if (wheel==1 && ModuleTypeXAxisFront(type)) {
			if(showExtra) {
				M5BoltSpacer();
			}
		}
		if (wheel==0) {
			translate([0,0,-PlateThickness-1.5]) M5Hole(l=PlateThickness+2);
			translate([0,0,0])	M5Hexa(l=2.5);
			//translate([0,0,0]) rotate([0, 0, 0]) drawM5HoleThrought(l=10, h=2, hcld=2);
		}
		if (wheel==-1 && ModuleTypeXAxisBack(type))
			translate([0,0,-1])  difference() { 
				cylinder(r=8, h=3);
				translate([0,0,PlateThickness]) M5Hexa(l=10);									
			}
	}
	
	for (i = [-1, 1]) 
	{
		// Cut view spacer 
		if (wheel==0 && cutView) color(color_cut_view) translate([plate_width(type)/2+i*(plate_width(type)/2-12),127,PlateThickness/2]) cube([30,35,15], center=true) ; 
		translate([plate_width(type)/2+i*(plate_width(type)/2-12),110,PlateThickness+1.02]) 
			spacerHole(wheel=wheel);
	}		
}


module frameXAxisPlate(withNemaMotor)
{
	if (addBrims) {
		drawBrims();
	}
		   				
	difference() 
	{
		color(color_module_plateX) union() {
		
			if(VSlotSpacingAdjustPartType==1)
			{
				VSlotSpacingAdjustPart();
			}

			addSpacer(wheel=-1);

		
			difference() 
			{
   				cube([plate_width(type),plate_height(type),PlateThickness]);
   				
				for (i = [-1,1]) 
				{
					translate([plate_width(type)/2+i*35,plate_height(type)-28,-1]) 
						assign(wp=i*30,hp=30) {
							rotate([0,0,0]) linear_extrude(height = PlateThickness*2, center = false, convexity = 0, twist = 0)
							polygon(points=[[wp,0],[wp,hp],[0,hp]], paths=[[0,1,2,3,4,5]]);
						}
				}
							
				if(VSlotSpacingAdjustPartType==2) {
					assign(w1=plate_width(type)/3) {
						translate([-0.1,-0.1,-1])	
						cube([w1,30,PlateThickness+2]);
						translate([plate_width(type)-w1+0.1,-0.1,-1])	
						cube([w1,30,PlateThickness+2]);
					}
				}
				
				if(ModuleTypeXAxisBack(type))
					translate([plate_width(type)/2, 45, -0.02]) 
						hull () {
							translate([-25, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
							translate([25, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
						}
				
			}
		} // end union


		translate([plate_width(type)/2,VSlotWheelMount_refY]) 
			VSlotWheelAndNemaMotor(width=plate_width(type)-15, withNemaMotor=withNemaMotor);
		
//			if(ModuleTypeXAxisFront(type))
//				translate([plate_width(type)/2 ,plate_height(type)-4, 0]) ZAxisEndstop(0);
		
	 	ToolMounting(plate_width(type));
		
		addSpacer(wheel=0);

		drawExtractor();

		// Plate Spring part
		if(VSlotSpacingAdjustPartType==1)
		{
			VSlotSpacingAdjustPart(partType=1);
		}

	} // end difference
	
	VSlotSpacingAdjustPart(partType=2);
	//VSlotSpacingAdjustPartScrew();
	
	if(VSlotSpacingAdjustPartType==1)
	{
		VSlotSpacingAdjustPart2();
	}

}

module frameXAxisBackPlate()
{
	module CableChain()
	{
		if (showModule)
		{
			translate([20, 60, plate_thickness(type)+4]) { 
				rotate([90,-0,-90]) chain_link_xaxis_mobil(0);
				
		 		translate([0,0,20]) rotate([90,0,-90])  { 
		 			for(i=[0: 1]) chain_link(pos=i);
		 			chain_link(pos=2, rot=45);
		 		}
			
			}
		}
	}
	
	frameXAxisPlate(withNemaMotor=true);

	mountWheel(withNemaMotor=true);
	//addSpacer(wheel=1, h=0);

	CableChain();
}

module frameXAxisFrontPlate(w1=plate_height(type)-15,y1=5)
{

	module trunck()
	{
		cube([30,22,15], centrer=true);
		for (i = [-1, 1]) 
		{
			translate([i*10+15,16,-1]) 	rotate(45) cube([6,6,18]);
		}
	}	
	
	module ZAxisEndstop(endstop)
	{
		translate([plate_width(type)/2 ,plate_height(type)-4, 0]) {
			if (endstop) {
				translate([5,0,-1-exploded*20]) rotate([0,180,0]) endstop();
			} 
			for (i = [28,  9.5, -9.5, -28]) 
			{
				if (endstop==0) {
					translate([i,0,-1]) rotate([0,0,0]) M2_5Thread();
				}
				if (endstop==1 && i < 0) {
					translate([i,0,-2.5-exploded*15]) rotate([0,180,0]) drawScrew("M2.5x8");
				}
			}
		}
	}

	color(color_module_plate2) translate([plate_width(type)/2,y1,0]) {
		translate([-VSlotWheelSpacing20x40_Z/2, 0, 0]) {
			difference() 
			{
				ZPlateSpacerFrame(w1, leftSide=1, h=ZSpacerSocle, xaxis=2, wheel=0);
				translate([-15, 0, -1]) trunck();
			}
		}
		translate([VSlotWheelSpacing20x40_Z/2, 0, 0]) {
			difference() 
			{
				ZPlateSpacerFrame(w1, leftSide=0, h=ZSpacerSocle, xaxis=2, wheel=0);
				translate([-15, 0, -1]) trunck();
			}
		}
	}

	difference() 
	{
		
		frameXAxisPlate(withNemaMotor=false);
		// Top X/Z axis mounting 

		translate([plate_width(type)/2,y1,0]) {
			translate([-VSlotWheelSpacing20x40_Z/2,w1/2])  VSlotMountZPlate(width=w1-18, leftSide=1, xaxis=1);
			translate([VSlotWheelSpacing20x40_Z/2,w1/2])  VSlotMountZPlate(width=w1-18, leftSide=0, xaxis=1);
		}

		translate([plate_width(type)/2,plate_height(type)/2+10,-0.1]) {
			for(i=[1,-1]) {
				// adjustement antibacklash : +- 20°
				for(j=[-20:20]) {
					rotate([0,0,j]) translate([i*12,0,0]) {
						M5Hole(l=PlateThickness+2);
					}
				}
			}
		}
		ZAxisEndstop(0);

	} // end difference

	mountWheel(withNemaMotor=false);
	addSpacer(wheel=1, h=61);

	if (showModule)
	{
		translate([plate_width(type)/2,plate_height(type)/2+10,PlateThickness+1+exploded*20]) rotate([0,0,180]) AntiBacklash();

		translate([plate_width(type)/2,y1,ZSpacerSocle]) {
			translate([-VSlotWheelSpacing20x40_Z/2, 0, 0]) 
				ZPlateSpacerLeft(wheel=1);
			translate([VSlotWheelSpacing20x40_Z/2, 0, 0]) 
				ZPlateSpacerRight(wheel=1);
		}
		ZAxisEndstop(1);
	}
	
}

