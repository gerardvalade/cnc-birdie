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


TypeYAxisLeft 	= [1, "Plate YAxisLeft",  120, 180];
TypeYAxisRight 	= [2, "Plate YAxisRight", 120, 180];
TypeXAxisBack 	= [3, "Plate XAxisBack",  120, 142];
TypeXAxisFront 	= [4, "Plate XAxisFront", 120, 130];
TypeBottom 		= [5, "Bottom", 0, 0]; 
SpacerLeft 		= [6, "SpacerLeft"];
SpacerRight 	= [7, "SpacerRight"];

function plate_type(type) = type[0];
function plate_desc(type) = type[1];
function plate_width(type) = type[2];
function plate_height(type) = type[3];

//Modules types
function ModuleTypeYAxisLeft(type) = type[0]==1;
function ModuleTypeYAxisRight(type) = type[0]==2;
function ModuleTypeXAxisBack(type) = type[0]==3;
function ModuleTypeXAxisFront(type) = type[0]==4;
function ModuleBottom(type) = type[0]==5;
function ModuleSpacerLeft(type) = type[0]==6;
function ModuleSpacerRight(type) = type[0]==7;
function ModuleTypeYAxis(type) = type[0]==1 || type[0]==2;
function ModuleTypeXAxis(type) = type[0]==3 || type[0]==4;


// Main plate thickness
PlateThickness=8;
// Z Spacer thickness
ZSpacerThickness=16;
ZSpacerSocle=13;


// VSlot spacing adjust mount thickness
VSlotSpacingAdjustThickness=12;

// Spacing of wheels for 20x40 V slot rail
// Not tested, must be adjust for 3D print
// 59.55~59.70
//VSlotWheelSpacing20x40_Y=59.60; 
VSlotWheelSpacing20x40_X=59.70; 
VSlotWheelSpacing20x40_Y=59.10; 
VSlotWheelSpacing20x40_Z=59.10; 


Hole_Plate=PlateThickness+4;
color_module_plateX       		= "LawnGreen";//[0.87, 0.27, 0.3];
color_module_plateY       		= "ForestGreen";//[0.87, 0.27, 0.3];
color_module_plate2 			= "SpringGreen";//[0.97, 0.17, 0.3];
color_module_spacer 			= "DeepSkyBlue";//[0.07, 0.87, 0.93];
color_module_anitbacklash 		= "Lime";// [0.07, 0.87, 0.03];
color_module_anitbacklash_cover = "OliveDrab"; //[0.77, 0.87, 0.03];
color_module_nema_holder 		= "Aquamarine"; //[0.9,0.4,0.2];
color_cut_view 					= "red";
color_extractor					= "yellow";
color_brim 						= "pink";
module color_nema_holder() {color("black");}

VSlotSpacingAdjustPartType = 1;
//VSlotWheelMount_refY=70.60;
VSlotWheelMount_refY=69.00;
showExtra=0;
showModule=0;
addBrims=1;

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
		
		module YaxisExtractor(pty)
		{
			for (i = [-1, 1]) for (y = pty) 
			{
				wp = i*large;
				hp = long;
				render() translate([plate_width(type)/2+wp+i*50.05,y,-0.02]) 
						rotate([0,0,0]) linear_extrude(height = h, center = false, convexity = 0, twist = 0)
						polygon(points=[[0,0],[wp,0],[wp,hp],[0,hp]]);
			}						
		}
		module XaxisExtractor(cte, ptx)
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
			if (ModuleTypeXAxis(type)) YaxisExtractor([5, 29, 110]);
			if (ModuleTypeYAxis(type)) YaxisExtractor([5, 29, 100, 160]);
			
			XaxisExtractor([0], [-25, 25]);
			
			if (ModuleTypeXAxis(type)) XaxisExtractor([1], [-21, 21]);
			if (ModuleTypeYAxis(type)) XaxisExtractor([1], [-45, 2]);
		}
	}

	module drawBrims(brimHeight=0.2)
	{
		color(color_brim) {
			if (ModuleTypeYAxis(type)) {
				assign(wp=55,hp=55, ww=10) {
				translate([plate_width(type)/2-wp+(wp+9),plate_height(type)-hp-5,0]) 
						rotate([0,0,0]) linear_extrude(height = brimHeight, center = false, convexity = 0, twist = 0) {
						//polygon(points=[[wp-ww,-ww],[wp,-ww],[wp,0],[wp,ww],[0,hp+ww],[-ww,hp+ww],[-ww,hp],[0,hp],[wp-ww,ww]]);
						polygon(points=[[wp-ww,-ww],[wp,-ww],[wp,ww+2],[7,hp+5],[-5,hp+5],[wp-ww,ww]]);
					}
				}
				assign(wp=-15,hp=15, ww=10) {
				translate([plate_width(type)/2+wp-34,plate_height(type)-hp-5,0]) 
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
					translate([plate_width(type)/2+wp+i*5,plate_height(type)-hp-1,0]) 
							rotate([0,0,0]) linear_extrude(height = brimHeight, center = false, convexity = 0, twist = 0)
							polygon(points=[[wp-i*ww,-ww],[wp,-ww],[wp,0],[wp,ww],[0,hp+ww],[-i*ww,hp+ww],[-i*ww,hp],[0,hp],[wp-i*ww,ww]]);
					}
				}
				assign(wp=i*9,hp=40) {
					translate([plate_width(type)/2+wp+i*49,-0,0]) 
						rotate([0,0,0]) linear_extrude(height = brimHeight, center = false, convexity = 0, twist = 0)
						polygon(points=[[0,0],[wp,0],[wp,hp],[0,hp]]);
				}
			}
		}
	}
	

	module frameYAxisPlate()
	{
		module XAxisEndstop(endstop)
		{
			if (endstop==1 && showModule) {
				translate([2,plate_height(type)-65,3+exploded*15]) rotate([-90,0,90]) endstop();
				translate([10,plate_height(type)-27,PlateThickness+exploded*25]) rotate([90,0,0])  XAxisEndstopHolder();
	
			} else if (endstop==0) {
				translate([0,plate_height(type)-48,-0.5])   
				{
					XAxisEndstopHole(h=PlateThickness+2);
				}
			}
		}
	
		
		if (addBrims) {
			drawBrims();
		}
		difference() 
		{
			color(color_module_plateY)  union() {
			
				if(VSlotSpacingAdjustPartType==1)
				{
					VSlotSpacingAdjustPart();
				}

				difference() 
				{
	   				cube([plate_width(type),plate_height(type),PlateThickness]);

					translate([plate_width(type)/2+10,plate_height(type)-50,-1]) 
						assign(wp=50.1,hp=50.1) {
								rotate([0,0,0]) linear_extrude(height = PlateThickness+2, center = false, convexity = 0, twist = 0)
								polygon(points=[[wp,0],[wp,hp],[0,hp]]);
						}

					translate([plate_width(type)/2+20,plate_height(type)-50,-1]) 
						assign(wp=25.1,hp=25.1,hh=12) {
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
							translate([-15, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
							translate([15, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
						}
					
				}
			} // end union

			translate([plate_width(type)/2,VSlotWheelMount_refY]) 
				VSlotWheelAndNemaMotor(width=plate_width(type)-15, withNemaMotor=true);
			
		
			ToolMounting(plate_width(type));
			
			translate([0,0,0]) XAxisEndstop(0);
		
			drawExtractor();
		
			// Plate Spring part
			if(VSlotSpacingAdjustPartType==1||VSlotSpacingAdjustPartType==3)
			{
				VSlotSpacingAdjustPartHole();
			}
		
			
		
			XAxisMountOnY(40, plate_height(type)-11, 45);
	
		} // end difference
		
		
//		#translate([posX+i*(posX-15),posY+11,posZ+6])
//		rotate([0,90,(i+1)*90]) { 
//			drawBolt("M3x16", 14);
//		}
			
		
		
		mountWheel(withNemaMotor=true);
		
		if (ModuleTypeYAxisLeft(type))
			translate([0,0,0]) XAxisEndstop(1);
		
		if(VSlotSpacingAdjustPartType==1)
		{
			VSlotSpacingAdjustPart2();
		}
	}
	

	

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
								translate([-15, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
								translate([15, 0, 0]) cylinder(r=8,h=PlateThickness+1, center=false);
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
				VSlotSpacingAdjustPartHole();
			}
	
		} // end difference
		
		VSlotSpacingAdjustPartScrew();
		
		if(VSlotSpacingAdjustPartType==1)
		{
			VSlotSpacingAdjustPart2();
		}

	}

	module frameXAxisBackPlate()
	{
		frameXAxisPlate(withNemaMotor=true);

		mountWheel(withNemaMotor=true);
		//addSpacer(wheel=1, h=0);

	}


	module mountWheel(withNemaMotor)
	{
		translate([plate_width(type)/2,VSlotWheelMount_refY]) 
			VSlotWheelAndNemaMotor(width=plate_width(type)-15, withNemaMotor=withNemaMotor, wheel=1, h=PlateThickness);

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
					//translate([23.7,0,-exploded*20]) rotate([0,180,0]) endstop();
					translate([5,0,-exploded*20]) rotate([0,180,0]) endstop();
					//translate([42.5,-0,-exploded*20]) rotate([0,180,0]) endstop();
				} 
				for (i = [28,  9.5, -9.5, -28]) 
				{
					//if (endstop) translate([i,-0,-2-exploded*15]) rotate([0,180,0]) drawBolt("M2.5x16");
					if (endstop==0) {
						translate([i,0,-1]) rotate([0,0,0]) M2_5Thread();
						//translate([i,-2,0]) rotate([0,0,0]) ToolMountingOne(w=5, hole="M2.5");
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
				
				assign(ww=20) {
					if (!wheel) {
						hull()
						{
							translate([i*ww,0,-0.02]) 
								BeltBearingHole(h=Hole_Plate, wheel=0);
							translate([i*ww,21,-0.02]) 
								BeltBearingHole(h=Hole_Plate, wheel=0);
						}
					} else {
						translate([i*ww,21,-0.02]) 
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
			translate([width/2+i*(width/2-MountingTool_x),MountingTool_y+40, 0])  ToolMountingOne(w=10);
		}
	}
	
	
	module XAxisMountOnY(posX, posY,TopAxisMount_w)
	{
		for (i = [-1, 0]) 
		{
			translate([posX,posY+i*20,PlateThickness/2]) rotate([0,0,90]) drawHul("M5", l=Hole_Plate, gap=TopAxisMount_w);
		}
	}
	
	module VSlotSpacingAdjustPart(posY=19, posX=plate_width(type)/2, posXScrew=5, posZ=VSlotSpacingAdjustThickness-5)
	{
		module bump(i, posX, thick)
		{
			translate([posX-6+i*(posX-6),23,0]) cube([12,13,thick]);
		}
		for (i = [-1, 1]) 
		{
			translate([posX-11+i*(posX-11),0]) cube([22,posY,VSlotSpacingAdjustThickness]);
			if (ModuleTypeXAxisFront(type))
				bump(i, posX, VSlotSpacingAdjustThickness);
			else
				bump(i, posX, VSlotSpacingAdjustThickness+6);

			translate([posX-7.49+i*(posX-7.52),VSlotWheelMount_refY-7.5,0]) cube([15,15,VSlotSpacingAdjustThickness]);

		}
	}

	module VSlotSpacingAdjustPartScrew(posY=19, posX=plate_width(type)/2, posXScrew=5, posZ=VSlotSpacingAdjustThickness-5)
	{
		if (showExtra && ModuleTypeXAxisBack(type)) {
			for (i = [-1, 1]) 
			{
				translate([posX+i*(posX-15),posY+11,posZ+6])
				rotate([0,90,(i+1)*90]) 
					drawBolt("M3x16", 14);
			}
		}
	}

	module VSlotSpacingAdjustPartHole(posX=plate_width(type)/2, 
			posY=21, 
			posXScrew=6, 
			posZ=VSlotSpacingAdjustThickness-6)
	{
		for (i = [-1, 1]) 
		{
			translate([posX+i*(posX-15)-0,posY,VSlotSpacingAdjustThickness/2]) 
	   			cube([35,4,VSlotSpacingAdjustThickness+2], center=true);
			translate([posX+i*(posX-30),posY,-1])  
				cylinder(d=8,h=PlateThickness+4);
			
			if (!ModuleTypeXAxisFront(type)) {
				if (VSlotSpacingAdjustPartType==3) {
					translate([posX+i*(posX-20),posY+9,0])
						rotate([0,0,(i+1)*90]) { 
							M3Hole(l=12);
						}
					translate([posX+i*(posX-5),posY+9,0])
						rotate([0,0,(i+1)*90]) { 
							M3Hole(l=12);
						}
				}
				if (VSlotSpacingAdjustPartType==1) {
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
	
module BeltHolder(h=40.5)
{

	tensionL=25;
	tensionW=16;
	tensionH=4.5;

	translate([0, 0, tensionH])  rotate([0,180,0]) { 
	 difference() {
		translate([-25/2,0,0])	cube([25,75,tensionH]);
		for(i=[10, 30]) { 
			translate([0,i,-20.2]) M5Hole(l=41);
		}
		for(i=[35,45,55,64]) { 
			translate([-8/2,i,-0.1]) cube([8,3,h+1]);
		}
	}
	if (showExtra) {
		for(i=[10, 30]) { 
			translate([0,i, 0])  rotate([0,180,0]) drawScrew("M5x16");
		}
	}
	}
}

module BeltTensioner(h=40.5)
{
	tensionL=25;
	tensionW=16;
	tensionH=4.5;

	tensionY=51.5;

	translate([0, 0, tensionH])  rotate([0,180,0]) {
		 difference() {
			union() {
				translate([-tensionL/2,0,0]) cube([tensionL,75,tensionH]);
				translate([-tensionL/2,tensionY-tensionW/2,-3.9]) cube([tensionL,tensionW,3.9]); //cylinder(d=16, h=5);
			}
			for(i=[10, 30]) { 
				translate([0,i,-20.2]) M5Hole(l=41);
			}
			translate([0,tensionY,0])  {
				translate([0,0,-20.2]) M5Hole(l=41);
				translate([0,0,-4]) M5RHexa(l=4);
			}
			for(i=[35,41,59.5,66]) { 
				ww=2.5;
				translate([-8/2,i,-0.1]) cube([8,ww,tensionH+1]);
			}
		}
		if (showExtra) {
			for(i=[10, 30]) { 
				translate([0,i, 0]) 
					rotate([0,180,0]) drawScrew("M5x25");
				translate([0,i,tensionH+5]) rotate([0,0,0])  precisionShim10x5x10();
			}
			translate([0, tensionY, 10]) rotate([0,0,0]) drawBolt("M5x16", posNut=10.4);
			translate([0, tensionY, -7-exploded*20]) rotate([180,0,0])  Tensioner();
		}
	}
}

module Tensioner()
{
	tensionL=25;
	tensionW=16;
	tensionH=3;
 
	translate([0,0,tensionH/2]) {
		difference() {
			union() {
				cube([tensionL,tensionW,tensionH], center=true);
				translate([0,0,tensionH/2]) {
					difference() {
					 	rotate([0,90,0]) cylinder(d=tensionW,h=tensionL,center=true);
						translate([0,0,-5]) cube([tensionL+1,tensionW+1,10], center=true);
					}
				}
			}
			translate([0,0,tensionH/2+1.5]) cube([8,30,3.6], center=true);
			#translate([0,0,-9.8]) rotate([0,0,0]) M5Hole();
		}
	}
}



module JoiningPlate(front, right, h=4.5)
{
	module Endstop(endstop)
	{
		if (endstop==1 && showModule) {
			translate([0,0,0]) rotate([-90,0,90]) endstop();
			translate([8.5,40,3]) rotate([90,0,0])  YAxisEndstopHolder();

		} else if (endstop==0) {
			translate([0,plate_height(type)-48,-0.5])   
			{
				YAxisEndstopHole(h=PlateThickness+2);
			}
		}
	}


	translate([0,0,0])	render() difference() 
	{

		translate([-25/2,-40,0]) assign(wp=25,hp=115) {
			rotate([0,0,0]) linear_extrude(height = h, center = false, convexity = 0, twist = 0)
			//polygon(points=[[0,0],[wp+30,0],[wp+30,40],[wp,70],[wp,hp],[0,hp]]);
			polygon(points=[[-8,0],[wp+30,0],[wp+30,40],[wp,80],[0,80],[0,60],[-8,60]]);
		}

		for(i=[10, 30]) { 
			translate([0,i,-20.2]) M5Hole(l=41);
			for(j=[0,30]) { 
				translate([j,-i,-20.2]) M5Hole(l=41);
			}
		}
		for(i=[35,45,55,64]) { 
			translate([-8/2,i,-0.1])	cube([8,3,h+1]);
		}
		translate([-24.5, -4, 0]) Endstop(0);
	}
	if (showExtra) {
		if (front) {
			if(right) translate([-23, -23, 0]) Endstop(1);
			for(i=[10, 30]) { 
				//translate([0,i, h]) drawScrew("M5x20");
				for(j=[0,30]) { 
					translate([j,-i,h]) drawScrew("M5x10");
				}
			}
			translate([0, 0, 9])  rotate([0,0,0])  BeltHolder();
		}
		if(!front) {
			if(!right)	translate([-23, -23, 0]) Endstop(1);
			translate([0, 0, 14])  rotate([0,0,0])  BeltTensioner();
		}
	}
}


module PlateYAxisLeft()
{
	_plate(TypeYAxisLeft);
}

module PlateYAxisRight()
{
	_plate(TypeYAxisRight);
}

module PlateXAxisBack()
{
	_plate(TypeXAxisBack);
}

module PlateXAxisFront()
{
	_plate(TypeXAxisFront);
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
	translate([60,180-t*48,42+exploded*50]) {
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
	
	