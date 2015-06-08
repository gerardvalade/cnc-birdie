// Birdie CNC - belt holder - a OpenSCAD 
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
use <cable_chain.scad>

BeltHolder 	           = ["BH",    "Belt Holder 1", "",  "", [35,45,55,66]];
BeltHolderES           = ["BHES",  "Belt Holder 3", "L", "", [35,45,55,66] ];
BeltHolderTensionner   = ["BHT",   "Belt Holder 2", "",  "T", [35,41,59.5,66]];
BeltHolderTensionnerCH = ["BHTCH", "Belt Holder 4", "X", "T", [35,41,59.5,66]];

function belthoder_desc(type) = type[1];
function belthoder_extra(type) = type[2];
function belthoder_hole(type) = type[4];

function is_belthoder_tensionner(type) = type[3] == "T";

belt_holder_color					= "yellow";

module BeltHolderType(front,type)
{

	tensionL=25;
	tensionW=16;
	tensionH=4.5;

	tensionY=51.5;

	translate([0, 0, tensionH])  rotate([0,180,0]) { 
		color(belt_holder_color)  difference() {
			union(){
				translate([-tensionL/2,0,0])	cube([25,75,tensionH]);
				translate([-tensionL/2,0,-3])	cube([3,75,tensionH]);
				translate([tensionL/2-3,0,-3])	cube([3,75,tensionH]);
				if (is_belthoder_tensionner(type)) translate([-tensionL/2,tensionY-tensionW/2,-3.9]) cube([tensionL,tensionW,3.9]); //cylinder(d=16, h=5);
				
				if (belthoder_extra(type)=="L") translate([tensionL/2-5,5,-7]) cube([5,60,tensionH+7]);
				else if (belthoder_extra(type)=="R") translate([-tensionL/2,5,-7]) cube([5,60,tensionH+7]);
				else if (belthoder_extra(type)=="X") translate([-tensionL/2-20,40,-5.5]) {
					rotate([0,0,-90]) chain_link_belt_holder();					
				}
			}
			for(i=[10, 30]) { 
				translate([0,i,-20.2]) M5Hole(l=41);
			}
			for(i=belthoder_hole(type)) { 
				ww=2.5;
				translate([-8/2,i,-0.1]) cube([8,ww,tensionH+1]);
			}
			if (is_belthoder_tensionner(type)) {
				translate([0,tensionY,0])  {
					translate([0,0,-20.2]) M5Hole(l=41);
					translate([0,0,-4]) M5RHexa(l=4);
				}
			}
			if (belthoder_extra(type)=="L") {
				for(i=[10, 60]) { 
					translate([6,i,-2]) rotate([0,90,0]) M3Thread(l=10);
				}
			}
			else if (belthoder_extra(type)=="R") {
				for(i=[10, 60]) { 
					translate([-15,i,-2]) rotate([0,90,0]) M3Thread(l=10);
				}
			}
		}
		if (showExtra) {
			if (is_belthoder_tensionner(type)) {
				for(i=[10, 30]) { 
					translate([0,i, 0]) 
						rotate([0,180,0]) drawScrew("M5x25");
					translate([0,i,tensionH+5]) rotate([0,0,0])  precisionShim10x5x10();
				}
				translate([0, tensionY, 10]) rotate([0,0,0]) drawBolt("M5x16", posNut=10.4);
				translate([0, tensionY, -7-exploded*20]) rotate([180,0,0])  Tensioner();
			} else {
				for(i=[10, 30]) { 
					if (front)
					translate([0,i, 0])  rotate([0,180,0]) drawScrew("M5x16");
					else
					translate([0,i, 0])  rotate([0,180,0]) drawScrew("M5x20");
				}
			}
		}
	}
}
module BeltHolder(front)
{
	BeltHolderType(front,type=BeltHolder);
	
}

module BeltHolderES(front)
{
	BeltHolderType(front,type=BeltHolderES);
}

module BeltTensioner()
{
	BeltHolderType(type=BeltHolderTensionner);
}

module BeltTensionerCH()
{
	BeltHolderType(type=BeltHolderTensionnerCH);
}



module BeltHolder2(h=40.5)
{

	tensionL=25;
	tensionW=16;
	tensionH=4.5;

	color(belt_holder_color) translate([0, 0, tensionH])  rotate([0,180,0]) { 
		difference() {
			union() {
				translate([-tensionL/2,18,0])	cube([25,55,tensionH]);
				translate([-40,18,0])	cube([50,23,tensionH]);
				translate([-tensionL/2,18,-3])	cube([3,55,tensionH]);
				translate([tensionL/2-3,18,-3])	cube([3,55,tensionH]);
			}
			for(i=[30]) { 
				translate([0,i,-20.2]) M5Hole(l=41);
				translate([-25,i,0])  rotate([0,0,90])  drawHul("M5",gap=15);
			}
			for(i=[35,45,55,66]) { 
				translate([-8/2,i,-0.1]) cube([8,3,h+1]);
			}
		}
		if (showExtra) {
			for(i=[30]) { 
				translate([0,i, 0])  rotate([0,180,0]) drawScrew("M5x20");
				translate([-30,i, 0])  rotate([0,180,0]) drawScrew("M5x20");
			}
		}
	}
}


module Tensioner()
{
	tensionL=25;
	tensionW=16;
	tensionH=3;
 
	color("red") translate([0,0,tensionH/2]) {
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
			translate([0,0,-9.9]) rotate([180,0,0]) _MXHole(name="M5", l=10, hcld=1.0);
		}
	}
}


module AngularSpacer2()
{
	$fn=60;
	heigth=40;
	large=20;
	radius=10;
	color("red") difference() {
		translate([-5,0,0])  cube([10,large,heigth], center=true);
		translate([-11,0,0])  cube([10,large+.2,heigth+1], center=true);
		translate([-radius,0,0]) difference() {
			translate([0,0,0])  cube([60,60,heigth+1], center=true);
			translate([0,0,0])  cylinder(r=radius,h=heigth+2, center=true);
		}
		translate([-8,0,10])  rotate([0,90,0])  M5Hole(l=10);
		translate([-8,0,-10])  rotate([0,90,0])  M5Hole(l=10);
	}
}
module XAxisSpacer()
{
	$fn=60;
	long=41;
	large=20;
	height=3.2;
	radius=20;
	color("red") render() difference() {
		translate([0,0,height/2])  cube([large,long,height], center=true);
		translate([0,0,-radius+height]) rotate([90,0,0])  difference() {
			translate([0,0,0])  cube([radius*1.5,radius*2+5,long+1], center=true);
			translate([0,0,0])  cylinder(r=radius,h=long+2, center=true);
		}
		translate([-0,10,-1])  rotate([0,0,0])  M5Hole(l=20);
		translate([-0,-10,-1])  rotate([0,0,0])  M5Hole(l=20);
		translate([-4,15,-10]) cube([8,3,21]);
	}
}


