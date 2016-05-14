// CNC - TB6560  - a OpenSCAD 
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

$fn=30;

POWER_BOXE_180W = [200, 100, 44];
POWER_BOXE_240W = [200, 109, 50];
POWER_MINI_180W = [200, 60, 40];
POWER_MINI_360W = [160, 110, 45];
POWER_MINI_240W = [165, 100, 45];

power_boxe_type = POWER_MINI_360W;
//power_boxe_type = POWER_BOXE_240W;
function power_boxe_length() = power_boxe_type[0];
function power_boxe_width() = power_boxe_type[1];
function power_boxe_heigth() = power_boxe_type[2];
bracket_heigth = power_boxe_heigth() + 15;

// Enclosure boxe
boxe_size=[216, 228];
boxe_length = boxe_size[0];
boxe_width = boxe_size[1];

// TB6560 board module size 
TB6560_hole_width=42.5;
TB6560_hole_length=68.5;

screw_hole_dia=2;

half_boxe = 0;

module boxe()
{
	vtin = 3.20;
	heigth = 46.18;
	module hole(d, h)
	{
		rotate([0,180,0]) {
		translate([204/2, 25, 0]) cylinder(d=d, h=h, center=false);
		translate([204/2, 199, 0]) cylinder(d=d, h=h, center=false);
		
		}

	}
	module hole2(d=5.66, h=4.47)
	{
		rotate([0,180,0]) {
			translate([204/2, 41, 0]) cylinder(d=d, h=h, center=false);
			translate([204/2, 89, 0]) cylinder(d=d, h=h, center=false);
			translate([204/2, 178, 0]) cylinder(d=d, h=h, center=false);
		}
	}
	module halfBoxe(top=true) {
		module half(top=true) {
			color([.4,.4,.2]) translate([0, 0, 0]) {
				translate([0, 0, heigth-vtin]) {
					difference() {
						 union() {
							cube([boxe_width/2,boxe_length, vtin], center=false);
							if (top5)
							for(y=[2, 8, boxe_length-4, boxe_length-10])
								translate([0, y, -6]) cube([boxe_width/2, 2, 6]);
							
							hole(d=7.25, h=43);
							hole2();	
						}
						if (!top)
							translate([0, 0, -1]) hole(d=3, h=50);
						translate([0, 0, 1]) hole2(d=3, h=10);
						for(x=[10:10:75])
							translate([x, 151, -1]) cube([3, 38.8, 5]);
					
					}
				}
				 	//cube([236/2,boxe_length, 1.2], center=false);
				//#translate([237/2-4.46, 0, 0]) rotate([0, -105,0]) translate([0,0,0]) cube([46.60, boxe_length, 4.46], center=false);
				translate([237/2-4.46, 0, 0]) rotate([0, -5,0]) {
					cube([4.46, boxe_length, 46.60], center=false);
					for(y=[2, 8, boxe_length-4, boxe_length-10])
						translate([-6, y, 0]) cube([6, 2, 46.60]);
					
				}
			}
		}
		half(top);
		mirror([1,0,0]) half(top);
	
	}
	translate([0, 0, heigth-vtin]) {
		if (!half_boxe) halfBoxe(true);
		mirror([0,0,1]) halfBoxe(false);
	}
}

module tb6560()
{
	translate([0, 0, -1.6]) {
		
		translate([0, 0, 0.8]) {
			difference() {
				union() {
					color([.1,.4,.2])  {
						cube([75.15, 50.20, 1.60], center=true);
						translate([-32.5, 0, 7.5]) cube([10.24, 30, 14.3], center=true);
						translate([32.5, 0, 7.5]) cube([10.24, 30, 14.3], center=true);
						
					}
					color([.2,.2,.2])  {
						translate([22, -20, 9.5]) cylinder(d=10.23, h=19, center=true);
						translate([0, -20, 7.5]) cylinder(d=6.73, h=15, center=true);
					}
			
				}
			for(x=[-1,1])
				for(y=[-1,1])
					translate([x*TB6560_hole_length/2, y*TB6560_hole_width/2, -25]) cylinder(d3, h=30);			
			}
		}
		translate([-11, 0, -11/2-5.6]) cube([40, 50, 11], center=true);
		color([0.2, 0.2, 0.2]) translate([-11, 0, -6/2]) cube([15, 35, 6], center=true);
	}
}

bracket_top_hole = power_boxe_width() > 66 ? power_boxe_width()/2 - 33 + 1 : 1 ;
bracket_width = 10; 

module screw_hole(h=20)
{
		cylinder(d=screw_hole_dia, h=h);
}


module bracket() {
	tin = 6;
	heigth = bracket_heigth;
	width = bracket_width;
	top_width = 7;
	top_tin = 5;
	module bra1() {
		difference() {
			color([.1,.5,.9]) union() {
				translate([0, width, 0]) rotate([0,0,180]) cube([5, width, tin*2]);
				cube([tin, width, heigth+top_tin]);
				translate([0, 0, heigth]) cube([tin+bracket_top_hole+3.5, top_width, top_tin]);
				//if (width>14) #translate([8, width/2-1.5, heigth]) rotate([0, 0, 0]) cylinder(d=13, h=4, $fn=3);
				translate([tin, width/2+1, heigth]) rotate([0, 0, 0]) cylinder(r=width/2-1, h=top_tin, $fn=30);
			}
			translate([tin+bracket_top_hole, top_width/2, heigth-1]) screw_hole();
			translate([-0, width/2, -0.4]) screw_hole(h=tin*2);
		}
	}
	module bra2() {
		difference() {
			color([.1,.5,.9]) union() {
				translate([0, width, 0]) rotate([0,0,180]) cube([6+2, width, 3]);
				//translate([-6, width, 0]) rotate([0,0,180]) cube([2, width, tin+2]);
				cube([tin, width, heigth+top_tin]);
				translate([0, 0, heigth]) cube([tin+bracket_top_hole+3.5, top_width, top_tin]);
				//if (width>14) #translate([8, width/2-1.5, heigth]) rotate([0, 0, 0]) cylinder(d=13, h=4, $fn=3);
				translate([tin, width/2+1, heigth]) rotate([0, 0, 0]) cylinder(r=width/2-1, h=top_tin, $fn=30);
			}
			translate([tin+bracket_top_hole, top_width/2, heigth-1]) screw_hole();
			translate([-3-1, width/2, -0.4]) screw_hole(h=tin*2);
		}
	}
	bra2();
}

module single_fixing(double=0)
{
	single_length = 14;
	double_length = 17;
	bwidth=bracket_width+0.6;
	width=8;
	heigth=6;
	
	module single(hole=1) {
		translate([-3, width/2, 0]) 
		difference() {
			translate([-width/2, -7, 0]) cube([width, single_length, heigth]);
			translate([-width/2-.1, -bwidth/2, -0.02]) cube([width+.2, bwidth, 3.02]);
			if(hole) translate([0, 0, -0.01]) screw_hole(h=10);
		}
	}
	module double()
	{
		single(0); 
		translate([0, -double_length, 0]) single(0);
		if (double_length > single_length) {
			translate([-3, width/2, 0]) {
				
					cube_len = double_length-single_length+2;
					translate([0, -single_length/2-(double_length-single_length)/2, 0]) {
						difference() {
							translate([-width/2, -cube_len/2, 0]) cube([width, cube_len, heigth]);
							translate([0, 0, -0.01]) screw_hole(h=20);
						}
					}
				 
			}
		} 
	}
	if (double) double();
	else single();
}

module double_fixing()
{
	single_fixing(double=1);
}

module fullView(){
	module tb6560bracket(num)
	{
		module half(num) {
			xx = power_boxe_width()/2+7;
			xx = bracket_top_hole + 40;
			translate([-xx, -TB6560_hole_width/2-3, 0])  { 
				bracket(); 				
				if (num==0 || num==5) translate([-1, 0, 0]) single_fixing();
				if (num==1 || num==3) translate([-1, 0, 0]) double_fixing();
			}
			
			translate([xx, -TB6560_hole_width/2-3, 0]) mirror([1,0,0]) {
				bracket();
				if (num==0 || num==5) translate([-1, 0, 0]) single_fixing();
				if (num==1 || num==3) translate([-1, 0, 0]) double_fixing();
			}
		}
		half(num=num);
		mirror([0,1,0]) half(num=num+1);
		translate([0,0, bracket_heigth+6.5]) tb6560();
	}
	module powerboxe()
	{
		translate([0, power_boxe_length()/2, power_boxe_heigth()/2]) cube([power_boxe_width(),power_boxe_length(),power_boxe_heigth()], center=true);
	}
	module arduino()
	{
		translate([0, 102/2, 24/2]) cube([60, 102, 24], center=true);
	}
	//boxe();
	//translate([-75, 50, 10]) arduino();
	translate([27, 0, 0]) {
		posx=(boxe_length-power_boxe_length())/2 > 10 ? (boxe_length-power_boxe_length())/2 : 10; 
		//translate([0, (boxe_length-power_boxe_length())/2, 0]) powerboxe();
		//translate([0, posx, 0]) powerboxe();
		rotate([0,0,180]) for(y=[0:2])
			//rotate([0,0,180]) translate([0, y*55.5-boxe_length+TB6560_hole_width/2+20, 0])  {
			rotate([0,0,180]) translate([0, y*55.5+38, 0])  {
				tb6560bracket(y*2);
			}
	}
	translate([-40, 17.5, 0]) {
		#cylinder(d=1, h=200);
		translate([134, 0, 0]) #cylinder(d=1, h=200);
		translate([0, 49, 0]) #cylinder(d=1, h=200);
		translate([0, 105, 0]) #cylinder(d=1, h=200);
		 
	}
}

module printBracketX()
{
	rotate([90,0,0]) 
	{
		translate([-50, 0, 0]) for(x=[0:5]) {
			translate([x*9+10, 0, -x*8]) bracket();
			translate([-x*9-10, 0, -x*8]) mirror([1,0,0]) bracket();
		}
	}	
	translate([50, 0, 0]) for(x=[0:3]) {
		translate([x*9, 13, 8]) rotate([180, 0, 0]) double_fixing();
		translate([x*9, -2.5, 8]) rotate([180, 0, 0]) single_fixing();
	}
}
module printBracketA()
{
	
	module spacer()
	{
		translate([4, 7, 1]) difference() {
		 cube([8,14,2],center=true);
		 cylinder(d=1.8, h=10, center=true);
		}
	}
	translate([75, 0, -2]) for(x=[-1:2]) {
		translate([x*10, 13, 8]) rotate([180, 0, 0]) double_fixing();
		translate([x*10, -2.5, 8]) rotate([180, 0, 0]) single_fixing();
	}
//	for(x=[0:2]) {
//		
//		translate([23+10*x, 21.5, 0]) spacer();
//		translate([23+10*x, 36.5, 0]) spacer();
//	}
}
module printBracketB()
{
	rotate([90,0,0]) 
	{
		for(x=[0:3]) {
			translate([x*9+10, 0, -x*8]) bracket();
			translate([-x*9-10, 0, -x*8]) mirror([1,0,0]) bracket();
		}
	}	
}

module printBracket2()
{
	rotate([90,0,0]) 
	{
		bracket();
		translate([-60, 0, 0]) mirror([1,0,0]) bracket();
		//translate([-0, 0, 0]) double_fixing();
	}	
	translate([50, 0, 8]) rotate([180, 0, 0]) double_fixing();
	translate([30, 0, 8]) rotate([180, 0, 0]) single_fixing();
}

translate([0, 50, 0]) fullView();
//printBracketA();
//printBracketB();
