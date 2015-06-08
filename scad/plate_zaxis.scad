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

	module ZPlateSpacerFrame(w1, leftSide, h, xaxis=0, wheel=0)
	{	
		if (wheel==0) difference() 
		{	
			color(color_module_spacer)   translate([-10,0]) cube([20, w1, h]);
			for(i=[-1, 1]) 
			{
				translate([0,w1/2+i*(w1/2-10),h/2]) {
					color(color_module_spacer)   difference() 
					{
						translate([0,i*10]) 
							cube([30,20,h+1], center=true);
						rotate([0,0,0])
							cylinder(d=20,h=h+1,center=true);						
					}
				}
			}
			if (cutView) color(color_cut_view) {
				translate([-11,0,-1]) cube([10, w1, h+2]);
			}
			translate([0,w1/2])  VSlotMountZPlate(width=w1-18,leftSide=leftSide, xaxis=xaxis);
		}
		if (wheel) translate([0,w1/2])  VSlotMountZPlate(width=w1-18,leftSide=leftSide, xaxis=xaxis, wheel=1); 
	}

	module ZPlateSpacerRight(w1=plate_height(TypeXAxisFront)-15, h=ZSpacerThickness, x=10, xaxis=0, wheel=0)
	{	
		difference() 
		{
			union() 
			{
				ZPlateSpacerFrame(w1, leftSide=0, h=h, xaxis=xaxis, wheel=0);
				if (xaxis==0) color(color_module_spacer)  {
					for(i=[-1,1]) 
					{
						translate([x,w1/2-4+i*19]) cube([9, 8, h]);
					}
					translate([x,w1/2-3]) cube([9, 6, h]);
				}
			}
			if (cutView) color(color_cut_view) {
				translate([20,w1/2,h/2]) cube([10, w1/2, h+2], center=true);
			}
			
			if (xaxis==0) {
				for(i=[-1, 1]) 
				{
					translate([2,w1/2+i*13,-1]) {
						hull () {
							translate([0, 0]) cylinder(r=2,h=h+2);
							translate([10, 0])  cylinder(r=2,h=h+2);
						}

					}					
					mirror([0,0,0]) translate([x+5,w1/2-i*26,h/2]) 
						rotate([90,90,(i+1)*90]) translate([0,0,0])  {
							M3Hole(l=10+2);
							translate([0,0,8.5]) M3Hexa(l=5);	
						}
				}
			}
		}
		if (wheel) {
			ZPlateSpacerFrame(w1, leftSide=0, h=h, xaxis=xaxis, wheel=wheel);
			for(i=[-1, 1]) 
			{
				mirror([0,0,0]) translate([x+5,w1/2-i*28,h/2]) 
					rotate([90,90,((i-1)/2)*180]) translate([0,0,0])  
						drawBolt("M3x25", 11);
			}
		}
		
	}

	module ZPlateSpacerLeft(w1=plate_height(TypeXAxisFront)-15, h=ZSpacerThickness, xaxis=0, wheel=0)
	{	
		ZPlateSpacerFrame(w1, leftSide=1, h=h, xaxis=xaxis, wheel=0);
		if (wheel) ZPlateSpacerFrame(w1, leftSide=1, h=h, xaxis=xaxis, wheel=wheel);
	}
	
	module VSlotMountZPlate(width, leftSide, wheel=0, xaxis=0, ww=75)
	{
		
		module VWheelHoleZAxis(h=PlateThickness, wheel)
		{
			if (wheel) {
				if(showExtra) {
					translate([0,0,0]) rotate([0, 0, 0]) wheel20(h=h);
				}
			} else {
				translate([0,0,ZSpacerThickness-8])	M5Hole(l=9);
				translate([0,0,PlateThickness]) M5Hexa(l=ZSpacerThickness-8);
			}
		}

		
		for (i = [-1,1]) 
		{
			if (wheel==0) {
				if (xaxis==0) {
					translate([0,i*(width/2),0]) {
						translate([0,0,-0.02]) {
							VWheelHoleZAxis(h=ZSpacerThickness+1, wheel=wheel);
						}
					}
				} 
				
				if (leftSide==1) {
					if (xaxis==0) translate([0,i*(width/2-ww),0]) {
						translate([0,0,-0.02]) M5Hole(l=ZSpacerThickness-5.1);
						translate([0,0,ZSpacerThickness+0.02]) M5Hexa(l=5.2, wheel=wheel);
					}
					if (xaxis>0) {
						// adjustement : +- 5°
						for (j = [-5:5]) 
						{
							rotate([0,0,j]) translate([0,i*(width/2-ww),-0.02]) {
								M5Hole(l=ZSpacerSocle+1);
							}
						}
					}	
				}
			}	
			if (wheel==1) {
				if (leftSide==0) { 
					translate([0,0,-PlateThickness-5]) rotate([0,180,0]) 
						drawBoltLowProfile("M5x30", 24);
					
				}
				if (leftSide==1) {
					translate([0,i*(width/2-ww),0]) 
						translate([0,0,-13])  
							rotate([0,180,0]) 
								drawBoltLowProfile("M5x30", 24); 
					
				} 
				translate([0,i*(width/2),ZSpacerThickness]) VWheelHoleZAxis(wheel=wheel);
			}
		}	

		if (wheel==0) {
			if (xaxis==0) {
				translate([0,0,ZSpacerThickness+0.02]) M5Hexa(l=5.2, wheel=wheel);
				translate([0,0,-0.02]) M5Hole(l=ZSpacerThickness-5.1);		
			}
			if (xaxis>0) {
				translate([0,0,-0.1]){
					 M5Hole(l=ZSpacerThickness+PlateThickness+1);
				}		
			}
		}
	}

