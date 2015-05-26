// Birdie CNC - Belt holder - a OpenSCAD 
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

$fn=30;
exploded=0;
showExtra=0;
showModule=0;

translate([-25,-70,0]) BeltHolder();
translate([-80,-70,0]) BeltHolder3();
translate([25,-25,0]) JoiningPlate();
translate([-25,25,0]) BeltTensioner();
translate([25,70,0])  Tensioner();
