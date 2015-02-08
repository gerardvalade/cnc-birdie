// Add resolve undef
M3_grub_screw  = ["GB030", "M3 grub screw", 13];
M4_grub_screw  = ["GB040", "M4 grub screw", 14];
function screw_radius(type) = type[3] ;


module vitamin(code, desc, category) {
	echo(str("BOM: ",code," - ", desc, "; ", category));
}

// end Add resolve undef
