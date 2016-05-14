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

include <scad/cable_chain.scad>


print_chain(2,6);
//chain_cut_view();

translate([60,0,0]) {
	translate([20,0,0]) mirror([1,0,0]) chain_link_yaxis_mobil2(pos=2);
	chain_link_xaxis_mobil(pos=4);

	translate([60,20,0]) {
		translate([0,0,20]) {
			rotate([90,0,0]) square_chain_link_holder_front();
			translate([0, 60, 0]) rotate([-90,0,0])  square_chain_link_holder_back();
		}
		chain_link_yaxis_static(pos=1);
	
	}

}

//translate([220,0,0]) {
//	chain_link_yaxis_mobil(pos=0);
//	translate([20,0,0]) mirror([1,0,0]) chain_link_yaxis_mobil(pos=2);
//	chain_link_yaxis_mobil2(pos=4);
//}

