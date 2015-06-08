// Birdie CNC - cable chain - a OpenSCAD 
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

ChainLink 	      = ["CL",     "Chain Link",           28, 1, 1];
XAxisBeltHolder   = ["CLBH",   "Chain Link Back End",  28, 0, 1];
XAxisMobil	 	  = ["CLXAM",  "Chain Link Front End", 28, 1, 0];
YAxisStatic  	  = ["CLYAS",  "Chain Link Back End",  28, 0, 1];
YAxisMobil  	  = ["CLYAM",  "Chain Link Front End", 28, 1, 0];
YAxisMobil2 	  = ["CLYAM2", "Chain Link Front End", 28, 1, 0];


function chainlink_desc(type) = type[1];
function chainlink_length(type) = type[2];
function chainlink_height(type) = 10;
function chainlink_width(type) = 20;
function chainlink_gapx(type) = 0.5;
function chainlink_gapy(type) = 0.8;
function is_chainlink(type) = type[0] == "CL";
function is_yaxis_static(type) = type[0] == "CLYAS";
function is_yaxis_mobil(type) = type[0] == "CLYAM";
function is_yaxis_mobil2(type) = type[0] == "CLYAM2";
function is_xaxis_mobil(type) = type[0] == "CLXAM";
function is_xaxis_belt_holder(type) = type[0] == "CLBH";

function is_draw_front(type) = type[3] == 1;
function is_draw_back(type) = type[4] == 1;

//width=20;
//heigth=10;
wall_thickness=2;

chain_link_color					= "yellow";
square_chain_link_color				= "green";

module chain_link_type(pos=0, rot=0, type=ChainLink)
{
	length = chainlink_length(type);
	
	
	upper_spacer=4;
	bottom_spacer=8;
	
	bump_dia1=5;
	bump_dia2=3;
	tiny_wall=0.8;
	ypos = pos*(length-chainlink_height(type)/2-5/2-0.5) + bump_dia1/2+0.5;
	 
	module body()
	{
		module xaxis_belt_holder()
		{
					// Middle top
					translate([0,(chainlink_length(ChainLink)-upper_spacer)/2,chainlink_height(type)-wall_thickness]) cube([chainlink_width(type), upper_spacer, wall_thickness]);
					
					// Middle bottom
					translate([-chainlink_gapx(type),10,0]) cube([chainlink_width(type), 5, wall_thickness]);
			
		}
		
	 
		module xaxis_mobil(spacer=4)
		{ 
			difference() {
				union() {
					// Middle top
					translate([0,(chainlink_length(ChainLink)-upper_spacer)/2,chainlink_height(type)-wall_thickness]) cube([chainlink_width(type), upper_spacer, wall_thickness]);
					
					// Middle bottom
					translate([-chainlink_gapx(type),10,0]) cube([chainlink_width(type), 5, wall_thickness]);

					translate([-(24-chainlink_width())/2, -wall_thickness*2, 0]) {
						cube([ 24, wall_thickness*2 ,25]);
						translate([0, -3, 20]) cube([24,wall_thickness*2+chainlink_gapx(type), 5]);
						
					}
			
				}
			
				translate([10,0,12]) rotate([90,0,0])  M3Hole();// cylinder(d=3.1,h=60,center=true, $fn=10);
			}
		}
		 

		module yaxis_static(spacer=4)
		{ 
			difference() {
				union() {
					// Middle top
					translate([0,(chainlink_length(ChainLink)-upper_spacer)/2,chainlink_height(type)-wall_thickness]) cube([chainlink_width(type), upper_spacer, wall_thickness]);
					
					// Middle bottom
					translate([-chainlink_gapx(type),10,0]) cube([chainlink_width(type)+chainlink_gapx(type)*2, 12, wall_thickness]);
					translate([-chainlink_gapx(type),20,0]) cube([chainlink_width(type)+chainlink_gapx(type)*2, 10, wall_thickness*2]);
			
				}
			
				translate([chainlink_width(type)/2,chainlink_height(type)/2+20,7]) rotate([0,0,0]) cylinder(d=3.1,h=60,center=true, $fn=10);
			}
		}
		 
		
		module yaxis_mobil(spacer=4)
		{ 
			difference() {
				union() {
					// Middle top
					translate([0,(chainlink_length(ChainLink)-upper_spacer)/2,chainlink_height(type)-wall_thickness]) cube([chainlink_width(type), upper_spacer, wall_thickness]);
					
					// Middle bottom
					translate([-chainlink_gapx(type),0,0]) cube([chainlink_width(type), 12, wall_thickness]);
					
//					translate([chainlink_width(type)-wall_thickness*2+8, length-chainlink_height(type)/2-7, 0]) {
//						cube([wall_thickness*2+chainlink_gapx(type), 17 ,18]);
//						translate([3, 0, 0]) cube([wall_thickness*2+chainlink_gapx(type), 5 ,18]);
//						translate([-8, 0, 0]) cube([8, 7 ,chainlink_height(type)]);
//					}
					translate([-wall_thickness*2-spacer, -10, 0]) {
						cube([wall_thickness*2+chainlink_gapx(type), 17 ,14]);
						translate([-3, 12, 0]) cube([wall_thickness*2+chainlink_gapx(type), 5 ,14]);
						translate([4, 10, 0]) cube([spacer, 7 ,chainlink_height(type)]);
					}
			
				}
			
				//translate([30,length-chainlink_height(type)/2+6,9]) rotate([0,90,0]) cylinder(d=3.1,h=20,center=true, $fn=10);
				translate([-10,chainlink_height(type)/2-11,7]) rotate([0,90,0])  M3Hole();//cylinder(d=3.1,h=20,center=true, $fn=10);
			}
		}

		module yaxis_mobil2(spacer=4)
		{ 
			difference() {
				union() {
					// Middle top
					translate([0,(chainlink_length(ChainLink)-upper_spacer)/2,chainlink_height(type)-wall_thickness]) cube([chainlink_width(type), upper_spacer, wall_thickness]);
					
					// Middle bottom
					translate([-chainlink_gapx(type),0,0]) cube([chainlink_width(type), 12, wall_thickness]);
					
					translate([-wall_thickness*2-spacer, -17, 0]) {
						cube([wall_thickness*2+chainlink_gapx(type), 24 ,14]);
						translate([-3, 0, 0]) cube([wall_thickness*2+chainlink_gapx(type), 5 ,14]);
						translate([4, 17, 0]) cube([spacer, 7 ,chainlink_height(type)]);
					}
			
				}
			
				translate([-10,chainlink_height(type)/2-9,7]) rotate([0,90,0])  M3Hole();
			}
		}
		 
		 
		difference() {
			union() {
				difference() {
					// Main Object
					union() {
						translate([-chainlink_gapx(type),0,0]) cube([chainlink_width(type)+chainlink_gapx(type)*2,length-chainlink_height(type)/2 ,chainlink_height(type)]);
						if (is_draw_front(type)) {
							translate([0, length-chainlink_height(type)/2, chainlink_height(type)/2]) rotate([0,90,0])  cylinder(r=chainlink_height(type)/2, h=chainlink_width(type), $fn=40);
						}
					
					}
					// Hole in the Middle
					translate([wall_thickness*2,-1,-1]) cube([chainlink_width(type)-wall_thickness*4,length+2 ,chainlink_height(type)+2]);

					if (is_draw_front(type)) {	
						for(mat=[[wall_thickness-tiny_wall,0], [chainlink_width(type)-wall_thickness+tiny_wall,180]]) {
							x=mat[0];
							rx=mat[1];
							translate([x, length-chainlink_height(type)/2, chainlink_height(type)/2]) rotate([rx,90,0]) cylinder(wall_thickness, bump_dia1/2, bump_dia2/2, $fn=40);
						}
						ww=chainlink_height(type)/2+bump_dia1/2+chainlink_gapy(type);
						for(x=[-chainlink_gapx(type)-0.01, chainlink_width(type)-wall_thickness]) {
							translate([x, length-ww, -1]) cube([wall_thickness+chainlink_gapx(type)+0.01, length/2 ,chainlink_height(type)+2]);
						}
					}
						
				}
			}
			if (is_draw_back(type)) {
				translate([wall_thickness-chainlink_gapx(type),bump_dia1/2+0.5, chainlink_height(type)/2]) rotate([0,90,0]) cylinder(r=chainlink_height(type)/2+1, h=chainlink_width(type)-wall_thickness*2+chainlink_gapx(type)*2, $fn=40);
				translate([chainlink_width(type)/2,bump_dia1/2+0.5, chainlink_height(type)/2]) rotate([45,0,0]) translate([0,0,10.4]) cube([chainlink_width(type)+4*chainlink_gapx(type),15,15], center=true);
			}
			
		}	
		if (is_chainlink(type)) 
		{
			// Middle top
			translate([0,(length-upper_spacer)/2,chainlink_height(type)-wall_thickness]) cube([chainlink_width(type), upper_spacer, wall_thickness]);
			// Middle bottom
			translate([0,(length-bottom_spacer)/2,0]) cube([chainlink_width(type), bottom_spacer, wall_thickness]);
		}

		if (is_xaxis_mobil(type)) xaxis_mobil();
		else if (is_xaxis_belt_holder(type)) xaxis_belt_holder();
		else if (is_yaxis_static(type)) yaxis_static();
		else if (is_yaxis_mobil(type)) yaxis_mobil();
		else if (is_yaxis_mobil2(type)) yaxis_mobil2();
		
		if (is_draw_back(type)) {
			bump_gap=0;
			for(mat=[[wall_thickness-chainlink_gapx(type)-tiny_wall-bump_gap,0], [chainlink_width(type)-wall_thickness+chainlink_gapx(type)+tiny_wall+bump_gap,180]]) {
				x=mat[0];
				rx=mat[1];
				translate([x, bump_dia1/2+0.5, chainlink_height(type)/2]) rotate([rx,90,0]) cylinder(2,bump_dia1/2,bump_dia2/2, wall_thickness, $fn=40);
			}
		}
	}
	translate([0,ypos,+chainlink_height(type)/2])	rotate([rot,0,0]) translate([0,-bump_dia1/2-0.5,-chainlink_height(type)/2]) body();
	
}

module chain_link(pos=0, rot=0)
{
	color(chain_link_color) chain_link_type(pos, rot, ChainLink);
}

module chain_link_belt_holder(pos=0, rot=0)
{
	color(chain_link_color) chain_link_type(pos, rot, XAxisBeltHolder);
}

module chain_link_yaxis_static(pos=0, rot=0)
{
	color(chain_link_color)	chain_link_type(pos, rot, YAxisStatic);
}
module chain_link_yaxis_mobil(pos=0, rot=0)
{
	color(chain_link_color)	chain_link_type(pos, rot, YAxisMobil);
}
module chain_link_yaxis_mobil2(pos=0, rot=0)
{
	color(chain_link_color)	chain_link_type(pos, rot, YAxisMobil2);
}
module chain_link_xaxis_mobil(pos=0, rot=0)
{
	color(chain_link_color)	chain_link_type(pos, rot, XAxisMobil);
}

module square_chain_link_holder_back()
{
	$fn = 20;
	thick = 5;
	width = 20;
	length = 40;
	
	color(square_chain_link_color) difference() {
		union() {
			cube([thick, width, length]);
			cube([length, width, thick]);
			translate([0, 15, 0]) cube([thick*2, thick, length]);
			translate([0, 15, 0]) cube([length, thick, thick*3]);
		}
		for(i=[10,30]) {
			translate([0, 10, i]) rotate([0, 90, 0]) M5Hole();
		}
		translate([30, 10, 0]) rotate([0, 0, 0]) M3Hole();
	}
}

module square_chain_link_holder_front()
{
	mirror([0, 1, 0]) square_chain_link_holder_back();
}


module print_chain(nbrow=2, nbcol=4) {
	for(i=[0:(nbrow-1)]) {
		translate([i*(chainlink_width()+chainlink_gapx()*2+0.5),0,0]) for(j=[0:(nbcol-1)]) {
			chain_link(pos=j);
		}
	}
}	

module chain_cut_view(nb=2) {
	difference() {
		union() {
			for(i=[0:(nb-1)]) chain_link(pos=i);
			posy=(length-chainlink_height(type)/2-5/2-0.5)*3;
			chain_link(pos=nb,rot=45);
		}
		//translate([chainlink_width(type)/2,8,14]) cube([chainlink_width(type)+5,30,30], center=true);
		//translate([chainlink_width(type)/2,18,14]) cube([chainlink_width(type)+5,50,30], center=true);
		translate([chainlink_width(type)/2,38,0]) cube([chainlink_width(type)+5,80,chainlink_height(type)], center=true);
	}
}	

