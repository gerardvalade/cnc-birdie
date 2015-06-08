// Birdie CNC - Plate axis - a OpenSCAD 
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

include <PlateUtils.scad>
include <endstop.scad>
include <cable_chain.scad>
include <belt_holder.scad>
include <plate_axis_def.scad>

module _plate(type) // plate_type(type), plate_width(type), plate_height(type)) 
{
	bom("plate", str(plate_desc(type), " (",plate_width(type), "mm x ",plate_height(type), "mm)"), ["3D printed", "hardware"]);

	module bottomPlate(height,type=TypeYAxisLeft)
	{
		assign(w1=plate_width(type)/3-10,w2=plate_width(type)/3+40) {
			//color(color_module_plate) 
			difference() 
			{
				union() {
						cube([w1,height,PlateThickness]);

						translate([plate_width(type)/2-w2/2,0,PlateThickness]) 
						cube([w2,height,PlateThickness]);

						translate([plate_width(type)-w1,0,0]) 
						cube([w1,height,PlateThickness]);
				}
				translate([plate_width(type)/2,height/2]) 
				VSlotMountBottomPlate(width=plate_width(type)-15);
			}
			translate([plate_width(type)/2,height/2]) 
			VSlotMountBottomPlate(width=plate_width(type)-15, option=0, wheel=1);
		}
		translate([plate_width(type)/2,height/2]) 
			VSlotMountBottomPlate(width=plate_width(type)-15, option=0, wheel=1);
	}
	
	module VSlotMountBottomPlate(width=0, option=1, wheel=false)
	{
		module bottomWheel(h=PlateThickness, wheel)
		{
			if (!wheel) translate([0,0,-1])	M5Hole(l=h+4);
			else if(showExtra) {
				translate([0,0,0]) rotate([0, 180, 0]) {
					wheel10(h=h);
				}
			}
		}

		
		
		if (option==1 && !wheel) {
			translate([0,-2,PlateThickness+4]) drawHul("M5", l=Hole_Plate, gap=8);
		}
		for (i = [-1,1]) 
		{
			translate([i*(width/2),0,-0.02]) bottomWheel(h=Hole_Plate, wheel=wheel);
		}	
	}

	module drawExtractor(large=5, long=8, h=0.6)
	{
		
		module leftRightExtractor(pts)
		{
			for (i = [1,-1]) for (pt = pts) for (y = pt[1])
			{
				x = pt[0];
				wp = i*large;
				hp = long;
				render() translate([plate_width(type)/2-wp+i*x,y,-0.02]) 
						rotate([0,0,0]) linear_extrude(height = h, center = false, convexity = 0, twist = 0)
						polygon(points=[[0,0],[wp,0],[wp,hp],[0,hp]]);
						
			}						
		}
		module topBottomExtractor(cte, ptx)
		{
			for (i = cte) for (x = ptx) 
			{
				wp = long;
				hp = large;
				render() translate([plate_width(type)/2-wp/2+x,(plate_height(type)-(hp-0.1))*i-0.05,-0.02])  
						rotate([0,0,0]) linear_extrude(height = h, center = false, convexity = 0, twist = 0)
						polygon(points=[[0,0],[wp,0],[wp,hp],[0,hp]]);
			}						
		}
		
		
		color(color_extractor) {
			ptx = plate_width(type)/2;
			if (ModuleTypeXAxis(type)) {
				leftRightExtractor([[ptx,[5, 29, 110]]]);
				topBottomExtractor([1], [-21, 21]);
			}
			if (ModuleTypeYAxis(type)) {
				leftRightExtractor([[ptx,[5,29,110]],[ptx+plate_extra_width(),[155]]]);
				topBottomExtractor([1], [-45, 2]);
			}
			
			topBottomExtractor([0], [-25, 25]);
			
		}
	}

	module drawBrims(brimHeight=0.2)
	{
		color(color_brim) {
			if (ModuleTypeYAxis(type)) {
				assign(wp=60,hp=60, ww=10, sqr=1.414) {
				translate([plate_width(type)/2+(plate_width(type)/2-51),plate_height(type)-hp,0]) 
				//translate([plate_width(type)/2-wp+(wp+9),plate_height(type)-hp-5,0]) 
						rotate([0,0,0]) linear_extrude(height = brimHeight, center = false, convexity = 0, twist = 0) {
						//polygon(points=[[wp-ww,-ww],[wp,-ww],[wp,0],[wp,ww],[0,hp+ww],[-ww,hp+ww],[-ww,hp],[0,hp],[wp-ww,ww]]);
						//polygon(points=[[wp-ww+0,-ww],[wp,-ww],[wp,ww*1.414],[ww*1.414,hp+5],[1,hp+5],[wp-ww+0,ww]]);
						polygon(points=[[wp-ww+0,-15],[wp,-15],[wp,ww*sqr],[ww*sqr,hp],[1,hp],[wp-ww+0,ww]]);
					}
				}
				assign(wp=-15,hp=22, ww=8) {
				translate([plate_width(type)/2-plate_extra_width()-(plate_width(type)/2)+7.2,plate_height(type)-hp-5,0]) 
				//translate([plate_width(type)/2-plate_extra_width()+wp-38,plate_height(type)-hp-5,0]) 
						rotate([0,0,0]) linear_extrude(height = brimHeight, center = false, convexity = 0, twist = 0) {
						//polygon(points=[[wp+ww,0],[wp,0],[wp,hp+ww],[ww,hp+ww],[ww,hp],[wp+ww,hp]]);
						polygon(points=[[wp+ww,0],[wp,0],[wp,hp+5],[wp+ww,hp+5]]);
					}
				}
			}
			for (i = [-1,1]) 
			{
				if (ModuleTypeXAxis(type)) {
					assign(wp=i*30,hp=30, ww=10) {
					translate([plate_width(type)/2+i*(plate_width(type)/2-25),plate_height(type)-hp-1,0]) 
					//translate([plate_width(type)/2+wp+i*5,plate_height(type)-hp-1,0]) 
							rotate([0,0,0]) linear_extrude(height = brimHeight, center = false, convexity = 0, twist = 0)
							polygon(points=[[wp-i*ww+i*4,-ww],[wp+i*2,-ww],[wp+i*2,ww],[0,hp+ww],[-i*ww,hp+ww],[-i*ww,hp],[0,hp],[wp-i*ww+i*3,ww]]);
					}
				}
				
				assign(wp=i*8,hp=42) {
					//translate([plate_width(type)/2+wp+i*51.8,-0,0]) 
					translate([plate_width(type)/2+i*(plate_width(type)/2-0.1),-0,0]) 
						rotate([0,0,0]) linear_extrude(height = brimHeight, center = false, convexity = 0, twist = 0)
						polygon(points=[[0,0],[wp,0],[wp,hp],[0,hp]]);
				}
			}
		}
	}
	


	


	module mountWheel(withNemaMotor)
	{
		translate([plate_width(type)/2,VSlotWheelMount_refY]) 
			VSlotWheelAndNemaMotor(width=plate_width(type)-15, withNemaMotor=withNemaMotor, wheel=1, h=PlateThickness);

	}

	
	module VSlotWheelAndNemaMotor(width=0, withNemaMotor=false, wheel=0, h=PlateThickness)
	{
		module VSlotMountType2(width, n=2, wheel=0, h)
		{
			/* V Slot Hole Mounting */
			for(j = [0 : n]) 
				translate([-width/2+j*(width/n),0,-0.02]) 
					VWheelHole(h=Hole_Plate+10, wheel=wheel, h=h);
		}
		
		module drawWheelHolder(wheelSpacing)
		{
			for (i = [-1,1]) 
			{	
				translate([i*(width/2),0,0]) {
					translate([0,0,-0.02]) VWheelHole(h=Hole_Plate, wheel=wheel, h=h);
					if(wheel==0) {
						if (cutView) color(color_cut_view)  {
							// Cut view wheel hole
							translate([i*10,-0,5])
			   					cube([20,20,PlateThickness+10], center=true);
							// Cut view adjust wheel
							translate([i*12,-40,8])
			   					cube([20,65,PlateThickness+15], center=true);
							translate([i*5,-70,8])
			   					cube([20,20,PlateThickness+15], center=true);
						}
					}
				}
				translate([i*(width/2-6),-wheelSpacing,0]) {
					translate([0,0,-0.02]) VWheelHole(h=Hole_Plate, wheel=wheel, h=h);
				}
			}
		}
		
		if (VSlotSpacingAdjustPartType==2 && !wheel) {
			translate([0,-VSlotWheelSpacing20x40_Y,-0.02]) 
				translate([0,0,-1])	M5Hole(l=h+4);
		} 
		/* V Slot Hole Mounting */
		if(VSlotSpacingAdjustPartType == 2)
		{
			VSlotMountType2(width, 1, wheel=wheel, h=h);	
		}
		else 
		{
			if (ModuleTypeXAxis(type)) drawWheelHolder(VSlotWheelSpacing20x40_X);
			if (ModuleTypeYAxis(type)) drawWheelHolder(VSlotWheelSpacing20x40_Y);
		}
		
		for (i = [-1,1]) 
		{
			if (withNemaMotor)
			{
				
				assign(ww=20, top=22) {
					if (!wheel) {
						hull()
						{
							translate([i*ww,0,-0.02]) 
								BeltBearingHole(h=Hole_Plate, wheel=0);
							translate([i*ww,top,-0.02]) 
								BeltBearingHole(h=Hole_Plate, wheel=0);
						}
					} else {
						translate([i*ww,top,-0.02]) 
							BeltBearingHole(h=Hole_Plate, wheel=wheel);
					}
				}

				if (i==1 && (wheel == 0 || showExtra))
				{
					// Cut view Nema screw holder
					if (!wheel && cutView && ModuleTypeXAxisBack(type)) 
						color(color_cut_view) translate([0,plate_height(type)/2+28,5]) cube([40,10,PlateThickness+10], center=true);
					
					if (ModuleTypeXAxisBack(type))
					{
						translate([0,NEMA23HolesSpacing/2+19,PlateThickness+1]) 
								rotate([0,180,0]) NemaHolder(depth=Hole_Plate, showMotor=wheel, rot=45);
						
					} 
					else 
					{
						translate([0,NEMA23HolesSpacing/2+19,PlateThickness]) 
								rotate([0,180,0]) NemaHolder(depth=Hole_Plate, showMotor=wheel, rot=45);
					
					}
				}
			}
		}	
	}
	
	module ToolMountingOne(w=10, hole="M3")
	{
		/* Monting tool */
		translate([0, 0, PlateThickness-3]) drawHul(hole, l=PlateThickness+3, gap=w);
	
	}

	module ToolMounting(width=0, MountingTool_x=8, MountingTool_y=52)
	{
		for (i = [-1, 1]) 
		{
			/* Monting tool */
			translate([width/2+i*(width/2-MountingTool_x),MountingTool_y, 0])  ToolMountingOne(w=10);
			if (ModuleTypeXAxis(type)) {
				translate([width/2+i*(width/2-MountingTool_x),MountingTool_y+40, 0])  ToolMountingOne(w=10);
			}
			if (ModuleTypeYAxis(type)) {
				translate([width/2+i*(width/2-MountingTool_x),MountingTool_y+40, 0])  ToolMountingOne(w=10);
				translate([width/2+i*(width/2-MountingTool_x),MountingTool_y+62, 0])  ToolMountingOne(w=10);
			}
		}
	}
	
	

	module VSlotSpacingAdjustPart(partType=0)
	{
		posX=plate_width(type)/2;
		posY=21;
		posXScrew=6;
		posZ=VSlotSpacingAdjustThickness-6;
		modelType=2;

		module bump(i, posX, thick)
		{
			translate([posX-6+i*(posX-6),23,0]) cube([12,13,thick]);
		}

		module screw()
		{
			if (modelType==1 && showExtra && ModuleTypeXAxisBack(type)) {
				for (i = [-1, 1]) 
				{
					translate([posX+i*(posX-18),posY+9,posZ+7])
					rotate([0,90,(i+1)*90]) 
						drawBolt("M3x16", 16);
				}
			}
		}

		module hole() 
		{
			for (i = [-1, 1]) 
			{
				translate([posX+i*(posX-15)-0,posY,VSlotSpacingAdjustThickness/2]) 
		   			cube([35,4,VSlotSpacingAdjustThickness+2], center=true);
				translate([posX+i*(posX-33),posY,-1])  
					cylinder(d=10,h=PlateThickness+4);
				
				if (!ModuleTypeXAxisFront(type)) {
					if (VSlotSpacingAdjustPartType==3) {
						#translate([posX+i*(posX-20),posY+9,0])
							rotate([0,0,(i+1)*90]) { 
								M3Hole(l=12);
							}
						#translate([posX+i*(posX-5),posY+9,0])
							rotate([0,0,(i+1)*90]) { 
								M3Hole(l=12);
							}
					}
					if (modelType==1&&VSlotSpacingAdjustPartType==1) {
						// endstop screw hole 
						translate([posX+i*(posX+1),posY+9,VSlotSpacingAdjustThickness+1])
							rotate([0,90,(i+1)*90]) { 
								M3Hole(l=15);
								translate([0,0,0.9]) M3Hexa(l=4);
							}
					}
				}
				if (VSlotSpacingAdjustPartType==1&&posXScrew>0) {
					// Adjust hole screw
					translate([posX+i*(posX-posXScrew),-0.02,posZ])
					{
						rotate([90,90,0]) {
							translate([0,0,-42]) M3Hexa(l=12);
							drawM3HoleThrought(l=25, h=14);
						}
						
					}
				}
			}
		}

		module main() {
			for (i = [-1, 1]) 
			{
				translate([posX-11+i*(posX-11),0]) cube([22,posY,VSlotSpacingAdjustThickness]);
				if (ModuleTypeXAxisFront(type) || modelType!=1)
					bump(i, posX, VSlotSpacingAdjustThickness);
				else
					bump(i, posX, VSlotSpacingAdjustThickness+6);
	
				translate([posX-7.49+i*(posX-7.52),VSlotWheelMount_refY-7.5,0]) cube([15,15,VSlotSpacingAdjustThickness]);
			}
		}

		if (partType==0) main();
		if (partType==1) hole();
		if (partType==2) screw();
	}

	module VSlotSpacingAdjustPart2(posY=19, posX=plate_width(type)/2, posXScrew=6, posZ=VSlotSpacingAdjustThickness-6)
	{
		if (showExtra)
			for (i = [-1, 1]) 
			{
				
				translate([posX+i*(posX-posXScrew),-0.02,posZ])
				{
					rotate([90,90,0]) {
						
						translate([0,0,-14])  {
							drawBolt("M3x20", 16);
						}
					}
				}
				
			}
		
	}

	module BeltBearingHole(h=0, wheel=0)
	{
		if (!wheel) 
			M5Hole(h);
		if(wheel && showExtra)
			rotate([0, 180, 0]) beltBearing10(h=h);
	}


	module VWheelHole(h=PlateThickness, wheel)
	{
		if (!wheel) {
			translate([0,0,-1])	M5Hole(l=h+4);
			if (ModuleTypeYAxis(type)) translate([0,0,PlateThickness+0]) M5RHexa(l=PlateThickness+0);
			if (ModuleTypeXAxisBack(type)) translate([0,0,PlateThickness-1]) M5RHexa(l=PlateThickness+0);
			if (ModuleTypeXAxisFront(type)) translate([0,0,VSlotSpacingAdjustThickness+0.04]) drawM5HoleThrought(l=VSlotSpacingAdjustThickness,h=(VSlotSpacingAdjustThickness-PlateThickness)+1.04);
		} 
		if(wheel && showExtra) { // GVA
			translate([0,0,0]) rotate([0, 180, 0]) {
				if (ModuleTypeXAxisFront(type)) doubleWheel10();
				if (ModuleTypeYAxis(type)) wheel10();
			}
		}
	}
	
include <plate_xaxis.scad>
include <plate_yaxis.scad>
include <plate_zaxis.scad>

	if (ModuleTypeYAxisRight(type))
	{
		translate([plate_width(type),0,0]) 
			mirror([1,0,0]) 
			frameYAxisPlate();
	}
	else if (ModuleTypeYAxisLeft(type))
	{
		frameYAxisPlate();
	}
	else if (ModuleTypeXAxisFront(type))
	{
		frameXAxisFrontPlate();
	}
	else if (ModuleTypeXAxisBack(type))
	{
		frameXAxisBackPlate();
	}
	else if (ModuleSpacerLeft(type))
	{
		ZPlateSpacerLeft(wheel=showExtra);
	}
	else if (ModuleSpacerRight(type))
	{
		ZPlateSpacerRight(wheel=showExtra);
	}
	else if (ModuleBottom(type))
	{
		bottomPlate(25);
	}
	if (showModule && plate_type(type)<=4)
	{
		if (VSlotSpacingAdjustPartType==2)
		{
			bottomPlate(25);
		}
	}
}

include <anti_backslash.scad>
include <plate_zaxsis_motor_holder.scad>
include <joining_plate.scad>

module PlateXAxisBack()
{
	_plate(TypeXAxisBack);
}

module PlateXAxisFront()
{
	_plate(TypeXAxisFront);
}

module PlateYAxisLeft()
{
	_plate(TypeYAxisLeft);
}

module PlateYAxisRight()
{
	_plate(TypeYAxisRight);
}


module ModuleZSpacerLeft()
{
	_plate(SpacerLeft);
}

module ModuleZSpacerRight()
{
	_plate(SpacerRight);
}

module ModuleBottom() {
	_plate(TypeBottom);
}

module ZAxisMountView(t=0.9)
{
	translate([0,0,0])  PlateXAxisFront();
	translate([plate_width(TypeXAxisFront)/2,180-t*48,42+exploded*50]) {
		// Z axis rail
		translate([0,0,0]) rotate([90, 0, 0]) {
			vslot20x40(190, vslot_color);
			for(j=[-1,1]) {
				translate([j*10,0,-8]) rotate([180,0,0])  drawScrew("M5x20");
			}
		}
		translate([0,0,0]) rotate([0,180,0]) rotate([-90,180,0]) ZAxisPlateMotorHolder();
	}
}
	
	