// Birdie CNC - JoiningPlate - a OpenSCAD 
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

joining_plate_color			= "yellow";

module JoiningPlate(front, right, h=4.5)
{
	modelType=2;
	module Endstop(endstop)
	{
		translate([8.5,40,3]) rotate([90,0,0])  {
			if (endstop==1 && showModule) 
				YAxisEndstopHolder();
			else if (endstop==0)
				YAxisEndstopHolder(hole=true);
		}
/*
		if (endstop==1 && showModule) {
			//translate([0,0,0]) rotate([-90,0,90]) endstop();
			#translate([8.5,40,3]) rotate([90,0,0])  YAxisEndstopHolder();

		} else if (endstop==0) {
			translate([0,plate_height(type)-48,-0.5])   
			{
				#YAxisEndstopHole(h=PlateThickness+2);
				#YAxisEndstopHolder(hole=true);
			}
		}*/
	}


	color(joining_plate_color) translate([0,0,0])	render() difference() 
	{

		translate([-25/2,-40,0]) assign(wp=25,hp=115) {
			rotate([0,0,0]) linear_extrude(height = h, center = false, convexity = 0, twist = 0)
			//polygon(points=[[0,0],[wp+30,0],[wp+30,40],[wp,70],[wp,hp],[0,hp]]);
			if(modelType==1) polygon(points=[[-8,0],[wp+30,0],[wp+30,40],[wp,80],[0,80],[0,60],[-8,60]]);
			else if(modelType==2) polygon(points=[[0,0], [wp+30,0],[wp+30,40],[wp,80],[0,80]]);
		}

		for(i=[10, 30]) { 
			translate([0,i,-20.2]) M5Hole(l=41);
			for(j=[0,30]) { 
				translate([j,-i,-20.2]) M5Hole(l=41);
			}
		}
		for(i=[35]) { 
			translate([-8/2,i,-0.1])	cube([8,3,h+1]);
		}
		//translate([-24.5, -4, 0]) Endstop(0);
		if(modelType==1) translate([-23, -23, 0]) Endstop(0);
	}
	if (showExtra) {
		if (front) {
			if(right && modelType==1) translate([-23, -23, 0]) Endstop(1);
			for(i=[10, 30]) { 
				//translate([0,i, h]) drawScrew("M5x20");
				for(j=[0,30]) { 
					translate([j,-i,h]) drawScrew("M5x10");
				}
			}
			translate([0, 0, 4.6])  rotate([0,0,0])  BeltHolder(front);
		}
		if(!front) {
			if(!right && modelType==1)	translate([-23, -23, 0]) Endstop(1);
			translate([0, 0, 14])  rotate([0,0,0])  BeltTensioner();
		}
	}
}

