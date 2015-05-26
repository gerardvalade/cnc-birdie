// Birdie CNC - Project - a OpenSCAD 
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
include <scad/vslot.scad>
include <scad/vitamins/stepper-motors.scad>

plate_color = [0.6, 0.4, 0];

showExtra=1;
showModule=1;
cutView=0;
exploded=0;
addBrims=0;
$t=0.0;


module CNC() 
{
  	//$t=;
	$fn=30;

	spacer=3.2;

	module bottom(length=500)
	{
		color(plate_color) translate([-230,0,20]) cube([460,length, 20]);
		for(i=[-1, 1]) {
			// Y axis rail
			translate([i*(235+spacer), 0, 40]) rotate([0, 90, 90]) {
				vslot20x40(length, vslot_color);
				// front
				translate([20,0,0])  rotate([0,180,90]) mirror([i+1,0,0]) JoiningPlate(front=true,right=(i==-1));
				// back 
				translate([20,0,500])  rotate([0,0,90]) mirror([i-1,0,0]) JoiningPlate(front=false,right=(i==-1)); 
			}
			
			// Bottom rail	
			translate([-250, length/2+ length/2*i-i*10, 0]) rotate([90, 90, 90]) vslot20x40(500, vslot_color);
		}

		translate([0,length-80-$t*(length-160), 70-VSlotWheelMount_refY]) YAxis();
	}
	
	module YAxis()
	{
		translate([0,0,0]) {
			translate([-250-spacer,plate_width(TypeYAxisLeft)/2,0]) rotate([90,0,-90]) PlateYAxisLeft();
			translate([250+spacer,-plate_width(TypeYAxisRight)/2,0]) rotate([90,0,90]) PlateYAxisRight();
		}

		//translate([0, 32.4+plate_extra_width(TypeYAxisLeft), plate_height(TypeYAxisLeft) - 20]) XAxis();
		translate([0, plate_width(TypeYAxisLeft)/2+plate_extra_width(TypeYAxisLeft)-27.5, plate_height(TypeYAxisLeft) - 20]) XAxis();
		//translate([0, plate_width(TypeYAxisLeft)/2+plate_extra_width(TypeYAxisLeft), plate_height(TypeYAxisLeft) - 20]) XAxis();
	}
	
	module XAxis()
	{
		for(i=[-1,1]) {
			// X axis rail
			translate([-250, i*15, VSlotWheelMount_refY-70]) rotate([90, 90, 90]) {
				vslot20x40(500, vslot_color);
				translate([i,0,-0]) rotate([0,180,90]) 	XAxisSpacer();
				translate([i,0,500]) rotate([0,0,90]) XAxisSpacer();
				for(j=[-10,10]) {
						translate([j,0,-8-spacer]) rotate([180,0,0])  drawScrew("M5x20");
						translate([j,0,508+spacer]) rotate([0,0,0])  drawScrew("M5x20");
				}
				if (i == 1 && showModule) {
					translate([20,0,-8-spacer])  rotate([0,180,90]) BeltHolder3();
					translate([20,0,518+spacer])  rotate([0,0,90]) BeltTensioner();
					//translate([-15,12.5,-10])  rotate([-90,180,0]) XAxisEndstopHolder();
				} 
			}
		}
	
		translate([-186+$t*360+4,-0,-41]) {
			assign(w=30) {
				translate([plate_width(TypeXAxisBack)/2,w,0]) rotate([90,0,180]) PlateXAxisBack();
				translate([-plate_width(TypeXAxisFront)/2,-w,0]) rotate([90,0,0]) ZAxisMountView(t=1);
			}
		}
	}


	translate([0,0,0]) bottom(500);
	
}


//BeltHolder();
translate([0,-250,0]) CNC();
