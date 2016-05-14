// Birdie CNC - TB6560 spacer - a OpenSCAD 
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



module spacer()
{
	$fn = 20;
	thick = 0.6;
	width = 14;
	length = 36;
	dia = 3.9;
	l = 10;
	color(square_chain_link_color) difference() {
		difference() {
			cube([length, width, thick], center=true);
			for (i = [-1,1])  hull () {
				translate([i*15,0]) 
				cylinder(r=dia/2, h=l,  center=true);
				translate([i*20,0]) 
				cylinder(r=dia/2, h=l,  center=true); 
			}
		}
	}
}


spacer();
