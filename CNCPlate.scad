// Birdie CNC - Plates - a OpenSCAD 
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
use <scad/vslot.scad>
use <scad/vitamins/stepper-motors.scad>

showExtra=0;
showModule=0;
cutView=0;
exploded=0;

module platesYAxis_test()
{

	translate([-170,0,0]) PlateYAxisRight();

	translate([15,0,0])  PlateYAxisLeft(); 
	
}

module platesXAxis_test()
{
	translate([-170,0,0]) PlateXAxisFront();
	
	translate([15,0,0])  PlateXAxisBack();

	translate([180,00,0]) rotate([0,0,0]) ModuleZSpacerLeft();
		
	translate([220,00,0]) rotate([0,0,0]) ModuleZSpacerRight();

	if (VSlotSpacingAdjustPartType==2) translate([300,15,0]) rotate(90) ModuleBottom();

}

module platesZAxis_test()
{
	translate([0,0,0]) ZAxisPlateMotorHolder();	
	translate([0,140,0]) rotate([0,0,90])  AntiBacklash();
	translate([0,80,0])  XAxisEndstopHolder();
	translate([90,50,0]) BeltHolder();
	translate([150,90,0]) JoiningPlate();
	//translate([80,0,0]) ZAxisMountView(withWheel=withWheel);
}


module allplates_test()
{
	$fn=30;
	translate([0,100,0])	platesYAxis_test();
	translate([0,-100,0])	platesXAxis_test();
	translate([200,50,0])	platesZAxis_test();
	
	
}

$fn=30;
allplates_test();
//ZAxisMountView(t=0);
//XAxisEndstopHolder();
//PlateXAxisFront();
