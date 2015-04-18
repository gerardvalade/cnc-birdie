// Birdie CNC - Plate utililties functions - a OpenSCAD 
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
include <undef.scad>
include <nutsnbolts/cyl_head_bolt.scad>;
include <nutsnbolts/materials.scad>;

include <vitamins/washers.scad>
include <ob_wheel.scad>
include <shim.scad>
include <vitamins/stepper-motors.scad>
include <vitamins/belts.scad>
include <vitamins/pullies.scad>
include <vitamins/springs.scad>

stepper_body_color = [0.27, 0.27, 0.3];
stepper_cap_color = Aluminum;
nut_color = [0.27, 0.27, 0.3];;
spring_color = [0.67, 0.27, 0.3];
screw_pan_color = [0.67, 0.27, 0.3];
screw_cap_color = [0.37, 0.37, 0.3];


NEMA17HolesSpacing=31.00;

NEMA23HolesSpacing=47.14;

exploded=0;

// clearance  : desc, cld=dia clearance, clk=dia hexagone clearance 
data_screw_cl = [
                ["M2.5",  0.30,  0.20],
                ["M3",    0.40,  0.25],
                ["M4",    0.40,  0.30],
                ["M5",    0.40,  0.30],
                ["M8",    0.42,  0.30]
                ];
function _get_cl(n)  = data_screw_cl[search([n], data_screw_cl)[0]];
function _get_cld(n) = _get_cl(n)[1]; // dia clearance 
function _get_clk(n) = _get_cl(n)[2]; // clearance for hexagone


module _MXHexa(name="M3", l=10)
{
	nutcatch_parallel(name, l=l, clk=_get_clk(name));
}

module _MXHole(name="M3", l=10, h=0, hcld=0.1)
{
	hole_through(name, l=l, cld=_get_cld(name), h=h, hcld=hcld);
}

module M3Hexa(l=10)
{
	rotate([180,0,0]) _MXHexa(name="M3", l=l);
}

module M3Hole(l=10)
{
	rotate([180,0,0]) _MXHole(name="M3", l=l);
}

module M3Thread(l=10)
{
	rotate([180,0,0]) hole_threaded(name="M3", l=l, cltd=0.1);
}


module drawM3HoleThrought(l=10, h=5, hcld=0.5) 
{
	_MXHole(name="M3", l=l, h=h, hcld=hcld);
}

module M5Hexa(l=10)
{
	_MXHexa(name="M5", l=l);
}

module M5RHexa(l=10)
{
	rotate([180,0,0]) _MXHexa(name="M5", l=l); 
}

module M5Hole(l=10)
{
	rotate([180,0,0]) _MXHole(name="M5", l=l);
}

module drawM5HoleThrought(l=10, h=5, hcld=0.8) 
{
	_MXHole(name="M5", l=l, h=h, hcld=hcld);
}

module M8Hexa(l=6.5)
{
	rotate([180,0,0]) _MXHexa(name="M8", l=l);
}

module drawHul(name="M3", l=10, gap=0)
{
	df   = _get_fam(name);
	orad = df[_NB_F_OUTER_DIA];
	cld  = _get_cld(name);

	hull () {
		translate([0,gap/2]) 
		cylinder(r=(orad/2+cld/2), h=l,  center=true);
		translate([0,-gap/2]) 
		cylinder(r=(orad/2+cld/2), h=l,  center=true); 
	}
}

module drawScrew(name)
{
	stainless() translate([0,0,exploded? _get_length(name) * exploded * 2 : 0]) screw(name);
}

module drawNut(name)
{
	stainless() translate([0,0,-exploded*10]) nut(name);
}


module drawBolt(name, posNut=10)
{
	famkey = _get_famkey(name);
	stainless() {
		translate([0,0,exploded? _get_length(name) * exploded * 1.5 : 0]) screw(name);
		translate([0,0,-posNut-exploded*10]) nut(famkey);
	}
}

module drawBoltLowProfile(name, posNut=10)
{
	famkey = _get_famkey(name);
	stainless() {
		#translate([0,0,exploded? _get_length(name) * exploded * 1.5 : 0]) screw(name);
		translate([0,0,-posNut-exploded*10]) nut(famkey);
	}
}

/* Nema Hole */
module NemaHolder(depth=10, nemaHoldeRad=11.4, nema17=true, nema23=false, gap=0, showMotor=0, rot=0, mat=[[-1, 1],[-1, -1],[1, 1],[1,-1]]) {
	
	
	if (showMotor) {
		rotate([0,0,rot]) {
			NEMA17StepperMotor(showMotor);
			for (i = mat) 
			{
				if (showMotor <= 1)
					translate([i[0]*NEMA17HolesSpacing/2, i[1]*NEMA17HolesSpacing/2, 8]) drawScrew("M3x16");
				else
					translate([i[0]*NEMA17HolesSpacing/2, i[1]*NEMA17HolesSpacing/2, 14]) drawScrew("M3x16");
			}
		}
	}
	else {
		translate([0,0,depth/2-2]) hull () {
			translate([0,gap, 0]) 
				cylinder(r=nemaHoldeRad,h=depth, center=true);
			translate([0,-gap, 0]) 
				cylinder(r=nemaHoldeRad,h=depth, center=true);
		}
		for (i = mat) 
		{
			/* Nema17 mounting */
			if(nema17) {
				rotate([0,0,rot]) translate([i[0]*NEMA17HolesSpacing/2,i[1]*NEMA17HolesSpacing/2,depth/2-2])
				rotate([0,0,-rot])  drawHul("M3", l=depth, gap=gap);
			}
			/* Nema23 mounting */
			if(nema23) {
				rotate([0,0,rot]) translate([i[0]*NEMA23HolesSpacing/2,i[1]*NEMA23HolesSpacing/2,depth/2-2])
				rotate([0,0,-rot])  drawHul("M4", l=depth, gap=gap);
			}
		}
	}
}

module precisionShim10x5x1() {
	shim(10,5,1,"precision-shim", "Precision Shim");
}


module precisionShim10x5x10() {
	shim(10,5,10,"precision-shim", "Precision Shim");
}

module precisionShim10x5x20() {
	shim(10,5,20,"precision-shim", "Precision Shim");
}


module doubleWheel10(h) {
	translate([0, 0, exploded*10]) {
		translate([0, 0, 5]) precisionShim10x5x10();
		translate([0, 0, 15]) solidWheel();
		translate([0, 0, 30]) precisionShim10x5x20();
		translate([0, 0, 45]) solidWheel();
		translate([0, 0, 55]) precisionShim10x5x10();
	}
	translate([0, 0, -7]) rotate([180,0,0]) drawBolt("M5x80", 74);
}


module wheel10(h) {
	
	translate([0, 0, exploded*15]) {
		translate([0, 0, 5]) precisionShim10x5x10();
		translate([0, 0, 15]) solidWheel();
	}
	translate([0, 0, 20]) {
		drawBolt("M5x35", 28);
	}
}

module wheel20(h) {
	translate([0, 0, exploded*15]) {
		translate([0, 0, 5]) precisionShim10x5x10();
		translate([0, 0, 15]) solidWheel();
	}	
	translate([0, 0, 20]) {
		drawBolt("M5x35", 28);
	}
	
}


module beltBearing10(h) {
	translate([0, 0, 2.4+exploded*10]) {
		translate([0, 0, 2.5]) precisionShim10x5x10();
		translate([0, 0, 10]) ballBearing625_2rs();
		translate([0, 0, 13]) precisionShim10x5x1();
		translate([0, 0, 16]) ballBearing625_2rs();
		translate([0, 0, 18]) { 
			drawBolt("M5x35", posNut=28);
		}
	}
}

module flexibleMotorSaftCoupler8x10()
{
	shim(25,8,31,"flexible-motor-saft-coupler ", "Flexible Motor Shaft Coupler ");
}

module NEMA17StepperMotor(length=1)
{
	translate([0,0,-exploded*28]) NEMA(NEMA17);
	translate([0,0,5]) {
		if (length <= 2)
			translate([0,0,5+exploded*20]) metal_pulley(T5x10_metal_pulley);
		else {
			translate([0,0,15]) flexibleMotorSaftCoupler8x10();
			translate([0,0,15]) cylinder(r=4,h=length, center=false);
		}
	}
}


/*
 *    	  x3
 * y2     |-------|
 * y3  |--|       |
 * y1  |     |----|
 * 0   |-----|
 * 	   0    x1   x2
 */
module XAxisEndstopHolder(length=42, y=11)
{
	mirror() assign(x1=11,x2=17,x3=8, y1=y-7,y2=y,y3=3, xx1=12.5) {
		assign(xx2=xx1+1.80, yy1=y1+4.5) {
			render() difference()
			{
				translate([-4,1,0])  linear_extrude(height=length, center=false, convexity=0, twist=0)
				polygon([[0,0],[x1,0],[x1,y1],[xx1,y1],[xx1,yy1],[xx2,yy1],[xx2,y1],  [x2,y1],[x2,y2],[x3,y2],[x3,y3],[0,y3]]);

				rotate([90,0,0]) for (i = [-1, 1]) 
				{
					hull(){
					translate([-1,21+i*9.5,-5])  rotate([0,0,0]) M3Hole(l=10);
					translate([1,21+i*9.5,-5])  rotate([0,0,0]) M3Hole(l=10);
					}
				}
				translate([-4+xx1,1,length-12]) cube([x2-x1+1,y1+3,14.1]);
			}
		}
	}
	if (showExtra) {
		rotate([90,0,0]) for (i = [-1, 1]) 
		{
			translate([-0,21+i*9.5,-4]) rotate([0,180,0]) drawBolt("M2.5x16", 12);
		}
	}
}


module plateutil_test() {
	difference() {
		translate([-60,-60, 0]) cube([200,200,6]);
		translate([0,0,0]) NemaHolder(20);
	}
	translate([0,0,0]) NemaHolder(20, showMotor=true);
	translate([50,0,6]) wheel10(6);
	translate([80,0,6]) beltBearing10(6);
	translate([110,0,6]) doubleWheel10(6);
}



//plateutil_test();
//spacer_test();
