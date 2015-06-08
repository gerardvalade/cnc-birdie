TypeYAxisLeft 	= [1, "Plate YAxisLeft",  110, 180, 20];
TypeYAxisRight 	= [2, "Plate YAxisRight", 110, 180];
TypeXAxisBack 	= [3, "Plate XAxisBack",  115, 142];
TypeXAxisFront 	= [4, "Plate XAxisFront", 115, 130];
TypeBottom 		= [5, "Bottom", 0, 0]; 
SpacerLeft 		= [6, "SpacerLeft"];
SpacerRight 	= [7, "SpacerRight"];

function plate_type(type) = type[0];
function plate_desc(type) = type[1];
function plate_width(type) = type[2];
function plate_height(type) = type[3];
function plate_thickness() = 8;
function plate_extra_width(type) = TypeYAxisLeft[4];

//Modules types
function ModuleTypeYAxisLeft(type) = type[0]==1;
function ModuleTypeYAxisRight(type) = type[0]==2;
function ModuleTypeXAxisBack(type) = type[0]==3;
function ModuleTypeXAxisFront(type) = type[0]==4;
function ModuleBottom(type) = type[0]==5;
function ModuleSpacerLeft(type) = type[0]==6;
function ModuleSpacerRight(type) = type[0]==7;
function ModuleTypeYAxis(type) = type[0]==1 || type[0]==2;
function ModuleTypeXAxis(type) = type[0]==3 || type[0]==4;


// Main plate thickness
PlateThickness=8;
// Z Spacer thickness
ZSpacerThickness=16;
ZSpacerSocle=13;


// VSlot spacing adjust mount thickness
VSlotSpacingAdjustThickness=12;

// Spacing of wheels for 20x40 V slot rail
// Not tested, must be adjust for 3D print
// 59.55~59.70
//VSlotWheelSpacing20x40_Y=59.60; 
VSlotWheelSpacing20x40_X=59.70; 
VSlotWheelSpacing20x40_Y=59.10; 
VSlotWheelSpacing20x40_Z=59.10; 


Hole_Plate=PlateThickness+4;
color_module_plateX       		= "LawnGreen";//[0.87, 0.27, 0.3];
color_module_plateY       		= "ForestGreen";//[0.87, 0.27, 0.3];
color_module_plate2 			= "SpringGreen";//[0.97, 0.17, 0.3];
color_module_spacer 			= "DeepSkyBlue";//[0.07, 0.87, 0.93];
color_module_anitbacklash 		= "Lime";// [0.07, 0.87, 0.03];
color_module_anitbacklash_cover = "OliveDrab"; //[0.77, 0.87, 0.03];
color_module_nema_holder 		= "Aquamarine"; //[0.9,0.4,0.2];
color_cut_view 					= "red";
color_extractor					= "yellow";
color_brim 						= "pink";
module color_nema_holder() {color("black");}

VSlotSpacingAdjustPartType = 1;
//VSlotWheelMount_refY=70.60;
VSlotWheelMount_refY=69.00;
showExtra=0;
showModule=0;
addBrims=1;

